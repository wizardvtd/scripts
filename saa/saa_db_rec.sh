#!/bin/bash
date=`date +%H:%M`
# Variables for script
#--------------------------------
#Server(s) to sync or copy
serverto=( [1]="user@server1" [2]="user@server2" [3]="user@server3" )
#echo ${serverto[@]}


#Time between incremental backup
incrbacktime=1800
#--------------------------------
# Static vars for cyrcles
count=0
mytime=0
while a=0 ;do
# Logfile logic
mkdir -p /cygdrive/m/sync_log/`date +%A`
cd /cygdrive/m/sync_log/`date +%A`
logfile=/cygdrive/m/sync_log/`date +%A`/saa_sync.log
testf=`find saa_sync.log -ctime +5`
#testf=`find saa_sync.log -amin +1`
#echo $testf
   if [ -f "$testf" ]; then
      echo "old Logfile exist" | tee -a $logfile
           rm /cygdrive/m/sync_log/`date +%A`/saa_sync.log | tee -a $logfile
           echo "new log created for `hostname` `date`" | tee -a $logfile
         elif [ -f "$logfile" ]; then
         echo "------------- Logfile exist -------------" | tee -a $logfile
         echo "New RD-cyrcle for `hostname` `date` " | tee -a $logfile
          else 
              echo "start log for `hostname` `date`" | tee -a $logfile
   fi
#exit

#RD-Backup do
fulltime=`date +%s`
let dotime=$fulltime-$mytime
let backupdate=`date +%H` # time for SAA Backups do nothing
#echo $dotime
        if [[ "$backupdate" -eq "0" || "$backupdate" -eq "1" ]]; then 
              echo "$backupdate - time for SAA backups - sleep" | tee -a $logfile
	         elif [ "$mytime" -eq "0" ];then
	            echo do Incremental Backup - this is first run | tee -a $logfile
                    mytime=`date +%s`
                      ttnb=$incrbacktime
                time /cygdrive/k/Alliance/access/bin/saa_dbrecovery.cmd -c i | tee -a $logfile
                        elif [ "$dotime" -ge "$incrbacktime" ]; then
                	   echo do Incremental Backup - after 30 min | tee -a $logfile
                           mytime=`date +%s`
                           #echo $mytime
                 time /cygdrive/k/Alliance/access/bin/saa_dbrecovery.cmd -c i | tee -a $logfile
        
         else
          let ttnb=$incrbacktime-$dotime
          
        fi

#RD-Log Backup
cd /cygdrive/c/Disks/RD-Log
	for dir in `ls | grep SAA` ;do
	   echo "Folder in RD-Log dir: $dir" | tee -a $logfile

        #from 1 to 3
	if [ "$count" -lt "3" ];then
                let count=$count+1
		echo "RD-Log count is: $count" | tee -a $logfile
	else
             let count=1
             echo "RD-Log count is: $count" | tee -a $logfile
        fi

# Making local Tmp Dirs for copy and zipping
mkdir -p /cygdrive/c/Tmp/RD-Log/$dir
echo "Copyng before compress..." | tee -a $logfile
time cp -rv /cygdrive/c/Disks/RD-Log/$dir/*  /cygdrive/c/Tmp/RD-Log/$dir/ | tee -a $logfile
cd /cygdrive/c/Tmp/RD-Log/
echo "Compress files in Temp folder..." | tee -a $logfile
time tar -zcvf /cygdrive/c/Tmp/rd-log.tar.gz $dir | tee -a $logfile

# Sync module (SAA Data)
   for serverto in ${serverto[@]};do
       echo Syncyng --- $serverto ---
        #Making dirs on rempote server
	ssh $serverto mkdir -p /mnt/sync/SYNC/srv_sync/`hostname`/RD-Log/ 
   # Sync SAA RD
	echo "Rsync RD-Log" | tee -a $logfile
	time rsync -lzuogthvr --compress-level=0 --delete-after  /cygdrive/c/Tmp/rd-log.tar.gz $serverto:/mnt/sync/SYNC/srv_sync/`hostname`/RD-Log/rd-log_$count.tar.gz | tee -a $logfile
	echo "Rsync RD-Backup" | tee -a $logfile
	time rsync -lzuogthvr --compress-level=9 --delete-after  /cygdrive/c/Disks/RD-Backup/$dir/ $serverto:/mnt/sync/SYNC/srv_sync/`hostname`/RD-Backup/$dir | tee -a $logfile
   #Sync SAA DbBackup
	echo "Rsync SAA DbBackup" | tee -a $logfile
        time rsync -lzuogthvr --compress-level=9 --delete-after  /cygdrive/m/alliance_backarch/backup/db/ $serverto:/mnt/sync/SYNC/srv_sync/`hostname`/db | tee -a $logfile
       echo End of Syncyng ---- $serverto ---
   done


# Sync configs
source conf_sync_git_inc.sh


        if [[ "$backupdate" -eq "0"  ||  "$backupdate" -eq "1" ]]; then 
                   # SAA Event Lournal and DB zip and sync
                   #cmd /c db_eja_run.cmd
                      # GIT Storage update commit
                      source gitsync_inc.sh
              else 
		echo "It's not my time: `date +%H:%M:%S` GIT not commit EJA and DB not Sync" | tee -a $logfile

        fi

	        if [[ "$backupdate" -eq "2"  ||  "$backupdate" -eq "3" ]]; then 
                      source saa_backup_zip_sync.sh
              else 
		echo "It's not my time: `date +%H:%M:%S` MFA backups Not Sync" | tee -a $logfile

        fi

echo ----------- circle time  `date +%H:%M:%S`  ------------- | tee -a $logfile
echo "last RD-Log count is: $count" | tee -a $logfile
echo "time to next backup: $ttnb sec" | tee -a $logfile

	done

sleep 200
done

