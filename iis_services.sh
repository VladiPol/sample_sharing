#!/bin/bash

# 23.12.2015  R. Penz     V1.00    neu
# 19.02.2016  R. Penz     V1.01    komplett dynamisch, um auf allen 4 Umgebungen lauffaehig zu sein
# 11.03.2016  R. Penz     V1.02    bash festgelegt und pmr, housekeeping eingefuegt, sowie log angepasst
#                                  -q bei ssh unterbindet fast alle Meldungen, ausser Last login und Kickstarted
#                                  In Verbindung mit touch .hushlogin auf der Ziel-Seite wird alles unterbunden
# 14.03.2016  R. Penz     V1.03    Zombies in status und Linux Version fuer pmr aufgenommen
# 01.04.2016  R. Penz     V1.04    Housekeeping errorfiles
# 06.04.2016  R. Penz     V1.05    check_params
# 20.04.2016  R. Penz     V1.06    check_infint_db
# 31.05.2016  R. Penz     V1.07    "status" automatisch vor und nach "stop","start" und "restart" aufrufen,
#                                  um die Zustaende eines eventuellen Problems zu sichern
# 01.06.2016  R. Penz     V1.08    housekeeping Scratch angepasst (dlde nun auch gross geschrieben)
# 15.06.2016  R. Penz     V1.09    DSD Prozesse ebenfalls zaehlen
# 04.07.2016  R. Penz     V1.10    Input Parameter ueberpruefen
# 18.07.2016  R. Penz     V1.11    check infint db zusaetzlich ins LOG umlenken
# 08.08.2016  R. Penz     V1.12    MetadataServer.sh anstatt [start][stop]Server.sh (nun seit Version 11.5 passwortlos)
# 09.08.2016  R. Penz     V1.13    start server1 wieder aktiviert (ist passwortlos), da MetadataServer.sh beim Starten sofort zurueck meldet,
#                                  obwohl Service noch nicht komplett hoch gefahren ist
# 10.08.2016  R. Penz     V1.14    Housekeeping PH und alte pmr-Ordner loeschen
# 11.08.2016  R. Penz     V1.15    Housekeeping DSOMD/xml und Metadata Server Status undefined, falls Kafka wieder reinspielt
# 12.08.2016  R. Penz     V1.16    Dumps aelter 10 Tage loeschen
# 15.09.2016  R. Penz     V1.17    Anzeige der Sourcen-Version
# 27.10.2016  R. Penz     V1.18    Disk Usage anzeigen
# 31.10.2016  R. Penz     V1.19    tee fuer Disk-Size Anzeige einbauen und check infint-DB auf select * from dual erleichtert, da ab und zu komisches Verhalten
#                                  housekeeping um temp und lookuptable erweitert
# 04.11.2016  R. Penz     V1.20    status um Speicher erweitert
# 17.11.2016  R. Penz     V1.20.1  20000 anstatt 5000 Zeilen des Logfiles beim houskeeping behalten
# 02.12.2016  V. Poliakov V1.20.2  wokaround DSMonApp nur fuer DEV
# 05.12.2016  R. Penz     V1.21    Wokaround entfernt und Status fuer DSMonApp dauerhaft auf allen Umgebungen anzeigen
# 12.01.2017  R. Penz     V1.22    Director Runtime Logs loeschen, aber nur auf DEV und Test
# 09.03.2017  V.Poliakov  V1.23    Erweiterung fuer die Maintenance Umgebung
# 21.03.2017  R. Penz     V1.24    kill eingebaut
# 22.03.2017  R. Penz     V1.24.1  ssh Verbindung zu Service-Tier wegen Dumps war nicht sauber eingeklammert. Nun aussen Gaensefuesschen und innen einfaches Hochkomma
# 24.04.2017  R. Penz     V1.25    DSOMDMonApp nach Restart oder Hochfahren stoppen. Wird nicht benoetigt
# 04.05.2017  D. Rahman   V1.26    Einbau PID-File - zweifache Ausfuehrung des Skriptes wird verhindert
# 08.05.2017  R. Penz     V1.27    Housekeeping - DSODB-Logs aelter 20 Tage loeschen
# 12.05.2017  R. Penz     V1.28    Housekeeping - Dumpfiles auf Service-Tier unter WebSphere/AppServer/profiles/InfoSphere loeschen
# 15.05.2017  D. Rahman   V1.29    Einbau der Force-Option als Zweit-Parameter, dieser fuehrt beim stop force zusaetzlich die kill_processes aus
# 24.05.2017  R. Penz     V1.30    Housekeeping - Start- und Endezeit protokollieren und loeschen PH angepasst
# 29.05.2017  D. Rahman   V1.31    Einbau report-Funktion die periodisch zur Ueberwachung genutzt wird. Einbau zip-Funktion in pmr, falls reported wird.
# 06.06.2017  D. Rahman   V1.32    Bugfix of restart option
# 20.06.2017  D. Rahman   V1.33    Added listening of running DSD- and FWK-Processes in case of failed shutdown
# 11.07.2017  M. Hauck    V1.34    Modification of stop function. Stop only when runisalite is NOT running (also when force option is used).
#                                  Show all running processes before killing them (stop force)
#                                  Show count of runisalite processes when displaying status
# 14.07.2017  M. Hauck    V1.35    Added some new directories to pmr function (IBM reporting)
#                                  Update of housekeeping function. Clean up files older 5 days in /APPL/data/de/$P_FOLDER/Projects/DE_DATA_LAKE_SPTE/files/datasets, delete temporary files in /APPL/Scratch
#                                  Update of kill_ds_processes function. Show all killed processes
# 03.08.2017  M. Hauck    V1.36    Dynamic dataset cleanup in the housekeeping process. A search pattern with value "DE_DATA_LAKE" is used now to find all relevant projects folders in "/APPL/data/de/$P_FOLDER/Projects/"
#                                  Before a fixed value (DE_DATA_LAKE_SPTE) was used, but that's wrong because project names are different on each environment.
# 09.08.2017  M. Hauck    V1.37    Small bugfixes; Cleanup of big RT_LOG folders (clear_big_rt_log_folders) in all environments (part of server start process)
# 10.08.2017  M. Hauck    V1.38    Optimisation of clear_big_rt_log_folders. Get rid of useless uvsh log informations

P_SOURCE_VERSION="V1.38"


LOGFILE=$HOME/iis_services.log

# PID of the current script
PID=$$

# current name of the script without directory prefix
SCRIPTNAME=`basename $0`

# path where to write the PIDFILE
PIDFILE=/tmp/$SCRIPTNAME.pid


#
# Funktions-Definitionen
#




log()
{
 echo " " | tee -a $LOGFILE
 echo " " | tee -a $LOGFILE
 echo " " | tee -a $LOGFILE
 echo "######################################################################################################################" | tee -a $LOGFILE
 echo "Skript-Start am `date +'%d.%m.%Y %H:%M'` mit Parameter $P_PARAMETER_LIST ($P_SOURCE_VERSION)" | tee -a $LOGFILE
 echo " " | tee -a $LOGFILE
 echo " " | tee -a $LOGFILE
 echo " " | tee -a $LOGFILE
}  






check_rc()
{
 RC=$?
 if [ "$RC" = "246" ] && [ "$1" = "Stop_Metadata_Server" ]
  then
       echo "********************************* Service server1 war schon unten. Fehler 246 kann daher uebersprungen werden" | tee -a $LOGFILE
  else
       if test $RC -ne 0
        then abbruch $RC $1
       fi
 fi
}





abbruch()
{
 echo " " | tee -a $LOGFILE
 echo "#######################################################################" | tee -a $LOGFILE
 echo "# Abbruch! `date +'%d.%m.%Y %H:%M'` - RC=$1 - $2" | tee -a $LOGFILE
 echo "#######################################################################" | tee -a $LOGFILE
 echo " " | tee -a $LOGFILE
 exit 8
}







set_environment()
{
 P_HOSTNAME=`hostname`
 P_LAST_CHARACTER_OF_HOSTNAME=`echo $P_HOSTNAME | grep -o '.$'`
 case $P_LAST_CHARACTER_OF_HOSTNAME in
    e) P_MASCHINE=dldesd01
       P_FOLDER=dev
       P_INFINT_DB=INFINTE
       P_PASSWORD_INFINT=8kD+j6_efoBUqwCvmN3q ;;
    t) P_MASCHINE=dldest01
       P_FOLDER=tst
       P_INFINT_DB=INFINT1T
       P_PASSWORD_INFINT=8kD+j6_efoBUqwCvmN3q ;;
    v) P_MASCHINE=dldesq01
       P_FOLDER=qa
       P_INFINT_DB=INFINTV
       P_PASSWORD_INFINT=LqweM9s3fPye-uRb52?K ;;
    p) P_MASCHINE=dldesp01
       P_FOLDER=prd
       P_INFINT_DB=INFINTP
       P_PASSWORD_INFINT=LqweM9s3fPye-uRb52?K ;;
    m) P_MASCHINE=dldesm01
       P_FOLDER=mtn
       P_INFINT_DB=INFINT5T
       P_PASSWORD_INFINT=8kD+j6_efoBUqwCvmN3q ;;
 esac 
}  













stop_daemon()
{
 P_WHAT="Stop_DataStage_daemon" 
 echo "********************************* `date +'%d.%m.%Y %H:%M'` - $P_WHAT" | tee -a $LOGFILE
 cd /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/Server/DSEngine
 . ./dsenv
 bin/uv -admin -stop | tee -a $LOGFILE
 check_rc $P_WHAT
}  

start_daemon()
{
 P_WHAT="Start_DataStage_daemon" 
 echo "********************************* `date +'%d.%m.%Y %H:%M'` - $P_WHAT" | tee -a $LOGFILE
 cd /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/Server/DSEngine
 . ./dsenv
 bin/uv -admin -start | tee -a $LOGFILE
 check_rc $P_WHAT
 # DSOMDMonApp wird nicht benoetigt, daher gleich wieder stoppen
 P_WHAT="Stop DSOMDMonApp" 
 cd /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/Server/DSOMD/bin
 ./DSOMDMonApp.sh -stop
 check_rc $P_WHAT
}  






stop_agent()
{
 P_WHAT="Stop_Node_agent" 
 echo "********************************* `date +'%d.%m.%Y %H:%M'` - $P_WHAT" | tee -a $LOGFILE
 cd /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/ASBNode/bin
 ./NodeAgents.sh stop | tee -a $LOGFILE
 check_rc $P_WHAT
}  

start_agent()
{
 P_WHAT="Start_Node_agent" 
 echo "********************************* `date +'%d.%m.%Y %H:%M'` - $P_WHAT" | tee -a $LOGFILE
 cd /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/ASBNode/bin
 ./NodeAgents.sh start | tee -a $LOGFILE
 check_rc $P_WHAT
}  






stop_server1()
{
 P_WHAT="Stop_Metadata_Server" 
 echo "********************************* `date +'%d.%m.%Y %H:%M'` - $P_WHAT" | tee -a $LOGFILE
 echo "ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE cd /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/ASBServer/bin ; ./MetadataServer.sh stop"
 ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "cd /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/ASBServer/bin ; ./MetadataServer.sh stop" 
 check_rc $P_WHAT
}  

start_server1()
{
 P_WHAT="Start_Metadata_Server" 
 echo "********************************* `date +'%d.%m.%Y %H:%M'` - $P_WHAT" | tee -a $LOGFILE
 #ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "cd /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/ASBServer/bin ; ./MetadataServer.sh start" 
 ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "cd /APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere/bin ; ./startServer.sh server1"
 check_rc $P_WHAT
}  





housekeeping()
{
 echo "Start Housekeeping `date +'%d.%m.%Y %H:%M'`" | tee -a $LOGFILE

 # keep only the last 150000 lines of the native_stderr.log
 ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "cd /APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere/logs/server1 ; tail -150000 native_stderr.log >native_stderr.log.tmp ; rm native_stderr.log ; mv native_stderr.log.tmp native_stderr.log"


 # keep only the last 20000 lines of the log
 tail -20000 $LOGFILE >>$LOGFILE.tmp
 rm $LOGFILE
 mv $LOGFILE.tmp $LOGFILE


 # Scratch-Leichen entfernen
 cd /APPL/Scratch/
 rm -f dlde*
 rm -f DLDE*
 rm -f tsort*


 # Folgende Files werden nicht aufgeraeumt,
 # wenn ein DataStage Job per Designer Client anstatt per Shell-Skript gestartet und daher das Framework umgangen wurde
 cd /APPL/data/de/$P_FOLDER/Projects
 for P_PROJECT_DIRECTORY in `ls | grep DE_DATA_LAKE | grep -v grep`
 do
   cd /APPL/data/de/$P_FOLDER/Projects/$P_PROJECT_DIRECTORY/files/errorfiles
   rm -f .*.tmp
   rm -f *.tmp
   rm -f .*.err
   rm -f *.err
 done


 # Folgende Files werden nicht aufgeraeumt. Sie werden pro Lauf/Stage erstellt.
 # http://www-01.ibm.com/support/docview.wss?uid=swg21578601
 # http://www-01.ibm.com/support/docview.wss?uid=swg21457983
 # DSD.RUN_99999_99999_999999
 # DSD.OshMonitor_99999_99999_999999
 # DSD.StageRun_99999_99999_999999
 # SH_99999_99999_999999
 # COPY_99999_99999_999999

 # Stattdessen kann auch die Funktion clear_ph_folder() verwendet werden
 # Jedoch setzt diese Funktion uvsh voraus, was eine Nutzung im Housekeeping Prozess unmöglich macht, da DataStage gestartet sein muss!!!

 cd /APPL/de/$P_FOLDER/Projects
 for P_PROJECT_DIRECTORY in `ls | grep DE_DATA_LA`
 do
   cd "/APPL/de/$P_FOLDER/Projects/$P_PROJECT_DIRECTORY/&PH&"
   find . -name 'DSD.RUN_*'      -type f -delete;
   find . -name 'DSD.StageRun_*' -type f -delete;
   find . -name 'SH*'            -type f -delete;
   find . -name 'COPY*'          -type f -delete;
 done



 
 
 # pmr-Ordner aelter 30 Tage loeschen
 cd $HOME
 find . -name "pmr_20*" -mtime +30 -type d -exec rm -r {} \;
 
 
 # Folgende Files werden nicht aufgeraeumt. Sie werden pro Lauf erzeugt.
 # https://www.ibm.com/support/knowledgecenter/SSZJPZ_11.5.0/com.ibm.swg.im.iis.ds.direct.doc/topics/OperationalMetadata.html
 # https://www.ibm.com/support/knowledgecenter/SSZJPZ_11.3.0/com.ibm.swg.im.iis.found.admin.nav.doc/containers/c_manage_filesys.html
 # Automatisch alle Files mit Namensmuster aelter 2 Stunden loeschen
 cd /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/Server/DSOMD/xml
 find . -name "*DE_DATA_LAKE*" -type f -mmin +120 -delete
 
 
 # Dumps aelter 3 Tage auf Service-Tier loeschen
 ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "cd /APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere ; find . -name 'javacore*.txt' -mtime +3 -type f -delete;"
 ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "cd /APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere ; find . -name 'core*.dmp'     -mtime +3 -type f -delete;"
 ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "cd /APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere ; find . -name 'heapdump*.phd' -mtime +3 -type f -delete;"
 ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "cd /APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere ; find . -name 'Snap*.trc'     -mtime +3 -type f -delete;"
 # folgende gehoeren root, koennen daher nicht geloescht werden
 #ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "cd /APPL/de/$P_FOLDER/ibm/infosphere/ASBServer/bin ; find . -name 'javacore*.txt' -mtime +3 -type f -delete;"
 #ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "cd /APPL/de/$P_FOLDER/ibm/infosphere/ASBServer/bin ; find . -name 'core*.dmp'     -mtime +3 -type f -delete;"
 #ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "cd /APPL/de/$P_FOLDER/ibm/infosphere/ASBServer/bin ; find . -name 'heapdump*.phd' -mtime +3 -type f -delete;"
 #ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "cd /APPL/de/$P_FOLDER/ibm/infosphere/ASBServer/bin ; find . -name 'Snap*.trc'     -mtime +3 -type f -delete;"


 # Folgende Files koennen geloescht werden, falls vorhanden, wenn der Server unten ist
 # Job wahrscheinlich ausgestiegen, da tenmporaere files nicht sauber aufgeraeumt wurden
 # lookuptable.7056.20161031091859927870.qulc5zc
 # temp.dsdedev.dldeed01.0000.0001.0000.50d3.581743ed.0001.efdfd017
 # temp3.dsdedev.dldeed01.0000.0000.0000.6963.58174526.0000.a0721bd9
 cd /APPL/de/$P_FOLDER/Datasets
 rm -f lookuptable.*
 rm -f temp*dsde*
 

 # Runtime Job Logs im Projekt-Ordner loeschen
 if [ "$P_FOLDER" = "dev" ] || [ "$P_FOLDER" = "tst" ]
  then 
       . /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/Server/DSEngine/dsenv
       cd /APPL/de/$P_FOLDER/Projects
       for P_PROJECT_DIRECTORY in `ls | grep DE_DATA_LAKE_SPT`
       do
         ls -1Adt RT_LOG* | while read f
         do
           echo "CLEAR.FILE $f" | $DSHOME/bin/uvsh  >/dev/null
         done
       done
 fi
 
 
 # DSODB-Logs aelter 20 Tage loeschen
 cd /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/Server/DSODB/logs
 find . -name 'odbqapp-20*.log' -mtime +20 -type f -delete;
 find . -name 'ResMonApp-20*.log' -mtime +20 -type f -delete;
 find . -name 'AppWatcher_Svc-20*.log' -mtime +20 -type f -delete;
 find . -name 'AppWatcher-20*.log' -mtime +20 -type f -delete;
 find . -name 'handler-20*.log' -mtime +20 -type f -delete;
 find . -name 'EngMonApp-20*.log' -mtime +20 -type f -delete;
 
 
 # weitere Dumps aelter 3 Tage auf Service-Tier loeschen
 ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "cd /APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere ; find . -name 'javacore20*.txt' -mtime +3 -type f -delete;"
 ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "cd /APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere ; find . -name 'core20*.dmp'     -mtime +3 -type f -delete;"
 ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "cd /APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere ; find . -name 'heapdump20*.phd' -mtime +3 -type f -delete;"
 ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "cd /APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere ; find . -name 'Snap20*.trc'     -mtime +3 -type f -delete;"
 




 #
 # alle Datasets aelter 5 Tage loeschen
 # 1. Header (Binaerfiles werden mit orchadmin automatisch mit geloescht)
 # 2. verwaiste Binaerfiles mit rm loeschen
 #

 cd /APPL/data/de/$P_FOLDER/Projects/
 for P_PROJECT_DIRECTORY in `ls | grep DE_DATA_LAKE | grep -v grep`
 do
 	cd /APPL/data/de/$P_FOLDER/Projects/$P_PROJECT_DIRECTORY/files/datasets
 	find . -name "*.ds" -mtime +5 -type f -exec orchadmin rm {} \;
 done

 cd /APPL/de/$P_FOLDER/Datasets
 find . -name "*.dsde*" -mtime +5 -type f -exec rm {} \;

 #
 # temporaere Files loeschen
 # http://www-01.ibm.com/support/docview.wss?uid=swg21441727 
 #
 cd /APPL/Scratch
 find . -name "dynLUT*" -type f -exec rm {} \;
 find . -name "xml-log-dir" -type d -exec rm –r {} \;







 echo "Ende  Housekeeping `date +'%d.%m.%Y %H:%M'`" | tee -a $LOGFILE
}  








stop()
{
 #
 # Stop only when runisalite is NOT running (also when force option is used)
 #

 # Check on engine tier (runisalite process)
 ps -ef | grep -i runisalite | grep -iv grep> /dev/null
 if [ $? -eq 0 ]; then
  echo "Prozess 'runisalite' läuft auf Engine Tier. Abbruch."
  return
 fi

 # Check on service tier (runisalite process)
 ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "ps -ef | grep -i runisalite | grep -iv grep" > /dev/null
 if [ $? -eq 0 ]; then
  echo "Prozess 'runISALite.sh' läuft auf Service Tier. Abbruch."
  return
 fi

 pid_file 'STOP'
 status
 
 # chcks if FORCE Option is set
 if [[ $1 = "force" ]]
   then
     echo "FORCE-OPTION: KILLING PROCESSES!" | tee -a $LOGFILE 
     kill_ds_processes
 fi  

 # checking for running processes:
 # 0 no processes running
 # 1 processes are running
 local processcount=$(check_process)

 # if processcount equals 0 stopping is initialized
 if [[ $processcount -eq 0 ]]
   then
     stop_daemon
     stop_agent
     stop_server1
     housekeeping
     status
 fi

 # nothing will be done, entry into logfile
 if [[ $processcount -eq 1 ]]
   then echo "PROCESSES ARE RUNNING! STOPPING IS ABORTED" | tee -a $LOGFILE
   echo "Following DSD-Processes are running: "
   ps -eo cmd | grep DSD | grep -v grep
   echo "#############################"
   echo "Following FWK-Processes are running: "
   ps -eo cmd | grep fwk | grep -v grep
   remove_pid_file
   exit 1
 fi

 remove_pid_file
}  

start()
{
 pid_file 'START'
 status
 start_server1
 start_agent
 start_daemon
 status
 remove_pid_file
 clear_big_rt_log_folders
}  

restart()
{
 stop $1
 start
}  








status()
{
 P_ANZAHL=`ps -ef | grep dsrpcd | grep -v grep | wc -l`
 if test $P_ANZAHL -eq 1
  then echo "DataStage daemon (dsrpcd)   - up" | tee -a $LOGFILE
  else echo "DataStage daemon (dsrpcd)   - down" | tee -a $LOGFILE
 fi
 P_ANZAHL=`ps -ef | grep asbagent | grep -v grep | wc -l`
 if test $P_ANZAHL -eq 1
  then echo "Node agent       (asbagent) - up" | tee -a $LOGFILE
  else echo "Node agenti      (asbagent) - down" | tee -a $LOGFILE
 fi
 P_ANZAHL=`ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE ps -ef | grep server1 | grep -v grep | wc -l`
 case $P_ANZAHL in
    0) echo "Metadata Server  (server1)  - down" | tee -a $LOGFILE ;;
    1) echo "Metadata Server  (server1)  - up" | tee -a $LOGFILE ;;
    *) echo "Metadata Server  (server1   - undefined" | tee -a $LOGFILE ;;
 esac 

 check_infint_db | tee -a $LOGFILE

 cd /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/Server/DSODB/bin
 ./DSAppWatcher.sh -status | tee -a $LOGFILE

 cd /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/Server/DSOMD/bin
 ./DSOMDMonApp.sh -status | tee -a $LOGFILE

 P_ANZAHL=`ps -ef | grep defunct | grep -v grep | wc -l`
 echo "Count Zombies              = " $P_ANZAHL | tee -a $LOGFILE
 P_ANZAHL_OSH=`ps -ef | grep osh | grep -v grep | wc -l`
 echo "Count osh-Processes        = " $P_ANZAHL_OSH | tee -a $LOGFILE
 P_ANZAHL_DSD=`ps -ef | grep DSD | grep -v grep | wc -l`
 echo "Count DSD-Processes        = " $P_ANZAHL_DSD | tee -a $LOGFILE
 P_ANZAHL_RUNISALITE=`ps -ef | grep -i runisalite | grep -v grep | wc -l`
 P_ANZAHL_RUNISALITE_IISADMIN=`ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE "ps -ef | grep -i runisalite | grep -iv grep | wc -l"`

 echo "Count runisalite-Processes = " $(($P_ANZAHL_RUNISALITE+$P_ANZAHL_RUNISALITE_IISADMIN)) | tee -a $LOGFILE

 P_ANZAHL_FWK=`ps -ef | grep fwk | grep -v grep | wc -l`
 echo "Count fwk-Skripte          = " $P_ANZAHL_FWK | tee -a $LOGFILE

 P_SIZE=$(df -h /APPL | grep /APPL | awk '{print $1}')
 P_AVAIL=$(df -h /APPL | grep /APPL | awk '{print $3}')
 P_USEpercent=$(df -h /APPL | grep /APPL | awk '{print $4}')
 echo "Engine-Tier:  /APPL      $P_AVAIL von $P_SIZE frei. $P_USEpercent benutzt." | tee -a $LOGFILE
 P_SIZE=$(df -h /APPL/data | grep /APPL | awk '{print $1}')
 P_AVAIL=$(df -h /APPL/data | grep /APPL | awk '{print $3}')
 P_USEpercent=$(df -h /APPL/data | grep /APPL | awk '{print $4}')
 echo "              /APPL/data $P_AVAIL von $P_SIZE frei. $P_USEpercent benutzt." | tee -a $LOGFILE
 P_SIZE=`ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE df -h /APPL | grep /APPL | awk '{print $1}'`
 P_AVAIL=`ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE df -h /APPL | grep /APPL | awk '{print $3}'`
 P_USEpercent=`ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE df -h /APPL | grep /APPL | awk '{print $4}'`
 echo "Service-Tier: /APPL      $P_AVAIL von $P_SIZE frei. $P_USEpercent benutzt." | tee -a $LOGFILE
 
 P_Memtotal=$(free -h | grep "Mem:" | awk '{print $2}')
 P_Memfree=$(free -h | grep "Mem:" | awk '{print $4}')
 P_Swaptotal=$(free -h | grep "Swap:" | awk '{print $2}')
 P_Swapfree=$(free -h | grep "Swap:" | awk '{print $4}')
 echo "Engine-Tier:  $P_Memfree von $P_Memtotal Memory frei - $P_Swapfree von $P_Swaptotal Swap frei." | tee -a $LOGFILE
 P_Memtotal=`ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE free -h | grep "Mem:" | awk '{print $2}'`
 P_Memfree=`ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE free -h | grep "Mem:" | awk '{print $4}'`
 P_Swaptotal=`ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE free -h | grep "Swap:" | awk '{print $2}'`
 P_Swapfree=`ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE free -h | grep "Swap:" | awk '{print $4}'`
 echo "Service-Tier: $P_Memfree von $P_Memtotal Memory frei - $P_Swapfree von $P_Swaptotal Swap frei." | tee -a $LOGFILE
}  

# erste Fassung
check_status()
{
  P_ANZAHL_DS=`ps -ef | grep dsrpcd | grep -v grep | wc -l`
  P_ANZAHL_ASB=`ps -ef | grep asbagent | grep -v grep | wc -l`
  P_ANZAHL_SER=`ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE ps -ef | grep server1 | grep -v grep | wc -l`
 
  ## TODO
  #P_INFINT_DB=check_infint_db
  #echo "INFINTDB: ${P_INFINT_DB}"
  #[[ P_INFINT_DB = "force" ]]
  
  
  # 1 = The process is running
  # 2 = The process is not running
  # 3 = Monitoring is not enabled
  cd /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/Server/DSODB/bin
  P_ST_AppWatcher=`./DSAppWatcher.sh -status AppWatcher`
  P_ST_EngMonApp=`./DSAppWatcher.sh -status EngMonApp`
  P_ST_ResMonApp=`./DSAppWatcher.sh -status ResMonApp`
  P_ST_ODBQueryApp=`./DSAppWatcher.sh -status ODBQueryApp`
 
  # wird nicht überwacht
  # 1 = deamon is not running
  #cd /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/Server/DSOMD/bin
  #P_ST_SOMDMonApp=`./DSOMDMonApp.sh -status`

  cd $HOME
  
  P_USEpercent_ENGINE_APPL=$(df -h /APPL | grep /APPL | awk '{print substr($4, 1, length($4)-1)}')
  P_USEpercent_ENGINE_APPL_DATA=$(df -h /APPL/data | grep /APPL | awk '{print substr($4, 1, length($4)-1)}')
  P_USEpercent_SERVICE=`ssh -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE df -h /APPL | grep /APPL | awk '{print substr($4, 1, length($4)-1)}'`
  

  if [[ $P_ANZAHL_DS -eq 0 ]] || [[ $P_ANZAHL_ASB -eq 0 ]] || [[ $P_ANZAHL_SER -ne 1 ]] || [[ $P_USEpercent_ENGINE_APPL -gt 95 ]] || [[ $P_USEpercent_ENGINE_APPL_DATA -gt 95 ]] || [[ $P_USEpercent_SERVICE -gt 95 ]] || [[ $P_ST_AppWatcher == "AppWatcher:STOPPED" ]] || [[ $P_ST_EngMonApp == "EngMonApp:STOPPED" ]] || [[ $P_ST_ResMonApp == "ResMonApp:STOPPED" ]] || [[ $P_ST_ODBQueryApp == "ODBQueryApp:STOPPED" ]] # || [[ $P_ST_SOMDMonApp == "DSOMDMonApp:NOT_RUNNING" ]]
    then 
      pmr "report"
  fi
  
}

pmr()
{
 P_DIR="$HOME/pmr_`date +'%Y%m%d_%H%M'`"
 mkdir -p $P_DIR
 cd $P_DIR
 cp /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/Version.xml Version_Engine_Tier.xml
 scp -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE:/APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/Version.xml Version_Service_Tier.xml
 scp -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE:/APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere/logs/igc.log igc.log
 scp -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE:/APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere/logs/server1/SystemOut.log SystemOut.log
 scp -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE:/APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere/logs/server1/SystemErr.log SystemErr.log
 scp -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE:/APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere/logs/server1/startServer.log startServer.log
 scp -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE:/APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere/logs/server1/stopServer.log stopServer.log
 scp -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE:/APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere/logs/server1/native_stdout.log native_stdout.log
 scp -q -i $HOME/.ssh/sshkey_rsa_private iisadmin@$P_MASCHINE:/APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere/logs/server1/native_stderr.log native_stderr.log

 mkdir -p ASBNode_logs
 cp /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/ASBNode/logs/asb-agent-*.out ASBNode_logs/.
 mkdir -p DSODB_logs
 cp /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/Server/DSODB/logs/* DSODB_logs/. 

 cp ~/istool_workspace/.metadata/.log local_log_file.log

 echo "Version_Engine_Tier.xml  (Original Version.xml)    from Engine-Tier   /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer" >>readme.txt
 echo "Version_Service_Tier.xml (Original Version.xml)    from Service-Tier  /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer" >>readme.txt
 echo "igc.log                                            from Service-Tier  /APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere/logs" >>readme.txt
 echo "SystemOut.log                                      from Service-Tier  /APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere/logs/server1" >>readme.txt
 echo "SystemErr.log                                      from Service-Tier  /APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere/logs/server1" >>readme.txt
 echo "startServer.log                                    from Service-Tier  /APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere/logs/server1" >>readme.txt
 echo "stopServer.log                                     from Service-Tier  /APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere/logs/server1" >>readme.txt
 echo "native_stdout.log                                  from Service-Tier  /APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere/logs/server1" >>readme.txt
 echo "native_stderr.log                                  from Service-Tier  /APPL/de/$P_FOLDER/ibm/infosphere/WebSphere/AppServer/profiles/InfoSphere/logs/server1" >>readme.txt
 echo "ASBNode_logs/                                      from Engine-Tier   /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/ASBNode/logs/asb-agent-*.out"       >>readme.txt
 echo "DSODB_logs/                                        from Engine-Tier   /APPL/de/$P_FOLDER/ibm/infosphere/InformationServer/Server/DSODB/logs/*"                >>readme.txt
 echo "local_log_file.log                                 from Engine-Tier   ~/istool_workspace/.metadata/.log"                                                      >>readme.txt
 echo " " >>readme.txt

 P_VERSION=`uname -a`
 echo "Linux-Version (RedHat) via uname -a   ===>>> $P_VERSION" >>readme.txt
 echo "Files wurden im Verzeichnis $P_DIR fuer einen eventuellen PMR abgelegt" | tee -a $LOGFILE
 cd

  ## TODO: entsprechende Logeintraege einfuegen
  if [[ $1 = "report" ]]
   then 
    zip -qr $P_DIR $P_DIR
    P_ZIP_NAME=$P_DIR.zip
    status | mailx -s "IIS_SERVICES" -a $P_ZIP_NAME -a $LOGFILE SP_ITBCC-WAREHOUSING@ing-diba.de
  fi
}  






check_params()
{
 # Normalfall ein Input-Parameter. Bei zwei muss es aber stop und force sein -> sonst Abbruch
 P_COUNT_PARAMETER=`echo $P_PARAMETER_LIST | wc -w`   

 if [ $P_COUNT_PARAMETER -gt 2 ] || [ $P_COUNT_PARAMETER -lt 1 ]
   then abbruch 8 "Es sind nur 1-2 Input-Parameter erlaubt"
 fi

 P_PARAMETER1=$(echo $P_PARAMETER_LIST | awk '{print $1}')
 P_FORCE="No"
 if [ $P_COUNT_PARAMETER = 2 ]
   then P_PARAMETER2=$(echo $P_PARAMETER_LIST | awk '{print $2}')
        if [ "$P_PARAMETER1" != "stop" ] || [ "$P_PARAMETER2" != "force" ]
          then abbruch 8 "Falsche Input-Parameter Kombination / Usage: $0 { start | stop [force] | restart | status | pmr }"
          else P_FORCE="Yes"
        fi
 fi
}  






check_infint_db()
{
 SQLrueckgabe=`sqlplus -s dlfwk_read/$P_PASSWORD_INFINT@$P_INFINT_DB <<HERE_SCRIPT
    whenever sqlerror exit 9
    select * from dual;
    exit 0
HERE_SCRIPT`
if test $? -ne 0
 then echo "$P_INFINT_DB                     - down"
 else echo "$P_INFINT_DB                     - up"
fi
}






testing()
{
 P_WHAT="Check auf laufende Prozesse" 
 check_running_processes
 check_rc $P_WHAT

}  




#  >= RT_LOGs aufraeumen: 1GB Files DATA.30 und OVER.30 mit CLEAR per universe shell loeschen
clear_big_rt_log_folders()
{
 P_WHAT="Grosse RT_LOG Ordner aufraeumen"
 echo "********************************* `date +'%d.%m.%Y %H:%M'` - $P_WHAT" | tee -a $LOGFILE

 cd /APPL/de/$P_FOLDER/Projects
 for P_PROJECT_DIRECTORY in `ls | grep DE_DATA_LAKE`
 do
   cd /APPL/de/$P_FOLDER/Projects/$P_PROJECT_DIRECTORY/

   f=`du -h RT_LOG* --max-depth=1 | grep '[0-9]G\>' | awk -F '\t' '{print $2}'`
   for e in $f; do $DSHOME/bin/uvsh "clear.file $e" | cut -b 6- | tee -a $LOGFILE; done
 done


 echo "Ende  Housekeeping `date +'%d.%m.%Y %H:%M'`" | tee -a $LOGFILE
}

clear_ph_folder()
{
 P_WHAT="PH Ordner aufraeumen"
 echo "********************************* `date +'%d.%m.%Y %H:%M'` - $P_WHAT" | tee -a $LOGFILE
 cd /APPL/de/$P_FOLDER/Projects
 for P_PROJECT_DIRECTORY in `ls | grep DE_DATA_LAKE`
 do
   cd /APPL/de/$P_FOLDER/Projects/$P_PROJECT_DIRECTORY/
   echo "CLEAR.FILE &PH&" | $DSHOME/bin/uvsh  >/dev/null 
 done
}





check_running_processes()
{
 P_ANZAHL_OSH=`ps -ef | grep osh | grep -v grep | wc -l`
 P_ANZAHL_DSD=`ps -ef | grep DSD | grep -v grep | wc -l`
 if [ "$P_ANZAHL_OSH" > "0" ] || [ "$P_ANZAHL_DSD" > "0" ]
  then
       echo "********************************* Laufende Prozesse unterwegs. Restart/Stop wird nicht durchgefuehrt" | tee -a $LOGFILE
       #exit 9
  else
       echo "********************************* Nichts los. Restart/Stop kann durchgefuehrt werden" | tee -a $LOGFILE
       #exit 6
 fi
}






kill_process()
{
 P_ANZAHL=`ps -ef | grep $1 | grep -v grep | wc -l`

 if [ $P_ANZAHL -gt 0 ]
  then
   for i in {1..10}
    do
     ps -ef | grep $1 | grep -v grep | awk '{print $2}' | xargs kill -9 > /dev/null 2>&1
    done
 fi
}

kill_ds_processes()
{
 # List all running DSD and FWK processes
 echo "Following DSD-Processes are running: "
 ps -eo cmd | grep DSD | grep -v grep
 echo "#############################"
 echo "Following FWK-Processes are running: "
 ps -eo cmd | grep fwk | grep -v grep

 P_ANZAHL_Z=`ps -ef | grep defunct | grep -v grep | wc -l`
 P_ANZAHL_O=`ps -ef | grep osh | grep -v grep | wc -l`
 P_ANZAHL_D=`ps -ef | grep DSD | grep -v grep | wc -l`
 P_ANZAHL_F=`ps -ef | grep fwk | grep -v grep | wc -l`

 if [ $P_ANZAHL_Z -gt 0 ]
   then kill_process "defunct"
 fi

 if [ $P_ANZAHL_O -gt 0 ]
   then kill_process "osh"
 fi

 if [ $P_ANZAHL_D -gt 0 ]
   then kill_process "DSD"
 fi

 if [ $P_ANZAHL_F -gt 0 ]
   then kill_process "fwk"
 fi

}

check_process()
{
  P_ANZAHL_O=`ps -ef | grep osh | grep -v grep | wc -l`
  P_ANZAHL_D=`ps -ef | grep DSD | grep -v grep | wc -l`
  P_ANZAHL_F=`ps -ef | grep fwk | grep -v grep | wc -l`

  if [[ P_ANZAHL_O -gt 0 ]] || [[ P_ANZAHL_D -gt 0 ]] || [[ P_ANZAHL_F -gt 0 ]]
    then echo 1
  else
    echo 0
  fi

}







# checks and  creates pid file
pid_file()
{
 PARAM=$1
 
 # ENDEXECUTION - if 1 then stop script, if 0 everything is ok and continue
 ENDEXECUTION=0
 
 if [ -f "$PIDFILE" ]
 then
     PIDFILECONTENT=`cat "$PIDFILE"`
     RUNNINGPID=$( cut -d ':' -f 1 <<< "$PIDFILECONTENT" )
     STATUS=$( cut -d ':' -f 2 <<< "$PIDFILECONTENT" )
 
     PROGRAMPID=`ps -e | grep "$SCRIPTNAME" | grep -v grep | awk '{print $1;}'`
     for PIDEL in $PROGRAMPID
     do
         if [ "$PIDEL" == "$RUNNINGPID" ]
         then
             echo "found PID $RUNNINGPID current running - end execution"
             ENDEXECUTION=1
             break
         fi
     done
 fi
 
 if [ "$ENDEXECUTION" == "1" ]
 then
     echo "Current script '$SCRIPTNAME' already running (pid $RUNNINGPID) with Parameter $STATUS - end execution"
     exit 1
 fi
 # writing PID to pidfile
 echo "$PID:$PARAM" > $PIDFILE
}







remove_pid_file()
{
 rm $PIDFILE
}








#
# Main Program
#

# Parameterliste muss an dieser Stelle gesichert werden, da sie nach dem Aufruf der Funktion check_params nicht mehr abrufbar ist
P_PARAMETER_LIST=$*
check_params
set_environment
log

case $P_PARAMETER1 in
   'start') start ;;
   'stop')  stop $2 ;;
   'restart') restart $2 ;;
   'status')  status ;;
   'pmr')     pmr ;;
   'testing') testing ;;
   'clear_big_rt_log_folders') clear_big_rt_log_folders ;;
   'report') check_status ;;
   'kill')    kill_ds_processes ;;
   *)
     abbruch 8 "Usage: $0 { start | stop [force] | restart | status | pmr | kill}" ;;
esac

exit 0
