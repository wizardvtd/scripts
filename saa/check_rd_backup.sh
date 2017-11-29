#!/bin/bash
# Cygwin + Win
# Script for control RD-Log files in SAA Redolog dir.
# Started from Nagios NRPE client
# Exit codes 0 - ok, 1 - warning, 2 - Error
# For saa_dbrecovery with incremental backup 30 min.

#Detect SAA Dir

cd /cygdrive/c/Disks/RD-Backup/
        for dir in `ls | grep SAA` ;do
patchrd=/cygdrive/c/Disks/RD-Backup/$dir/ARCH/
cd $patchrd
        done

#RD-Logs Backup logic if 00-01 - 2 hours skip cheking, time for SAA Backups
let backupdate=`date +%H` # time for SAA Backups do nothing
#echo $dotime

        if [[ "$backupdate" -eq "0"  ||  "$backupdate" -eq "1" ]]; then
              echo "$backupdate - time for SAA backups - sleep" | tee -a $logfile
               exit 0
                 else
                        # if folder have files more then 40 minutes last acess.
                        rdlogs=`find *.ARCHIVE -amin +40`
                             if [ -z "$rdlogs" ];then
                                echo ok
                                 exit 0
                        #if filder have more then 24 file - error
                               elif [ `ls *.ARCHIVE | wc -l` -ge 24 ];then
                                 echo `ls *.ARCHIVE | wc -l` files in RD-Dir !!!
                                  exit 2
                                else
                        #if filder have files in dir - warning
                                  echo `ls *.ARCHIVE | wc -l` files in RD-Dir
                                  #echo $rdlogs exist
                                  exit 1
                             fi
        fi


