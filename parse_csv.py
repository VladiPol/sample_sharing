#!/usr/bin/env python

# -*- coding: utf-8 -*-

# Created by VP at 27.11.2020
# Das ist ein Tool zum Parsen der Struktur der CSV-Dateien
# Changed at 19.03.2021
# No generation for Data Types flag added --> all columns will be Varible characters (255)

import sys
import csv
import ntpath
import datetime
import pandas as pd
import argparse
from pprint import pprint

# Global variables
LDM_FLAG = True # default --> create structure for LDM

# CONSTANTS
CSV_ENCODING                = {"UTF8BOM":"utf-8-sig","UTF8":"utf-8","UTF16":"utf-16"}
CSV_DELIMETER               = {";":";",",":","}
CSV_DECIMAL                 = {",":",",".":"."}
CSV_NROWS_MAX               = 100 # if the file has more then 100 rows just 10% of file will be read to analysis of structure
CSV_NROWS_PCT_MAX           = 10  # 10% from file to read as default
DEBUG_FLAG_PARAM            = {"Y":True,"Yes":True,"N":False,"No":False}
GENERATE_DTYPES_FLAG_PARAM  = {"Y":True,"Yes":True,"N":False,"No":False}

# PII Lexicon
PII_LEXICON = ["ACCT_ID","BANKLEITZAHL","KONTONUMMER","KONTO","KTONR","KTONRTB","KTO","IBAN","BIC","KUNDENNUMMER","VORNAME","NACHNAME","NAME","GEBURTS","STRASSE","ORT","PLZ","AUSWEIS","BEARBEITER","BEARB","TELEFON","DEVICE"]
# PII constants
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

# DEFAULT Format(s)
DEFAULT_DATE_FORMAT = "%Y%m%d"
# DEFAULT buffer for the column length for the future
DEFAULT_COL_LEN_BUFFER = 3
# Default Variable characters / VARCHAR2 length (plus Buffer s. above)
DEFAULT_VCHAR_LENGTH = 252

# Python Data Types
PINT = ["int","int64","int32"]
PDEC = ["float","float32","float64"]
PSTR = ["object"]
PDAT = ["dat","Dat","DAT","date","datum","Date","Datum","DATE","DATUM"]

# Output Datatype constants
LDM_VARCHAR  = "Variable characters"
PDM_VARCHAR  = "VARCHAR2"
LDM_DECIMAL  = "Decimal"
PDM_DECIMAL  = "NUMBER"
LDM_DATE     = "Date"
PDM_DATE     = "DATE"

# Parser for command-line
def getParam():
    ap = argparse.ArgumentParser()
    ap.add_argument("-f", "--filename",            required=True,                                              help="CSV file name to parse without extention")
    ap.add_argument("-e", "--encoding",            required=True,  choices=['UTF8','UTF8BOM','UTF16'],         help="ENCODING of CSV file to parse")
    ap.add_argument("-d", "--delimeter",           required=False,                                default=";", help="DELIMETER in the CSV file default ';'")
    ap.add_argument("-g", "--generate_datatypes",  required=False, choices=['Y','Yes','N','No'],  default="Y", help="Read data and generate Data Type Y[es]/N[o] default 'Yes', 'No' means all data types are Variable Characters(255)")
    ap.add_argument("-s", "--decimal",             required=False,                                default=",", help="DECIMAL SEPARATOR in the CSV file default ','")    
    ap.add_argument("-v", "--verbose",             required=False, choices=['Y','Yes','N','No'],  default="Y", help="Output DEBUG Info Y[es]/N[o] default 'Yes'")
    
    args = vars(ap.parse_args())

    global input_filename
    global file_encoding
    global file_delimeter
    global file_decimal
    global file_nrows
    global DEBUG_FLAG
    global GENERATE_DTYPES_FLAG

    input_filename    = args["filename"]
    arg_encoding      = args["encoding"]
    arg_csv_delimeter = args["delimeter"]
    arg_verbose       = args["verbose"]
    arg_csv_decimal   = args["decimal"]
    arg_gen_dtypes    = args["generate_datatypes"]
    
    file_encoding         = CSV_ENCODING.get(arg_encoding, "Invalid encoding")
    file_delimeter        = CSV_DELIMETER.get(arg_csv_delimeter, "Invalid delimeter")
    file_decimal          = CSV_DECIMAL.get(arg_csv_decimal, "Invalid decimal")
    DEBUG_FLAG            = DEBUG_FLAG_PARAM.get(arg_verbose, "Invalid verbose parameter")
    GENERATE_DTYPES_FLAG  = GENERATE_DTYPES_FLAG_PARAM.get(arg_gen_dtypes, "Invalid generate Data Types parameter")

    global FULL_FILENAME
    global OUTPUT_FILENAME
    global OUTPUT_EXCEL_FILENAME

    # get filename is the file name plus extention
    FULL_FILENAME         = input_filename
    OUTPUT_FILENAME       = input_filename + ".txt"
    OUTPUT_EXCEL_FILENAME = "DAVID_IMPORT_" + input_filename + ".xlsx"


# Logging
def printError(err):
    print(f"Other error occurred: {err}")  # Python 3.6

# Get Sample of Data (default = 10%) as Pandas Frame 
def getDataAsPF(filename):
    # in case not header with column names found
    NO_COL_NAME = 'Unnamed'
    
    try:
        # get count rows in the file --> if file has more then 100 rows --> read just 10% (default in constants) rows from file for analysis
        num_lines = sum(1 for line in open(filename, encoding=file_encoding))
        if num_lines > CSV_NROWS_MAX:
            file_nrows = int(num_lines * CSV_NROWS_PCT_MAX / 100)
        file_df = pd.read_csv(filename, encoding=file_encoding, delimiter=file_delimeter, decimal=file_decimal, nrows=file_nrows)

        # check if the column name is Unnamed --> no header exist --> exit
        for column in file_df.columns:
            if NO_COL_NAME in column:
                raise Exception("No header with column names found or header is not complete")
        
        return file_df
    except Exception as err:
        if DEBUG_FLAG: printError(err)
        return None

# Every column is per Default Variable Caharachter
def getDefaultDataType(column_name, column_values, column_length = 0):

    if column_length == 0:
      # get the max column value as cast to string
      max_column_length = column_values.astype(str).map(len).max()
    else:
      max_column_length = column_length

    if LDM_FLAG:
        return (LDM_VARCHAR + "(" + str(max_column_length + DEFAULT_COL_LEN_BUFFER) + ")")
    else:
        return (PDM_VARCHAR + "(" + str(max_column_length + DEFAULT_COL_LEN_BUFFER) + ")")

# Set Decimal format with or without precision
def getDecimalDatatype(column_name, column_values):
    
    try:
        # get the max column value as cast to string
        decimal_len       = column_values.astype(str).map(len).max()
        # Pandas default decimal separator
        decimal_precision = str(column_values.max()).find(".")
        decimal_format    = None

        # Parse the Decimal separator
        if decimal_precision == -1:
            decimal_format = str(decimal_len + DEFAULT_COL_LEN_BUFFER)
        else:
            decimal_format = str(decimal_len + DEFAULT_COL_LEN_BUFFER) + "," + str(decimal_len - decimal_precision - 1)

        # build the Decimal Datatype format
        if LDM_FLAG:
            return (LDM_DECIMAL + "(" + decimal_format + ")")
        else:
            return (PDM_DECIMAL + "(" + decimal_format + ")")

    except Exception as err:
        if DEBUG_FLAG: printError(err)
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
        if PII_LEXICON[i] in column_name.upper():
            return True

    return False

# Check if the value of Column a Date (dd.mm.yyyy) is
def isColumnDateDatatype(column_name, column_value):
    
    try:
        column_new_value = datetime.datetime.strptime(str(column_value.max()), DEFAULT_DATE_FORMAT)
        return True
    except Exception as err:
        return False
    

# Checks if the column name is in the Date Lexicon
def isColumnNameWithDate(column_name):

    for i in range(len(PDAT)):
        if PDAT[i] in column_name.upper():

            return True

    return False

def getStructureFromHeaderWithTypes(file_df):
    
    try:
        column_names            = []
        column_types            = []
        column_pii_level        = []
        # Table has per Default no PII_INFO
        global TABLE_PII_INFO
        TABLE_PII_INFO = None

        # Loop all column names and get the right type column
        for column_name in file_df.columns:
            # remove the withe spaces from header if exists and conver to uppercase
            column_names.append(column_name.strip().upper())

            # set column PII flag
            if isColumnWithPII(column_name):
                # At least one column has the Sensitive information --> so the table has the sensitive information too
                column_pii_level.append(COLUMN_SENSITIVE_FLAG)
                TABLE_PII_INFO = TABLE_PII_INFO_FLAG
            else:
                # Default PII_Level --> None
                column_pii_level.append(None)

            # ####################################################################################################
            # if GENERATE_DTYPES_FLAG_PARAM does not set just genereate the default Data types without any checks
            ######################################################################################################
            if not GENERATE_DTYPES_FLAG:
                # Default datatype is Variable Characters for LDM / PDM
                column_types.append( getDefaultDataType(column_name, file_df[column_name], DEFAULT_VCHAR_LENGTH) )
                continue

            if isColumnNameWithDate(column_name): # check the lexicon and try to convert the value in the date
                if isColumnDateDatatype(column_name, file_df[column_name]):
                    # Date
                    column_types.append( getDateDatatype(column_name, file_df[column_name]) )
                else:
                    # Could not format the value into date --> make the DEFAULT data type --> Variable Characters
                    column_types.append( getDefaultDataType(column_name, file_df[column_name]) )
                # if DEBUG_FLAG: print(column_name, ' Date')
            elif file_df.dtypes[column_name] in PSTR:
                # String or Variable Characters
                column_types.append( getDefaultDataType(column_name, file_df[column_name]) )
                # if DEBUG_FLAG: print(column_name, ' String')
            elif file_df.dtypes[column_name] in PDEC:
                # Decimal with digits (optimized for Oracle)
                column_types.append( getDecimalDatatype(column_name, file_df[column_name]) )
                # if DEBUG_FLAG: print(column_name, ' Decimal with digit')
            elif file_df.dtypes[column_name] in PINT:
                # try to cast int to Date
                if isColumnDateDatatype(column_name, file_df[column_name]):
                    # Date
                    column_types.append( getDateDatatype(column_name, file_df[column_name]) )
                else:
                    # Could not format the value into date --> make Decimal without digits (optimized for Oracle)
                    column_types.append( getDecimalDatatype(column_name, file_df[column_name]) )
                # if DEBUG_FLAG: print(column_name, ' Decimal (may be a date)')
            else:
                # Default datatype is Variable Characters for LDM / PDM
                column_types.append( getDefaultDataType(column_name, file_df[column_name]) )

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
        print("Error at writeStructureToExcel...")
        raise err

##########################################################################################################
#                                               Main Part
##########################################################################################################
if __name__ == '__main__':

    try:
        # 0. Get parameters
        getParam()

        # 1. Get Data as Pandas Frame
        file_df = getDataAsPF(FULL_FILENAME)

        if file_df is not None and not file_df.empty:
            # 2. If the Pandas Frame is not null then get the structure
            column_names, column_types, column_pii_level = getStructureFromHeaderWithTypes(file_df)

            if DEBUG_FLAG:
                print()
                pprint( f"header: {column_names}" )
                print()
                pprint( f"types:  {column_types}" )
                print()
                pprint( f"pii_level: {column_pii_level}" )
                print()
                pprint( f"SAMPLE DATA (first row):" )
                pprint( f"data: {file_df.iloc[0,:]}" ) # output of first data row from file

            if column_names != None and column_types != None:
                # 3. Write the structure into the Excel file
                writeStructureToExcel(column_names, column_types, column_pii_level)
            else:
                print("ERROR!!! Sorry!!!")
                sys.exit(-1)

        else:
            print()
            print("ERROR!!! Sorry!!!")
            sys.exit(-1)

        # END here
        print()
        print("Success!!! Bye!!!")
    
    except Exception as err:        
        if DEBUG_FLAG: printError(err)
        print("ERROR!!! Sorry!!!")
        sys.exit(-1)