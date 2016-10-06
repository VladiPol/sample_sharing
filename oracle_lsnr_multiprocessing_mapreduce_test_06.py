#!/usr/bin/env python

# -*- coding: utf-8 -*-
"""
Created on Fri Oct 24 19:47:10 2014

@author: Vladimir Poliakov
"""

import collections
import multiprocessing
import itertools
import re
import datetime

# print_time and debug/info mode flags for output of information
print_time_main_prg = True
print_time_helper   = False
debug_mode          = False
# number of workers for process Pool (default all CPUs)
#
# count_worker = multiprocessing.cpu_count()
#
# count_worker = 4 means 4 processes on 4 CPUs
count_worker = 2
# Lock for Output Console
output_lock = multiprocessing.Lock()

# Mapper for the reading of ORACLE listener
# Read the program connections (PROGRAM and HOST) from he log file
# and mark  this connections with 1
def mapper(filename):
    
    if print_time_helper:
        output_lock.acquire()
        print multiprocessing.current_process().name, 'reading start', filename, 'start_time', datetime.datetime.utcnow(), '\n'
        output_lock.release()
    elif debug_mode:
        output_lock.acquire()
        print multiprocessing.current_process().name, 'reading start', filename, '\n'
        output_lock.release()
    
    mapped_output  = collections.defaultdict(list)
    reduced_output = []

    ##################################################
    # Main Loop
    ##################################################
    # Open the file with buffer and read line by line
    with open(filename, 'rt', 65536) as file:
        #lines = file.readlines()
        #for line in lines:
        for line in file:
            data = line.strip()
            
            # The sampe row is:
            # <txt>24-APR-2015 08:43:06 * (CONNECT_DATA=(SERVICE_NAME=WEBPISO)(CID=(PROGRAM=D:\anw\php5\php-cgi.exe)(HOST=EGEER00WW01)(USER=IUSR))) * (ADDRESS=(PROTOCOL=tcp)(HOST=10.200.222.70)(PORT=53403)) * establish * WEBPISO * 0
            # We need PROGRAMM and HOST and get these with pattern for 2 groups.
            # The group 1 is PROGRAM, the group 2 is HOST            
            pattern = r"\(PROGRAM=([\w\d\\:_\-.]+)\)\(HOST=([\w.]+)"
            re_obj  = re.search(pattern, data)           
            
            if re_obj:                
                program_name = re_obj.group(1)                
                host_name = re_obj.group(2)                
                #connection = program_name + '\t' + host_name
                connection = '\t'.join([program_name, host_name])
                ###########################################################################
                # "column organized" map for more performance (see Example Structure below)
                ###########################################################################
                # [connection_1], 1,1,1,1
                # [connection_2], 1,1,
                # ...
                # [connection_N], 1,1,1,1,1,1
                ###################################
                mapped_output[connection].append(1)
                if debug_mode:
                    print "{0}{1}{2}\t{3}".format(program_name, ' ', host_name, 1)
                    print "{0}\n".format(mapped_output[connection])    
    
    ##################################################
    # After Main Loop for performance increasing
    ##################################################
    # Put the partitioned connections together and group/sum/accumulate them
    partitioned_output = mapped_output.items()    
    for connection, occurances in partitioned_output:
        reduced_output.append( (connection, sum(occurances)) ) 
    
    if print_time_helper:
        output_lock.acquire()
        print multiprocessing.current_process().name, 'reading end', filename, 'end_time', datetime.datetime.utcnow(), '\n'
        output_lock.release()
    elif debug_mode:
        output_lock.acquire()
        print multiprocessing.current_process().name, 'reading end', filename, '\n'
        output_lock.release()
                  
    return reduced_output
    

# Organize the mapped values by their key.
# Returns an unsorted sequence of tuples 
# with a key and a sequence of values
def partition(mapped_values):
    
    if print_time_helper:
        output_lock.acquire()
        print '\n=========================================\n'
        print 'partition', datetime.datetime.utcnow(), '\n'
        print '\n=========================================\n' 
        output_lock.release()
            
    partitioned_data = collections.defaultdict(list)
    for key, value in mapped_values:
        partitioned_data[key].append(value)
    return partitioned_data.items()

    
# Reducer for the reading of ORACLE listener
# Convert the partitioned data to a tuple
# containing the PROGRAM with HOST and 
# the number of occurances   
def reducer(item):
    
    if print_time_helper:
        output_lock.acquire()
        print multiprocessing.current_process().name, 'reduce', 'start_time', datetime.datetime.utcnow(), '\n'
        output_lock.release()
    
    connection, occurances = item
        
    return (connection, sum(occurances))

##########################################################################################################    
#                                               Main Part
##########################################################################################################    
    
if __name__ == '__main__':
    import sys
    import operator
    import glob
    import datetime
    
    # List of files to analysis
    # input_files = glob.glob('D:\\Archiv\\Vladimir\\projekt\\parallel\\hadoop\\jobinput\\*')
    # input_files = glob.glob('/home/pi/parallel/jobinput/*')
    input_files = glob.glob('/media/pi/USB64/jobinput/*')     
    
    # ----------------------------------------
    # Create Multiproceccing Pool    
    # ----------------------------------------    
    pool = multiprocessing.Pool(count_worker)
    
    # Starttime for Logging
    start_time = datetime.datetime.utcnow()
    
    #-----------------------------------------
    # Common information    
    #-----------------------------------------
    print '\n=========================================\n'    
    print 'CPUs count:', multiprocessing.cpu_count(), '\n'
    print 'Python version', sys.version, '\n'
    print 'Processes count:', count_worker, '\n'
    print '=========================================\n'    
    
    # output :)
    print '\n=========================================\n'    
    print 'START', start_time, '\n'
    print '=========================================\n'        
    
    #-----------------------------------------
    # -= Map =-
    #-----------------------------------------
    # Put mapper-Function in the multiproceccing pool.
    # The returning data are already reduced for each
    # multi proceccess. It's necessary to pool all this 
    # data together    
    
    # Starttime for Logging
    start_time_mapper = datetime.datetime.utcnow()
    mapped_connections = pool.map(mapper, input_files, chunksize=1)
    end_time_mapper = datetime.datetime.utcnow()
    
    if print_time_main_prg:
        print '\n=========================================\n'    
        print 'mapper time', end_time_mapper - start_time_mapper, '\n'
        print '=========================================\n'
    
    if debug_mode:        
        print '\n=========================================\n'    
        print 'mapped_connections', mapped_connections, '\n'
        print '=========================================\n'        
    
    # Group the mapped data
    partitioned_connections = partition(itertools.chain(*mapped_connections))    
    
    #-----------------------------------------
    # -= Reduce =-
    #-----------------------------------------
    # Get the count of partitioned data
    reduced_connections = pool.map(reducer, partitioned_connections)    
    
    pool.close() # no more tasks
    pool.join()  # wrap up current tasks
    
    # Sort data descending order
    reduced_connections.sort( key=operator.itemgetter(1) )
    reduced_connections.reverse()
    
    # output :)    
    print '=========================================\n'
    print 'Connections from Oracle Listener Log File\n'
    print '=========================================\n'
    for connection, count in reduced_connections:
        print "{0}\t{1}".format(connection, count)
        
    end_time = datetime.datetime.utcnow()
    
    print '\n=========================================\n'    
    print 'END', end_time, '\n'
    print '=========================================\n'
    
    print '\n=========================================\n'    
    print 'TIME TOTAL', end_time - start_time, '\n'
    print '=========================================\n'