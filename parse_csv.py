#!/usr/bin/env python

# -*- coding: utf-8 -*-

# Created by VP at 27.11.2020
# Das ist ein Tool zum Parsen der Struktur der CSV-Dateien

import sys
import csv
import ntpath
import datetime
import pandas as pd
import argparse
from pprint import pprint

# Global variables
LDM_FLAG = True


# CONSTANTS
CSV_ENCODING      = {"UTF8BOM":"utf-8-sig","UTF8":"utf-8"}
CSV_DELIMETER     = {";":";",",":","}
DEBUG_FLAG_PARAM  = {"Y":True,"Yes":True,"N":False,"No":False}

# PII Lexicon
PII_LEXICON = ["BANKLEITZAHL","KONTONUMMER","KTONRTB","IBAN","BIC","KUNDENNUMMER","VORNAME","NACHNAME","GEBURTS","STRASSE","ORT","PLZ"]
COLUMN_SENSITIVE_FLAG = "Sensitive"
TABLE_PII_INFO_FLAG   = "X"

# Output Excel File Constants
SHEET_TABLE_NAME        = "Table"
SHEET_TABLE_COLUMN_1    =  "Table"
SHEET_TABLE_COLUMN_2    =  "Personal Data"


SHEET_TABLE_COLUMN_NAME      = "Table.Column"
SHEET_TABLE_COLUMN_NAME_1    = "Table"
SHEET_TABLE_COLUMN_NAME_2    = "Name"
SHEET_TABLE_COLUMN_NAME_3    = "Datatype"
SHEET_TABLE_COLUMN_NAME_4    = "Personal data level"

# Output Datatype constants
LDM_VARCHAR  = "Variable characters"
PDM_VARCHAR  = "VARCHAR2"
LDM_DECIMAL  = "Decimal"
PDM_DECIMAL  = "NUMBER"
LDM_DATE     = "Date"
PDM_DATE     = "DATE"

# ERROR Messages
ADD_NEW_COMMUNITY_ERR = "Fehler beim Erstellen einer Community:"

# Parser for command-line
def getParam():
    ap = argparse.ArgumentParser()
    ap.add_argument("-f", "--filename",  required=True,                                              help="CSV file name to parse without extention")
    ap.add_argument("-e", "--encoding",  required=True,  choices=['UTF8','UTF8BOM'],                 help="ENCODING of CSV file to parse")
    ap.add_argument("-d", "--delimeter", required=False,                                default=";", help="DELIMETER in the CSV file default ';'")
    ap.add_argument("-v", "--verbose",   required=False, choices=['Y','Yes','N','No'],  default="Y", help="Output DEBUG Info Y[es]/N[o] default 'Yes'")
    
    args = vars(ap.parse_args())

    global input_filename
    global csv_encoding
    global csv_delimeter
    global DEBUG_FLAG

    input_filename    = args["filename"]
    arg_encoding      = args["encoding"]
    arg_csv_delimeter = args["delimeter"]
    arg_verbose       = args["verbose"]
    
    csv_encoding   = CSV_ENCODING.get(arg_encoding, "Invalid encoding")
    csv_delimeter  = CSV_DELIMETER.get(arg_csv_delimeter, "Invalid delimeter")
    DEBUG_FLAG     = DEBUG_FLAG_PARAM.get(arg_verbose, "Invalid verbose parameter")

    global FULL_FILENAME
    global OUTPUT_FILENAME
    global OUTPUT_EXCEL_FILENAME

    FULL_FILENAME         = input_filename
    # get filename without extention first
    input_filename_base   = ntpath.basename(input_filename).split('.')[0]
    OUTPUT_FILENAME       = input_filename_base + ".txt"
    OUTPUT_EXCEL_FILENAME = "DAVID_IMPORT_" + input_filename_base + ".xlsx"


# Logging
def printError(err):
    print(f"Other error occurred: {err}")  # Python 3.6


# Returns header of file and the first row
def getHeaderAndDataFromFile(filename):
    
    try:
        with open(filename, 'r', encoding=csv_encoding) as f:
            csv_reader = csv.reader(f, delimiter=csv_delimeter)
            # get the header
            header = next(csv_reader)

            # skip the first line with header an get just the only one next row
            if header != None:
                for row in csv_reader:
                    f.close
                    # header to uppercase
                    return [element.upper() for element in header], row
    except Exception as err:        
        if DEBUG_FLAG: printError(err)
        f.close
        return None

# Every column is per Default Variable Caharachter
def getDefaultDataType(column_name, column_value):
    column_length = None

    if column_value != None and len(column_value) > 0:
        column_length = str(len(column_value))
    else:
        column_length = str(len(column_name))

    if LDM_FLAG:
        return (LDM_VARCHAR + "(" + column_length + ")")
    else:
        return (PDM_VARCHAR + "(" + column_length + ")")

# Check if the value of column a Decimal
# just add 1 to the value
# in case of exception the column is not a Decimal
def isColumnDecimalDatatype(column_name, column_value):
    if column_value != None and len(column_value) > 0:
        try:
            column_new_value = float(column_value.replace(",",".")) + 1.0
            return True
        except Exception as err:
            return False
    else:
        return False

# Check if the value of Column a Date (dd.mm.yyyy) is
def isColumnDateDatatype(column_name, column_value):
    if column_value != None and len(column_value) > 0:
        try:
            column_new_value = datetime.datetime.strptime(column_value, "%d.%m.%Y")
            return True
        except Exception as err:
            return False
    else:
        return False

# Set Decimal format with or without precision
def getDecimalDatatype(column_name, column_value):
    if column_value != None and len(column_value) > 0:
        try:
            decimal_len       = len(column_value)
            decimal_precision = column_value.find(",")
            decimal_format    = None

            # Parse the Decimal separator
            if decimal_precision == -1:
                decimal_format = str(decimal_len)
            else:
                decimal_format = str(decimal_len) + "," + str(decimal_len - decimal_precision - 1)

            # build the Decimal Datatype format
            if LDM_FLAG:
                return (LDM_DECIMAL + "(" + decimal_format + ")")
            else:
                return (PDM_DECIMAL + "(" + decimal_format + ")")

        except Exception as err:
            if DEBUG_FLAG: printError(err)
            return None
    else:
        return None

# Set Date format
def getDateDatatype(column_name, column_value):
    # build the Decimal Datatype format
    if LDM_FLAG:
        return LDM_DATE
    else:
        return PDM_DATE

# Checks if the column name is in the PII Lexicon
def isColumnWithPII(column_name):

    for i in range(len(PII_LEXICON)):
        if PII_LEXICON[i] in column_name:
            return True

    return False

def getStructureFromHeaderWithTypes(header, row):
    
    try:
        column_names            = []
        column_types            = []
        column_pii_level        = []
        # Table has per Default no PII_INFO
        global TABLE_PII_INFO
        TABLE_PII_INFO = None

        for i in range(len(header)):
            # remove the withe spaces from header
            column_name = header[i].strip()
            column_names.append(column_name)
            
            # ####################################
            # get the right type column
            # ####################################
            if row[i] != None and len(row[i]) > 0:
                if isColumnDecimalDatatype(header[i], row[i]):
                    column_types.append( getDecimalDatatype(header[i], row[i]) )
                elif isColumnDateDatatype(header[i], row[i]):
                    column_types.append( getDateDatatype(header[i], row[i]) )
                else:
                    column_types.append( getDefaultDataType(header[i], row[i]) )
            else:
                # Default datatype is Variable Characters for LDM
                column_types.append( getDefaultDataType(header[i], row[i]) )

            if isColumnWithPII(column_name):
                # The Column has Sensitive information --> the table has the sensitive information too
                column_pii_level.append(COLUMN_SENSITIVE_FLAG)
                TABLE_PII_INFO = TABLE_PII_INFO_FLAG
            else:
                # Default PII_Level --> None
                column_pii_level.append(None)

        return column_names, column_types, column_pii_level
    except Exception as err:        
        if DEBUG_FLAG: printError(err)
        return None

# Writes the structure into the Excel output file
# Structure:
# There are two Excel sheets:
#   Table and Table.Column
# Sheet Table has two columns with the table name(s) and personal data: Table and Personal Data
# Sheet Table.Column has four columns: Table, Name (Column Names) and Datatype (Column Datatypes), Personal data level
def writeStructureToExcel(cols, types, pii_info):
    try:
        # makes sheet strukture (s. above)
        # Sheet Table        
        sheet_table = pd.DataFrame({SHEET_TABLE_COLUMN_1: [FULL_FILENAME], SHEET_TABLE_COLUMN_2: [TABLE_PII_INFO]})
        # Sheet Table.Column
        sheet_table_column = pd.DataFrame({SHEET_TABLE_COLUMN_NAME_1: FULL_FILENAME, SHEET_TABLE_COLUMN_NAME_2: cols, SHEET_TABLE_COLUMN_NAME_3: types, SHEET_TABLE_COLUMN_NAME_4: pii_info })
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
    header, row = getHeaderAndDataFromFile(FULL_FILENAME)

    if header != None and row != None:
        
        # 2. Get structure from header
        column_names, column_types, column_pii_level = getStructureFromHeaderWithTypes(header, row)

        if DEBUG_FLAG: 
            pprint( f"header: {column_names}" )
            pprint( f"header: {column_types}" )
            pprint( f"pii_level: {column_pii_level}" )
            pprint( f"data: {row}" )

        if column_names != None and column_types != None:
            # 3. Write the structure into the Excel file
            writeStructureToExcel(column_names, column_types, column_pii_level)
        else:
            print("ERROR!!! Sorry!!!")
            sys.exit(-1)

    # END here
    print()
    print("Success!!! Bye!!!")