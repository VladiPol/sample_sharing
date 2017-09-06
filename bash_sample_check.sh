#!/bin/bash

P_ANZAHL=`ps -ef | grep defunct | grep -v grep | wc -l`
P_FREE=`free -gt | grep Total | awk '{print $4}'`
P_SWAP_FREE=`free -mt | grep Total | awk '{print $4}'`

# Geater than 400 --> Email
if test $P_ANZAHL -gt 400 -o $P_FREE -lt 25 -o $P_SWAP_FREE -lt 1024
then    
    echo "Count Zombies    = $P_ANZAHL"
    echo "Free Memory      = $P_FREE GB"
    echo "Free Swap Memory = $P_SWAP_FREE MB"
    
    # Email to ...
    (
    echo "Count Zombies    = $P_ANZAHL"
    echo "Free Memory      = $P_FREE GB"
    echo "Free Swap Memory = $P_SWAP_FREE MB"
    ) | mailx -s "Zombies Attack" vorname.name@mailserver.de
fi


# ######################################################################################################
# Trailsatz Format T||3||20140203 --> T = Trail, Anzahl Zeilen zur Verarbeitung, Stichtag der Lieferung 
# Field Separator ist zwei Pipes Zeichen "||"
# 6 Dateien einzeln untersuchen. Es wird pro Datei eine eindeutige Fehlermeldung erwartet
# ######################################################################################################
# echo "Trailersatz Verarbeitung ___________________________"
# Flag, ob ein Fehler beim Verarbeiten vom Trailersatz aufgetret ist (default=FALSE)
P_ERROR_EXIST=FALSE
# Liste der Dateien zum Abarbeiten
P_FILE_LIST=`ls dwh.*.$datest`
# echo "P_FILE_LIST = $P_FILE_LIST"
for P_FILENAME in $P_FILE_LIST
do
  echo "Trailersatz Verarbeitung fuer   ==> :  $P_FILENAME"
  P_TRAIL_FLAG=`tail --lines=1 $P_FILENAME | awk -F '\\\|\\\|' '{print $1}'`
  P_TRAIL=`tail --lines=1 $P_FILENAME | awk -F '\\\|\\\|' '{print $2}'`
  P_DELIVERED_ROWS=`wc -l < $P_FILENAME | awk '{print $1-2}'`
  echo "Trailerflag  ___________________==> :  $P_TRAIL_FLAG"
  echo "Trailersatz  ___________________==> :  $P_TRAIL Rows"  
  echo "Lieferung    ___________________==> :  $P_DELIVERED_ROWS Rows"
  
  # Pruefung, ob der Trailersatz richtig ist
  if [ $P_TRAIL_FLAG != "T" ]
    then echo "Fehler, kein Trailersatz vorhanden"
    P_ERROR_EXIST=TRUE
    else
      # Stimmt der Trailersatz mit der Leiferung überein?
      if [ $P_TRAIL -ne $P_DELIVERED_ROWS ] 
        then echo "Fehler, der Trailersatz stimmt mit der Leiferung nicht überein "
        P_ERROR_EXIST=TRUE
      fi 
  fi   
done

if [ $P_ERROR_EXIST == "TRUE" ]
  then echo "Fehler beim Verarbeiten des Trailersatzes"
  exit 4
fi