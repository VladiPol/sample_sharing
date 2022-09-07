#!/bin/bash
#
# Name: oracle_full_client_install.sh
# Autor: Vladimir Poliakov TeamBank AG
# Email: vladimir.poliakov@teambank.de
# Version 1.0: 25.08.2022 - initial
# Beschreibug: Shell Skript zum manuellen Installieren von Oracle Full Client
#

# Version-Hinweis
VERSION_STRING="Version 1.0: 25.08.2022 - initial"

# Name der Log-Datei
LOGFILE=/opt/treiber/oracle_full_client_install.log

# Usage-Hinweis
USAGE_STRING="all | about"

# Oracle System User, Gruppe und Base-Verzeichnis
ORACLE_TECHNICAL_USER=oracle
ORACLE_OINSTALL_GROUP=oinstall
ORACLE_BASE=/opt/treiber/oracle
ORACLE_RESPONSE_FILE=/opt/treiber/oracle/install/client_install.rsp
ORACLE_PACKAGE_LIST="bc binutils compat-libcap1 compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel fontconfig-devel glibc glibc-devel ksh libaio libaio-devel libX11 libXau libXi libXtst libXrender libXrender-devel libgcc libstdc++ libstdc++-devel libxcb make smartmontools sysstat oracle-database-preinstall-19c-1.0-1.el7.x86_64"

# Start
log_start()
{
 echo " " | tee -a $LOGFILE
 echo "######################################################################################################################" | tee -a $LOGFILE
 echo "Skript-Start am `date +'%d.%m.%Y %H:%M'`" | tee -a $LOGFILE
 echo "######################################################################################################################" | tee -a $LOGFILE
 echo " " | tee -a $LOGFILE 
}

# End
log_end()
{
 echo " " | tee -a $LOGFILE
 echo "######################################################################################################################" | tee -a $LOGFILE
 echo "Skript-End am `date +'%d.%m.%Y %H:%M'`" | tee -a $LOGFILE
 echo "######################################################################################################################" | tee -a $LOGFILE
 echo " " | tee -a $LOGFILE 
}

# Check Eingabeparameter
check_input_params(){
    # Normalfall ein Input-Parameter. -> sonst Abbruch
    INPUT_COUNT_PARAMETER=`echo $P_PARAMETER_LIST | wc -w`
    
    if [ $INPUT_COUNT_PARAMETER -eq 0 ] || [ $INPUT_COUNT_PARAMETER -gt 1 ]
    then
        echo "Falsche Input-Parameter Kombination / Usage: $0 { $USAGE_STRING }" | tee -a $LOGFILE
        exit 1
    fi

    INPUT_PARAMETER_1=$(echo $P_PARAMETER_LIST | awk '{print $1}')
}

# Alles installieren
all(){
    echo "*** [INFO] Es geht los..." | tee -a $LOGFILE

    # Die Analytics-Pipeline sollte schon gelaufen sein
    # Die Config-Datei und Repose-Datei fuer den Oracle Full Client muesste auf dem Server liegen
    if [ -f "$ORACLE_RESPONSE_FILE" ]; then
        echo "*** [OK] Oracle Full Client response Datei bereits vorhanden" | tee -a $LOGFILE
    else
        echo "*** [NOK] Oracle Full Client response Datei noch nicht vorhanden" | tee -a $LOGFILE
        echo "*** [INFO] Ist die Analytics-Pipeline bereits gelaufen?" | tee -a $LOGFILE
        echo "*** [ERROR] Abbruch, weil Oracle Full Client response Datei noch nicht vorhanden ist" | tee -a $LOGFILE
        return
    fi

    # Oracle oracle-database-preinstall-19c-1.0-1.el7.x86_64.rpm und die anderen Pakete sollte bereits installeirt werden
    # Checking Kernel and Package Requirements for Linux (https://docs.oracle.com/en/database/oracle/oracle-database/19/lacli/supported-red-hat-enterprise-linux-7-distributions-for-x86-64.html#GUID-2E11B561-6587-4789-A583-2E33D705E498)
    echo "*** [INFO] Checking Kernel and Package Requirements for Linux..." | tee -a $LOGFILE
    CHECK_PACKAGES=$(rpm -q $ORACLE_PACKAGE_LIST | grep "is not installed")
    if [ -z "$CHECK_PACKAGES" ]; then
      echo "*** [OK] Checking Kernel and Package Requirements for Linux war erfolgreich" | tee -a $LOGFILE
    else
      echo "*** [ERROR] $CHECK_PACKAGES" | tee -a $LOGFILE
      echo "*** [NOK] Nicht alle Packages sind installiert worden" | tee -a $LOGFILE
      echo "*** [INFO] Ist die Analytics-Pipeline bereits gelaufen?" | tee -a $LOGFILE
      echo "*** [ERROR] Abbruch, weil nicht alle Packages installiert worden sind" | tee -a $LOGFILE
      return
    fi
    
    # Oracle Full Client runter laden    
    echo "*** [INFO] Check if Oracle Full Client ZIP exists" | tee -a $LOGFILE
    if [ -e /opt/treiber/full_oracle_client_x64-19.3.zip ]; then
        echo "*** [OK] Oracle Full Client ZIP bereits vorhanden" | tee -a $LOGFILE
    else
        echo "*** [INFO] Oracle Full Client runter laden" | tee -a $LOGFILE
        curl --show-error --fail --output /opt/treiber/full_oracle_client_x64-19.3.zip https://nexus.prod.oscp.easycredit.intern/repository/analytics-hosted-public-raw/oracle/full_oracle_client_x64-19.3.zip
        echo "*** [OK] Oracle Full Client downgeloadet" | tee -a $LOGFILE
    fi

    # Oracle Treiber auspacken und die Rechte setzen
    echo "*** [INFO] Packe den Oracle Treiber ZIP aus..." | tee -a $LOGFILE
    chown -R $ORACLE_TECHNICAL_USER:$ORACLE_OINSTALL_GROUP $ORACLE_BASE
    chmod -R 775 $ORACLE_BASE
    # unzip as oracle user
    su oracle --command "cd /opt/treiber/oracle/product/19.0.0/dbhome_1; \
                         unzip -qo /opt/treiber/full_oracle_client_x64-19.3.zip"
    echo "*** [OK] Oracle Treiber ZIP ausgepackt" | tee -a $LOGFILE

    # START der Installation
    echo "*** [INFO] Installiere Oracle Full Client als oracle user"
    su oracle --command "cd /opt/treiber/oracle/product/19.0.0/dbhome_1/client; \
                         ./runInstaller -ignoreSysPrereqs -showProgress -silent -noconfig -responseFile $ORACLE_RESPONSE_FILE"

    echo "*** [INFO] Warten 5 Minuten bis die Installation von Oracle Full Client abgeschlossen wird..."
    sleep 5m
    echo "*** [INFO] Das Warten 5 Minuten ist zu Ende"

    echo "*** [INFO] Rechte als root anpassen"
    /opt/treiber/oracle/oraInventory/orainstRoot.sh

    echo "*** [INFO] als oracle user Installation abschliessen"
    su oracle --command "cd /opt/treiber/oracle/product/19.0.0/dbhome_1/client; \
                         ./runInstaller -executeConfigTools -silent -responseFile $ORACLE_RESPONSE_FILE"

    echo "*** [INFO] Warten 1 Minute bis die Konfiguration von Oracle Full Client abgeschlossen wird"
    sleep 1m
    echo "*** [INFO] Das Warten 1 Minute ist zu Ende"

    echo "*** [INFO] default SQL*Plus PROMPT anpassen"
    su oracle --command "cd /opt/treiber/oracle/product/19.0.0/dbhome_1/sqlplus/admin/; \
                         cp -rf glogin.sql glogin.sql.default"
    echo "set sqlprompt \"_user'@'_connect_identifier'>'\"" >> /opt/treiber/oracle/product/19.0.0/dbhome_1/sqlplus/admin/glogin.sql
    echo "*** [INFO] Oracle Full Client Installation abgeschlossen"
    # ENDE der Installation
}

# Nur die Info hole
about(){
    echo $VERSION_STRING | tee -a $LOGFILE
}

#
# Main Program
#
# Parameterliste muss an dieser Stelle gesichert werden, da sie nach dem Aufruf der Funktion check_params nicht mehr abrufbar ist
P_PARAMETER_LIST=$*
check_input_params
log_start

case $INPUT_PARAMETER_1 in
   'all')                   all                ;;
   'about')                 about              ;;
   *)
     echo "ERROR --> Usage: $0 { $USAGE_STRING }" | tee -a $LOGFILE
     exit 1 ;;
esac

log_end

exit 0
