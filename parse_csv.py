    
#!/usr/bin/env python

# -*- coding: utf-8 -*-

# Created by VP at 27.11.2020
# Das ist ein Tool zum Parsen der Struktur der CSV-Dateien


import csv
import pandas as pd
import argparse
from pprint import pprint

# Global variables
DEBUG_FLAG  = True
LDM_FLAG    = True


# CONSTANTS
PATH_TO_FILE    = "C:/Git/david/utilities/"

CSV_ENCODING         = {"UTF8BOM":"utf-8-sig","UTF8":"utf-8","ISO":"iso"}
CSV_DELIMETER   = ";"

# Output Excel File Constants
SHEET_TABLE_NAME        = "Table"
SHEET_TABLE_COLUMN_NAME = "Table.Column"
SHEET_TABLE_COLUMN_1    = "Table"
SHEET_TABLE_COLUMN_2    = "Name"
SHEET_TABLE_COLUMN_3    = "Datatype"

# Output Datatype constants
LDM_VARCHAR  = "Variable characters"
PDM_VARCHAR  = "VARCHAR2"

# ERROR Messages
ADD_NEW_COMMUNITY_ERR = "Fehler beim Erstellen einer Community:"

# Parser for command-line
def getParam():
    ap = argparse.ArgumentParser()
    ap.add_argument("-f", "--filename", required=True, help="CSV file name to parse without extention")
    ap.add_argument("-e", "--encoding", required=True, choices=['UTF8','UTF8BOM','ISO'], help="ENCODING of CSV file to parse")
    
    args = vars(ap.parse_args())

    global input_filename
    global arg_encoding
    global csv_encoding

    input_filename = args["filename"]    
    arg_encoding   = args["encoding"]
    csv_encoding   = CSV_ENCODING.get(arg_encoding, "Invalid encoding")

    global FULL_FILENAME
    global OUTPUT_FILENAME
    global OUTPUT_EXCEL_FILENAME

    FULL_FILENAME         = input_filename + ".csv"
    OUTPUT_FILENAME       = input_filename + ".txt"
    OUTPUT_EXCEL_FILENAME = input_filename + ".xlsx"


# Logging
def printError(err):
    print(f"Other error occurred: {err}")  # Python 3.6


# Returns header of file and the first row
def getHeaderAndDataFromFile(filename):
    
    try:
        with open(filename, 'r', encoding=csv_encoding) as f:
            csv_reader = csv.reader(f, delimiter=CSV_DELIMETER)
            # get the header
            header = next(csv_reader)

            # skip the first line with header an get just the only one next row
            if header != None:
                for row in csv_reader:
                    f.close
                    return header, row
    except Exception as err:        
        if DEBUG_FLAG: printError(err)
        f.close
        return None

# Writes the structure into the output file
def writeStructureToTXT(cols, types):
    try:
        f = open(OUTPUT_FILENAME, 'w')
        for i in range(len(cols)):
            # nice formatted output to the file
            f.write( '%-50s %25s\n' % (cols[i], types[i]))
        f.close
    except Exception as err:        
        if DEBUG_FLAG: printError(err)
        f.close

# Writes the structure into the Excel output file
# Structure:
# There are two Excel sheets:
#   Table and Table.Column
# Sheet Table has two columns with the table name(s)
# Sheet Table.Column has three columns: Table, Name (Column Names) and Datatype (Column Datatypes)
def writeStructureToExcel(cols, types):
    try:
        # makes sheet strukture (s. above)
        # Sheet Table
        sheet_table = pd.DataFrame({SHEET_TABLE_NAME: [FULL_FILENAME]})
        # Sheet Table.Column
        sheet_table_column = pd.DataFrame({SHEET_TABLE_COLUMN_1: FULL_FILENAME, SHEET_TABLE_COLUMN_2: cols, SHEET_TABLE_COLUMN_3: types})
        # Puts output sheets together
        output_sheets = {SHEET_TABLE_NAME: sheet_table, SHEET_TABLE_COLUMN_NAME: sheet_table_column}

        # Writes into Excel file
        writer = pd.ExcelWriter('./' + OUTPUT_EXCEL_FILENAME, engine='xlsxwriter') # pylint: disable=abstract-class-instantiated
        for sheet_name in output_sheets.keys():
            output_sheets[sheet_name].to_excel(writer, sheet_name=sheet_name, index=False)
        writer.save()
    except Exception as err:        
        if DEBUG_FLAG: printError(err)

##########################################################################################################
#                                               Main Part
##########################################################################################################
if __name__ == '__main__':

    # 0. Get parameters
    getParam()

    # 1. Read the header of file
    header, row = getHeaderAndDataFromFile(PATH_TO_FILE + FULL_FILENAME)

    if header != None and row != None:
        if DEBUG_FLAG: 
            pprint( f"header: {header}" )
            pprint( f"data: {row}" )

        # get structure from header
        column_names = []
        column_types = []
        for i in range(len(header)):
            # remove the withe spaces from header 
            column_names.append(header[i].strip())
            # ####################################
            # get the right type column --> ToDo
            # ####################################
            if LDM_FLAG:
                column_types.append(LDM_VARCHAR + "(" + str(len(header[i])) + ")")
                if DEBUG_FLAG: pprint(header[i].strip() + "\t" + LDM_VARCHAR + "(" + str(len(header[i])) + ")")                
            else:
                column_types.append(PDM_VARCHAR + "(" + str(len(header[i])) + ")")
                if DEBUG_FLAG: pprint(header[i].strip() + "\t" + PDM_VARCHAR + "(" + str(len(header[i])) + ")")

        # 2. writes the structure into the file
        writeStructureToTXT(column_names, column_types)

        # 3. writes the structure into the Excel file
        writeStructureToExcel(column_names, column_types)


    
    # END here
    print()
    print("Success!!! Bye!!!")