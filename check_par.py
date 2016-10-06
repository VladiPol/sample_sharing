#!/usr/bin/env python

# -*- coding: utf-8 -*-

# Script to check hardcoded pwds
# Created by VP at 06.10.2016

import os
import re

# Constants and Variables
# Flag variable for DEBUG or INFO messages
DEBUG_FLAG = False
SHOW_FILE  = False

# Working Directory, File etc
# WORKING_DIR  = 'H:\\dwh'
WORKING_DIR  = 'D:\\Archiv\\Vladimir\\projekt\\ing-diba\\check_par'
WORKING_FILE = 'SPTE_DE_PS_Project_Hash.dsx'

# Start, End, PSWD etc. Tags
START_RECORD = 'BEGIN DSSUBRECORD'
END_RECORD   = 'END DSSUBRECORD'
PSWD_TAG     = '_PSWD'

# Default Hash for Prod-PWD
NAME_TAG     = 'Name'
PROMPT_TAG   = 'Prompt'
PASSWORD_TAG = 'Password'
DEFAULT_TAG  = 'Default'
DEFAULT_HASH = '{iisenc}eHG47YUwCsilbsYLdMUwUw=='


# First of all set the working directory
os.chdir(WORKING_DIR)

if DEBUG_FLAG:
    print os.getcwd()
    
# Checker for PSWD
# Return Value True = NO ERRORS or False = ANY ERRORS
def pswd_checker(parameters):
    for line in parameters:
        if SHOW_FILE:
           print line
           
           
        # search the pattern in the line: Name, Prompt, Default    
        re_obj  = re.search(NAME_TAG, line)
        if re_obj:
            name = line.strip(NAME_TAG + ' ').strip().strip('"')
            if DEBUG_FLAG:
                print name
            
        re_obj  = re.search(PROMPT_TAG, line)
        if re_obj:
            prompt = line.strip(PROMPT_TAG + ' ').strip().strip('"')
            if DEBUG_FLAG:
                print  prompt
        
        re_obj  = re.search(DEFAULT_TAG, line)
        if re_obj:
            default = line.strip(DEFAULT_TAG + ' ').strip().strip('"')
            if DEBUG_FLAG:
                print  default
            
            
    
    if prompt == PASSWORD_TAG:
        if default != DEFAULT_HASH:
            print "Password false for Object ", name
            return False
        else:
            return True
   

##########################################################################################################    
#                                               Main Part
##########################################################################################################    
    
if __name__ == '__main__':
    
    record_block = []        
    parseCurrentSet = False
    keepCurrentSet  = False
    
    # Any erros (True / False) after parse of dsx-File
    outputWithErrorsFlag = False

    # Open file and read line by line
    for line in open(WORKING_FILE):
    
        # start with reading of the text block
        if line.strip() == START_RECORD:
            parseCurrentSet = True
                               
        # search the pattern in the line    
        re_obj  = re.search(PSWD_TAG, line)                 
        
        if re_obj:
            keepCurrentSet = True
            record_block.append(line)
        elif parseCurrentSet:
            record_block.append(line)          
        
            
        # stop with reading of the text block        
        if line.strip() == END_RECORD:
            # Call Checker
            if not pswd_checker(record_block):
                outputWithErrorsFlag = True
            
            # Next part
            parseCurrentSet = False
            keepCurrentSet = False
            record_block = []
            
    # Check the Output-Flag and print message
    if outputWithErrorsFlag:
        print "There are SOME errors after check of dsx-File. Sorry :-("
    else:
        print "There ate NO any errors after check of dsx-File. Congratulaton :-)"
            
    	  
       
       