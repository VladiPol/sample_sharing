#!/usr/bin/env python

# -*- coding: utf-8 -*-

# Created by VP at 06.10.2016
#
# Script to check of parameters in
# DE_PS_Project.pst File
# The Hash of passwords should be
# {iisenc}eHG47YUwCsilbsYLdMUwUw==
# See below the structure of file
# SPTE_DE_PS_Project_Hash.dsx
#

# The structure of SPTE_DE_PS_Project_Hash.dsx File
#
#<?xml version="1.1" encoding="UTF-8"?>
#<com.ibm.datastage.ai.dtm.ds:DSParameterSetSDO xmi:version="2.0" xmlns:xmi="http://www.omg.org/XMI" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:com.ibm.datastage.ai.dtm.ds="http:///com/ibm/datastage/ai/dtm/ds.ecore" xmi:id="115" sDOVersion="2.0.0" objectID="c2e76d84.19e8228.pdkl3d1re.0ll6543.clo1t3.sjodrvnoj7ff7p9dtoq03p" lastModificationTimestamp="2016-10-06T08:51:33.496+0200" optimisticLockID="105" createdByUser="isadmin" creationTimestamp="2015-12-18T09:36:12.971+0100" modifiedByUser="rpenz" name="DE_PS_Project" shortDescription="Parameter Set for Database Connections of the Project" longDescription="Parameter Set for Database Connections of the Project" isSystem="false" paramValues="pvf_env_default?DATASET_LOC=/data/de/dev/Projects/DE_DATA_LAKE_SPTE/files/datasets?SK_FILE_LOC=/data/de/dev/Projects/DE_DATA_LAKE_SPTE/files/keyfiles?WORKFILE_LOC=/data/de/dev/Projects/DE_DATA_LAKE_SPTE/files/workfiles?OUPUTFILE_LOC=/data/de/dev/Projects/DE_DATA_LAKE_SPTE/files/outputfiles?INPUTFILE_LOC=/data/de/dev/Projects/DE_DATA_LAKE_SPTE/files/inputfiles?$DCO_ADB_DWHDATEN_CONSTRING=$PROJDEF?$DCO_ADB_DWHDATEN_USER=$PROJDEF?$DCO_ADB_DWHDATEN_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_AIDX_DWH_READ_CONSTRING=$PROJDEF?$DCO_AIDX_DWH_READ_USER=$PROJDEF?$DCO_AIDX_DWH_READ_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_AVAYA_ODBCREAD_CONSTRING=$PROJDEF?$DCO_AVAYA_ODBCREAD_USER=$PROJDEF?$DCO_AVAYA_ODBCREAD_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_BAIS_BAIS_CONSTRING=$PROJDEF?$DCO_BAIS_BAIS_USER=$PROJDEF?$DCO_BAIS_BAIS_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_BAIS_BAISB_CONSTRING=$PROJDEF?$DCO_BAIS_BAISB_USER=$PROJDEF?$DCO_BAIS_BAISB_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_BAIS_DWH_READ_CONSTRING=$PROJDEF?$DCO_BAIS_DWH_READ_USER=$PROJDEF?$DCO_BAIS_DWH_READ_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_BASL_BASELIIBSM_CONSTRING=BASLIIE?$DCO_BASL_BASELIIBSM_USER=BASELIIBSM?$DCO_BASL_BASELIIBSM_PSWD={iisenc}AwuGI3RuNGXI+xh2+JOP6g==?$DCO_BDB_APP_DWH_CONSTRING=$PROJDEF?$DCO_BDB_APP_DWH_USER=$PROJDEF?$DCO_BDB_APP_DWH_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_BDB_ENSTAGE_CONSTRING=$PROJDEF?$DCO_BDB_ENSTAGE_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_BDB_ENSTAGE_USER=$PROJDEF?$DCO_DARL_DARL_CONSTRING=$PROJDEF?$DCO_DARL_DARL_USER=$PROJDEF?$DCO_DARL_DARL_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_DARL_DWH_READ_CONSTRING=$PROJDEF?$DCO_DARL_DWH_READ_USER=$PROJDEF?$DCO_DARL_DWH_READ_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_DBVO_DBVO_STAGE_CONSTRING=$PROJDEF?$DCO_DBVO_DBVO_STAGE_USER=$PROJDEF?$DCO_DBVO_DBVO_STAGE_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_DBVO_DBVOMART_CONSTRING=$PROJDEF?$DCO_DBVO_DBVOMART_USER=$PROJDEF?$DCO_DBVO_DBVOMART_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_DOXIS_DWH_READ_CONSTRING=$PROJDEF?$DCO_DOXIS_DWH_READ_USER=$PROJDEF?$DCO_DOXIS_DWH_READ_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_DPP_DWH_READ_CONSTRING=$PROJDEF?$DCO_DPP_DWH_READ_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_DPP_DWH_READ_USER=$PROJDEF?$DCO_EMMIE_DWH_READ_CONSTRING=$PROJDEF?$DCO_EMMIE_DWH_READ_USER=$PROJDEF?$DCO_EMMIE_DWH_READ_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_EHW_SPT_EHW_READ_CONSTRING=$PROJDEF?$DCO_EHW_SPT_EHW_READ_USER=$PROJDEF?$DCO_EHW_SPT_EHW_READ_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_EHW_ZEBMART_ZEBMART_CONSTRING=$PROJDEF?$DCO_EHW_ZEBMART_ZEBMART_USER=$PROJDEF?$DCO_EHW_ZEBMART_ZEBMART_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_HACC_DWH_READ_CONSTRING=$PROJDEF?$DCO_HACC_DWH_READ_USER=$PROJDEF?$DCO_HACC_DWH_READ_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_HACC_HACC_STAGE_CONSTRING=$PROJDEF?$DCO_HACC_HACC_STAGE_USER=$PROJDEF?$DCO_HACC_HACC_STAGE_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_HACC_ZEBMART_CONSTRING=$PROJDEF?$DCO_HACC_ZEBMART_USER=$PROJDEF?$DCO_HACC_ZEBMART_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_KRDB_DWH_READ_CONSTRING=$PROJDEF?$DCO_KRDB_DWH_READ_USER=$PROJDEF?$DCO_KRDB_DWH_READ_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_PBOX_DWH_READ_CONSTRING=$PROJDEF?$DCO_PBOX_DWH_READ_USER=$PROJDEF?$DCO_PBOX_DWH_READ_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_PHIN_DWH_READ_CONSTRING=$PROJDEF?$DCO_PHIN_DWH_READ_USER=$PROJDEF?$DCO_PHIN_DWH_READ_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_PITA_AUSWERTUNG_CONSTRING=$PROJDEF?$DCO_PITA_AUSWERTUNG_USER=$PROJDEF?$DCO_PITA_AUSWERTUNG_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_RISK_BASELIIBSM_CONSTRING=$PROJDEF?$DCO_RISK_BASELIIBSM_USER=$PROJDEF?$DCO_RISK_BASELIIBSM_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SSMS_DWH_READ_CONSTRING=$PROJDEF?$DCO_SSMS_DWH_READ_USER=$PROJDEF?$DCO_SSMS_DWH_READ_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SMON_DWH_READ_CONSTRING=$PROJDEF?$DCO_SMON_DWH_READ_USER=$PROJDEF?$DCO_SMON_DWH_READ_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_TBS_DWH_READ_CONSTRING=$PROJDEF?$DCO_TBS_DWH_READ_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_TBS_DWH_READ_USER=$PROJDEF?$DCO_TURNF_DWH_READ_CONSTRING=$PROJDEF?$DCO_TURNF_DWH_READ_USER=$PROJDEF?$DCO_TURNF_DWH_READ_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_UC4_APP_UC4_REP_CONSTRING=$PROJDEF?$DCO_UC4_APP_UC4_REP_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_UC4_APP_UC4_REP_USER=$PROJDEF?$DCO_SPOT_AT_CIMART_CONSTRING=$PROJDEF?$DCO_SPOT_AT_CIMART_USER=$PROJDEF?$DCO_SPOT_AT_CIMART_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_AT_MART_CONSTRING=$PROJDEF?$DCO_SPOT_AT_MART_USER=$PROJDEF?$DCO_SPOT_AT_MART_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_AT_ODS_CONSTRING=$PROJDEF?$DCO_SPOT_AT_ODS_USER=$PROJDEF?$DCO_SPOT_AT_ODS_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_BAISMART_CONSTRING=$PROJDEF?$DCO_SPOT_BAISMART_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_BAISMART_USER=$PROJDEF?$DCO_SPOT_BNCWMART_CONSTRING=$PROJDEF?$DCO_SPOT_BNCWMART_USER=$PROJDEF?$DCO_SPOT_BNCWMART_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_COBA_MART_CONSTRING=$PROJDEF?$DCO_SPOT_COBA_MART_USER=$PROJDEF?$DCO_SPOT_COBA_MART_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_COBA_ODS_CONSTRING=$PROJDEF?$DCO_SPOT_COBA_ODS_USER=$PROJDEF?$DCO_SPOT_COBA_ODS_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_DBVOMART_CONSTRING=$PROJDEF?$DCO_SPOT_DBVOMART_USER=$PROJDEF?$DCO_SPOT_DBVOMART_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_ESPERANTO_CONSTRING=$PROJDEF?$DCO_SPOT_ESPERANTO_USER=$PROJDEF?$DCO_SPOT_ESPERANTO_PSWD={iisenc}F8N2nY6t/W4DSI/E6EG5n2KLna8wo+uSQ76xIpWh0wQ=?$DCO_SPOT_FUNDMART_CONSTRING=$PROJDEF?$DCO_SPOT_FUNDMART_USER=$PROJDEF?$DCO_SPOT_FUNDMART_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_GFRSMART_CONSTRING=$PROJDEF?$DCO_SPOT_GFRSMART_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_GFRSMART_USER=$PROJDEF?$DCO_SPOT_ING_MART_CONSTRING=$PROJDEF?$DCO_SPOT_ING_MART_PSWD={iisenc}MR4jU86uzLVk57t9pOeRL84IECFYKX/Qi8qHhKbzQH8=?$DCO_SPOT_ING_MART_USER=$PROJDEF?$DCO_SPOT_ING_ODS_CONSTRING=$PROJDEF?$DCO_SPOT_ING_ODS_USER=$PROJDEF?$DCO_SPOT_ING_ODS_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_ING_STAGE_CONSTRING=$PROJDEF?$DCO_SPOT_ING_STAGE_USER=$PROJDEF?$DCO_SPOT_ING_STAGE_PSWD={iisenc}1HM4R3lGQqzPk18B/ql6CyjOdFhYeaE+BB+OfexTMy4=?$DCO_SPOT_KDMART_CONSTRING=$PROJDEF?$DCO_SPOT_KDMART_USER=$PROJDEF?$DCO_SPOT_KDMART_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_MMSRMART_CONSTRING=$PROJDEF?$DCO_SPOT_MMSRMART_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_MMSRMART_USER=$PROJDEF?$DCO_SPOT_MWMART_CONSTRING=$PROJDEF?$DCO_SPOT_MWMART_USER=$PROJDEF?$DCO_SPOT_MWMART_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_ODS_CONSTRING=$PROJDEF?$DCO_SPOT_ODS_USER=$PROJDEF?$DCO_SPOT_ODS_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_RETAIL_MART_CONSTRING=$PROJDEF?$DCO_SPOT_RETAIL_MART_USER=$PROJDEF?$DCO_SPOT_RETAIL_MART_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_RISKMART_CONSTRING=$PROJDEF?$DCO_SPOT_RISKMART_USER=$PROJDEF?$DCO_SPOT_RISKMART_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_SAPBAMART_CONSTRING=SPTE?$DCO_SPOT_SAPBAMART_USER=SAPBAMART?$DCO_SPOT_SAPBAMART_PSWD={iisenc}d00KfG/HDLqAC+hHCxWvPZIzRmKKxRfoPYaMTZn1iQw=?$DCO_SPOT_STAGE_CONSTRING=$PROJDEF?$DCO_SPOT_STAGE_USER=$PROJDEF?$DCO_SPOT_STAGE_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==?$DCO_SPOT_ZEBMART_CONSTRING=$PROJDEF?$DCO_SPOT_ZEBMART_USER=$PROJDEF?$DCO_SPOT_ZEBMART_PSWD={iisenc}eHG47YUwCsilbsYLdMUwUw==" category="\\100_Common\\Configuration\\Parameter_Set" dSNameSpace="DLDEED01:DE_DATA_LAKE_SPTE">
#  <assetDataDescriptors xmi:id="157">
#    <details xmi:id="147" key="option:xmiEncoding" value="UTF-8"/>
#    ...
#    <details xmi:id="121" key="version:export" value="2.5"/>
#    <seedObjectRids>c2e76d84.19e8228.pdkl3d1re.0ll6543.clo1t3.sjodrvnoj7ff7p9dtoq03p</seedObjectRids>
#  </assetDataDescriptors>
#  <has_ParameterDef xsi:type="com.ibm.datastage.ai.dtm.ds:DSParameterDefSDO" xmi:id="74" sDOVersion="2.0.0" objectID="c2e76d84.19e49cb.pdkl8e119.6knohv6.940ec7.h2343764glecjeqa31akin" lastModificationTimestamp="2016-04-21T11:23:06.308+0200" optimisticLockID="1" createdByUser="aklamroth" creationTimestamp="2016-04-21T11:23:06.308+0200" modifiedByUser="aklamroth" name="DATASET_LOC" defaultValue="/data/de/dev/Projects/DE_DATA_LAKE_SPTE/files/datasets" typeCode="String" oDBCType="Unknown" usage="In" displayCaption="OBSOLET Location for DataSets" xmetaLockingRoot="c2e76d84.19e8228.pdkl3d1re.0ll6543.clo1t3.sjodrvnoj7ff7p9dtoq03p"/>
#  <has_ParameterDef xsi:type="com.ibm.datastage.ai.dtm.ds:DSParameterDefSDO" xmi:id="39" sDOVersion="2.0.0" objectID="c2e76d84.19e49cb.pdkl8e119.6kno88q.3svfih.smph17t4f9bs0s3lj7vrsn" lastModificationTimestamp="2016-04-21T11:23:06.308+0200" optimisticLockID="1" createdByUser="aklamroth" creationTimestamp="2016-04-21T11:23:06.308+0200" modifiedByUser="aklamroth" name="SK_FILE_LOC" defaultValue="/data/de/dev/Projects/DE_DATA_LAKE_SPTE/files/keyfiles" typeCode="String" oDBCType="Unknown" usage="In" displayCaption="OBSOLET Location for surrogate key files" xmetaLockingRoot="c2e76d84.19e8228.pdkl3d1re.0ll6543.clo1t3.sjodrvnoj7ff7p9dtoq03p"/>
#</com.ibm.datastage.ai.dtm.ds:DSParameterSetSDO>

# import of Operation System and XML Modules
import os
import xml.dom.minidom as minidom

# Constants and Variables
# Flag variable for DEBUG or INFO messages
DEBUG_FLAG = False
SHOW_FILE  = False

# #################################### 
# Working Directory and isx File name
# ####################################
WORKING_DIR  = 'D:\\Archiv\\Vladimir\\projekt\\ing-diba\\check_par\\sample_sharing\\check_par_pst\\DLDEED01\\DE_DATA_LAKE_SPTE\\100_Common\\Configuration\\Parameter_Set'
WORKING_FILE = 'DE_PS_Project.pst'

# Items and Attributes of XML File
ITEM_has_ParameterDef            = 'has_ParameterDef'
ATTRIBUTE_modifiedByUser         = 'modifiedByUser'
ATTRIBUTE_name                   = 'name'
ATTRIBUTE_defaultValue           = 'defaultValue'

# Suffix (keyword of the end of the attribute) to find the right attribute
TAG_CONSTRING = 'CONSTRING'
TAG_USER      = 'USER'
TAG_PSWD      = 'PSWD'
TAG_SEPARATOR = '_'

# Default Values and Hashes for Connect String, User Name ans Password
VALUE_CONSTRING = '$PROJDEF'
VALUE_USER      = '$PROJDEF'
VALUE_PSWD      = '{iisenc}eHG47YUwCsilbsYLdMUwUw=='

# First of all set the working directory
os.chdir(WORKING_DIR)

if DEBUG_FLAG:
    print os.getcwd()   

##########################################################################################################    
#                                               Main Part
##########################################################################################################    
    
if __name__ == '__main__':
    
    # Any erros (True / False) after parse of dsx-File
    countOfErrors = 0

    # Open file and parse it with xml module
    xmldoc = minidom.parse(WORKING_FILE)
    itemlist = xmldoc.getElementsByTagName(ITEM_has_ParameterDef)
    
    print 
    print "#######################################################################"
    print "There are", len(itemlist), "object(s) to verify"
    print "#######################################################################"
    print
    
    # Loop through items and check the attributes
    for attribute in itemlist:
        # print the values just for debugging
        if DEBUG_FLAG:
            print attribute.attributes[ATTRIBUTE_modifiedByUser].value, attribute.attributes[ATTRIBUTE_name].value, attribute.attributes[ATTRIBUTE_defaultValue].value
            
        # check the attributes
        # check the CONSTRING, the value should be $PROJDEF
        if TAG_SEPARATOR + TAG_CONSTRING in attribute.attributes[ATTRIBUTE_name].value:
            if attribute.attributes[ATTRIBUTE_defaultValue].value != VALUE_CONSTRING:
                print "Wrong value for parameter", attribute.attributes[ATTRIBUTE_name].value, "The value is", attribute.attributes[ATTRIBUTE_defaultValue].value                      
                countOfErrors += 1
        # check the VALUE_USER, the value should be $PROJDEF
        elif TAG_SEPARATOR + TAG_USER in attribute.attributes[ATTRIBUTE_name].value:
            if attribute.attributes[ATTRIBUTE_defaultValue].value != VALUE_USER:
                print "Wrong value for parameter", attribute.attributes[ATTRIBUTE_name].value, "The value is", attribute.attributes[ATTRIBUTE_defaultValue].value
                countOfErrors += 1
        # check the VALUE_USER, the value should be {iisenc}eHG47YUwCsilbsYLdMUwUw==
        elif TAG_SEPARATOR + TAG_PSWD in attribute.attributes[ATTRIBUTE_name].value:
            if attribute.attributes[ATTRIBUTE_defaultValue].value != VALUE_PSWD:
                print "Wrong value for parameter", attribute.attributes[ATTRIBUTE_name].value, "The value is", attribute.attributes[ATTRIBUTE_defaultValue].value
                countOfErrors += 1
            
    # Check the Output-Flag and print message
    if countOfErrors > 0:
        print 
        print "#######################################################################"
        print "There are", countOfErrors, "error(s) after check of pst-File. Sorry :-("
        print "#######################################################################"
    else:
        print 
        print "#######################################################################"
        print "There are NO any errors after check of pst-File. Congratulaton :-)"
        print "#######################################################################"
  