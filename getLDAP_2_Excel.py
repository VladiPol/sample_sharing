#!/usr/bin/env python

# -*- coding: utf-8 -*-

# Created by VP at 07.05.2021
# The Script reads data from LDAP and create an Excel-Template

import sys
import ntpath
import datetime
import pandas as pd
import argparse
import json
from pprint import pprint
from ldap3 import Server, Connection, ALL

# CONSTANTS
DEBUG_FLAG_PARAM     = {"Y":True,"Yes":True,"N":False,"No":False}
LDAP_ZEB_APPL        = ["OU=Test,OU=XXX,OU=Applikationen,OU=Groups,OU=XXX,DC=XXX,DC=intern",\
                        "OU=QSU,OU=XXX,OU=Applikationen,OU=Groups,OU=XXX,DC=XXX,DC=intern",\
                        "OU=Prod,OU=XXX,OU=Applikationen,OU=Groups,OU=XXX,DC=XXX,DC=intern"]
LDAP_ZEB_APPL_FILTER = "(cn=*)"
LDAP_USERS           = "OU=XXX,DC=XXX,DC=intern"

# ######################################################################
# START OF Excel Structure
# ######################################################################
# Output Excel File Constants
# Sheets
SHEET_1  = "Users"
SHEET_2  = "Groups"
SHEET_3  = "UserGroupRelations"
SHEET_4  = "GroupGroupRelations"

# Sheet's Columns with sample data --> to test just uncomment these 
# SHEET_1_COLUMNS  = {"userName":['dummyUserName'], "name.familyName":['dummyFamilyName'], "name.givenName":['dummyGivenName'], "displayName":['dummyDisplayName'], "mail":['dummyMail@teambank.de']}
# SHEET_2_COLUMNS  = {"groupName":['dummyGroupName'], "displayName":['dummyDisplayName']}
# SHEET_3_COLUMNS  = {"userName":['dummyUserName'], "groupName":['dummyGroupName']}
# SHEET_4_COLUMNS  = {"childGroupName":['dummyChildGroupName'], "parentGroupName":['dummyParentGroupName']}
# Empty Sheet's Columns
SHEET_1_COLUMNS  = {"userName":[], "name.familyName":[], "name.givenName":[], "displayName":[], "mail":[]}
SHEET_2_COLUMNS  = {"groupName":[], "displayName":[]}
SHEET_3_COLUMNS  = {"userName":[], "groupName":[]}
SHEET_4_COLUMNS  = {"childGroupName":[], "parentGroupName":[]}
# ######################################################################
# END OF Excel Structure
# ######################################################################

# Parser for command-line
def getParam():
    ap = argparse.ArgumentParser()
    # LDAP-URL, PORT, USER, PWD, OUTPUT_FILENAMEhost_name
    ap.add_argument("-l", "--host_name",           required=True,                                                  help="Host name of LDAP Server")
    ap.add_argument("-p", "--port_number",         required=True,                                                  help="Port number of LDAP Server")
    ap.add_argument("-u", "--user_name",           required=True,                                                  help="User name for connection to LDAP Server")
    ap.add_argument("-b", "--bind_password",       required=True,                                                  help="Bind password for connection to LDAP Server")    
    ap.add_argument("-o", "--output_file_name",    required=False, default="LDAP_2_Excel.xlsx",                    help="Output file name (default 'LDAP_2_Excel.xlsx') for Excel file")
    ap.add_argument("-v", "--verbose",             required=False, choices=['Y','Yes','N','No'],  default="Y",     help="Output DEBUG Info Y[es]/N[o] default 'Yes'")
    
    args = vars(ap.parse_args())

    global HOST_NAME
    global PORT_NUMBER
    global USER_NAME
    global USER_PWD
    global DEBUG_FLAG
    global OUTPUT_FILENAME

    # get parameters
    HOST_NAME   = args["host_name"]
    PORT_NUMBER = args["port_number"]
    USER_NAME   = args["user_name"]
    USER_PWD    = args["bind_password"]
    USER_PWD    = args["bind_password"]
    OUTPUT_FILENAME = args["output_file_name"]
    arg_verbose     = args["verbose"]
    DEBUG_FLAG      = DEBUG_FLAG_PARAM.get(arg_verbose, "Invalid verbose parameter")    

# Logging
def printError(err):
    print(f"Other error occurred: {err}")  # Python 3.6

# The function just conencts to LDAP with secure parameters
def connectLDAP():
    try:
        # create Server and get LDAP connectiom
        server     = Server(HOST_NAME, port=int(PORT_NUMBER), use_ssl=True)
        connection = Connection(server, user=USER_NAME, password=USER_PWD)
        if not connection.bind():
            print("Error in Bind", connection.result)
            raise Exception("connectLDAP --> Error in Bind" + str(connection.result))
        else:
            return connection
    except Exception as err:
        print("Error at connectLDAP...")
        raise err

# The function create an empty template 
# with structure for Excel file
def createEmptyTemplate():
    try:
        # makes sheet columns structure
        # Sheet 1..Sheet 4
        sheet_1_colums = pd.DataFrame(SHEET_1_COLUMNS)
        sheet_2_colums = pd.DataFrame(SHEET_2_COLUMNS)
        sheet_3_colums = pd.DataFrame(SHEET_3_COLUMNS)
        sheet_4_colums = pd.DataFrame(SHEET_4_COLUMNS)
        # Puts output sheets together
        output_sheets = {SHEET_1: sheet_1_colums, SHEET_2: sheet_2_colums, SHEET_3: sheet_3_colums, SHEET_4: sheet_4_colums}
        return output_sheets
    except Exception as err:
        print("Error at createEmptyTemplate...")
        raise err

# The function create a pandas data frame with groups
# with structure for Excel file
def createGroupsAndUserGropuRelations(connection, output_sheets):
    attr_member = "member"
    attr_cn     = "cn" 
    attr_descr  = "description"
    err_Exp     = "createGroups --> Error in Search"
    try:
        # if DEBUG_FLAG: print(output_sheets)
        groups_sheet_2_columns = output_sheets[SHEET_2] # see the structure in createEmptyTemplate
        userGroupRel_sheet_3_columns = output_sheets[SHEET_3] # see the structure in createEmptyTemplate
        for i in range(len(LDAP_ZEB_APPL)):
            # get AD Groups with cn und description for all ZEB Applications
            search_res = connection.search(LDAP_ZEB_APPL[i], LDAP_ZEB_APPL_FILTER, attributes=[attr_cn, attr_descr, attr_member])
            if search_res != True: raise Exception(err_Exp + str(LDAP_ZEB_APPL[i])) # nothing found

            for i in range(len(connection.entries)): # get the info about groups
                # let's append a Group as a series object with same index as dataframe
                group_row = pd.Series([connection.entries[i][attr_cn][0], connection.entries[i][attr_descr][0]], index=groups_sheet_2_columns.columns)
                groups_sheet_2_columns = groups_sheet_2_columns.append(group_row, ignore_index=True)

                if len(connection.entries[i][attr_member]) > 0: # if the group has any members let's get this information
                    for j in range(len(connection.entries[i][attr_member])): # get the member / personal ID for UserGroupRelation
                        pernr = connection.entries[i][attr_member][j][3:9]
                        userGroup_row = pd.Series([pernr, connection.entries[i][attr_cn]], index=userGroupRel_sheet_3_columns.columns)
                        userGroupRel_sheet_3_columns = userGroupRel_sheet_3_columns.append(userGroup_row, ignore_index=True)

        # if DEBUG_FLAG: print(groups_sheet_2_colums)
        # if DEBUG_FLAG: print(output_sheets)
        # return values are the data frames for Excel file
        return groups_sheet_2_columns, userGroupRel_sheet_3_columns
    except Exception as err:
        print("Error at createGroupsAndUserGropuRelations...")
        raise err

# The function create a pandas data frame with users
# with structure for Excel file
def createUsers(connection, output_sheets):
    col_userName     = "userName"
    attr_cn          = "cn"
    attr_sn          = "sn"
    attr_givenName   = "givenName"
    attr_displayName = "displayName"
    attr_mail        = "mail"
    err_Exp          = "createUsers --> Error in Search"
    try:
        # if DEBUG_FLAG: print(output_sheets)
        users_sheet_1_columns = output_sheets[SHEET_1] # see the structure in createEmptyTemplate
        # make distinct the users list, iterate and get the information from LDAP
        users = output_sheets[SHEET_3][col_userName].unique()

        for i in range(len(users)):
            # get AD User information with all attributes
            usr_filter = "(cn=" + str(users[i]) + ")"
            search_res = connection.search(LDAP_USERS, usr_filter, attributes=[attr_cn, attr_sn, attr_givenName, attr_displayName, attr_mail])
            if search_res != True: raise Exception(err_Exp + str(users[i])) # nothing found

            # append the user information in pamdas data frame
            user_row = pd.Series([connection.entries[0][attr_cn],\
                                  connection.entries[0][attr_sn],\
                                  connection.entries[0][attr_givenName],\
                                  connection.entries[0][attr_displayName],\
                                  connection.entries[0][attr_mail]], index=users_sheet_1_columns.columns)
            users_sheet_1_columns = users_sheet_1_columns.append(user_row, ignore_index=True)
        
        return users_sheet_1_columns
    except Exception as err:
        print("Error at createUsers...")
        raise err

# Writes the structure into the Excel output file
# Structure:
# There are four Excel sheets:
#   Users, Groups, UserGroupRelations, GroupGroupRelations
# More information in the LDAP Manager Import Template.xlsx
def writeStructureToExcel(output_sheets):
    try:
        # Writes into Excel file
        writer = pd.ExcelWriter('./' + OUTPUT_FILENAME, engine='xlsxwriter') # pylint: disable=abstract-class-instantiated
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
    # just for finally
    connection = None
    try:
        # 0. Get parameters
        getParam()

        # 1. Connect to the LDAP Server
        connection = connectLDAP()
        if DEBUG_FLAG:
            if connection.bind():
                print("Connected to LDAP")

        # 2. Get Groups and UserGroupRelations from LDAP
        output_sheets = createEmptyTemplate()
        groups_sheet_2_columns, userGroupRel_sheet_3_columns = createGroupsAndUserGropuRelations(connection, output_sheets)
        output_sheets[SHEET_2] = groups_sheet_2_columns
        output_sheets[SHEET_3] = userGroupRel_sheet_3_columns        
        if DEBUG_FLAG: print("Got Groups and UserGroupRelations")

        # 3. Get Users information from LDAP for Excel sheet
        users_sheet_1_columns = createUsers(connection, output_sheets)
        output_sheets[SHEET_1] = users_sheet_1_columns
        if DEBUG_FLAG: print("Got Users")

        # 4. Write structure into Excel
        writeStructureToExcel(output_sheets)

        # END here
        print()
        print("Success!!! Bye!!!")
    
    except Exception as err:        
        printError(err)
        print("ERROR!!! Sorry!!!")
        sys.exit(-1)
    finally:
        # always unbind trhe LDAP connection if bind
        if connection is not None and connection.bind():
            connection.unbind()
            if DEBUG_FLAG:
                print("Disconnected from LDAP")
