#!/bin/bash

# Script for SAG Backup
# Params:
# Monthly backup at 15
# Daily SAG DB Backup - max 6 backups
# Auto log rotate. After 7 days - new log per dir



date=`date +%H:%M`
# Variables for script
#--------------------------------
#Server(s) pool to sync or copy
serverto=( [1]="user@server1" [2]="user@server2" [3]="user@server3" )


#Time between incremental backup
incrbacktime=18000
#Time to sleep betwen cyrcle
sleeptime="sleep 3600"
#--------------------------------
# Static vars for cyrcles
logfilename=`hostname`_backsync.log
count=0
mytime=0
echo "script name - $0"
#
#Function Sync
dosync () {

for (( count=1; count<4; count++ ))
   do 
   #echo ${serverto[$count]}
   #Making dirs on remote server
   ssh ${serverto[$count]} mkdir -p /mnt/sync/SYNC/srv_sync/`hostname`/alliance_backarch
   echo "Rsync SAG Backups ${serverto[$count]}" | tee -a $logfile
   time rsync -lzuogthvr --compress-level=9 --delete-after  /cygdrive/m/Alliance_backarch/backup/ ${serverto[$count]}:/mnt/sync/SYNC/srv_sync/`hostname`/alliance_backarch | tee -a $logfile

  done

}

#Script Body

while a=0 ;do
# Logfile logic
mkdir -p /cygdrive/m/sync_log/`date +%A`
cd /cygdrive/m/sync_log/`date +%A`
logfile=/cygdrive/m/sync_log/`date +%A`/$logfilename
testf=`find $logfilename -ctime +5`
#testf=`find saa_sync.log -amin +1`
#echo $testf
   if [ -f "$testf" ]; then
      echo "old Logfile exist" | tee -a $logfile
           rm /cygdrive/m/sync_log/`date +%A`/$logfilename | tee -a $logfile
           echo "New Log created for `hostname` `date`" | tee -a $logfile
         elif [ -f "$logfile" ]; then
         echo "------------- Logfile exist -------------" | tee -a $logfile
         echo "New Cyrcle for `hostname` `date` " | tee -a $logfile
          else 
              echo "Start Log for `hostname` `date`" | tee -a $logfile
   fi

#Start Backups
backday=15
backpatch="m:/\Alliance_backarch/\backup/\SWP"
sagbackpatch="m:/\alliance_backarch/\backup/\SAG/\_R70"
swppath="/cygdrive/v/Alliance/WebPlatformSE/bin"
sagpath="/cygdrive/w/SWIFTAlliance/Gateway/bin"
swpbackname=/`hostname`-`date +%Y%m%d`-swp
sagbackname=`hostname`-`date +%Y%m%d`-sag
separator="=============================================================="

#echo $swpbackname

if [ -f /cygdrive/m/Alliance_backarch/backup/SWP/$swpbackname.zip ] 
   then 
        echo "Backup $swpbackname.zip file already exist" | tee -a $logfile
        elif [[ "$backday" -eq "`date +%d`" ]]
            then 
                echo "do $swpbackname backup" | tee -a $logfile
        $swppath/swp_backup.bat $backpatch$swpbackname | tee -a $logfile
        tail -n 4 "/cygdrive/m/Alliance_backarch/backup/SWP/$swpbackname"_backup.log"" | tee -a $logfile | email -s "`hostname` $swpbackname" swift@profix.kiev.ua
       else
           echo "It's not my day..." | tee -a $logfile
fi


if [ -f /cygdrive/m/Alliance_backarch/backup/SAG/_R70/$sagbackname/$sagbackname.dmp ] 
   then 
        echo "Backup $sagbackname.zip file already exist" | tee -a $logfile
        elif [[ "$backday" -eq "`date +%d`" ]]
            then 
                echo $separator | tee -a $logfile
                echo "do $sagbackname backup" | tee -a $logfile
        $sagpath/sag_system.bat -- backup $sagbackpatch/$sagbackname/$sagbackname | tee -a $logfile 
        tail -n 4 "/cygdrive/m/Alliance_backarch/backup/SAG/_R70/$sagbackname/$sagbackname".exp.log"" | tee -a $logfile | email -s "`hostname` $sagbackname" swift@profix.kiev.ua
       else
           echo "It's not my day..." | tee -a $logfile
fi


# Daily Backup
mkdir -p /cygdrive/m/Alliance_backarch/backup/SAG/daily
cd /cygdrive/m/Alliance_backarch/backup/SAG/daily
#testf=`find $pattern -ctime +5`
pattern_dmp=`hostname`*daily.dmp
sagdaily=`hostname`_`date +%Y%m%d`_daily
dailybackpatch="m:/\alliance_backarch/\backup/\SAG/\daily"
#newdump=/cygdrive/m/Alliance_backarch/backup/SAG/daily/`find -iname $pattern_dmp -amin +1`
newdump=/cygdrive/m/Alliance_backarch/backup/SAG/daily/`hostname`_`date +%Y%m%d`_daily.dmp
olddump=/cygdrive/m/Alliance_backarch/backup/SAG/daily/`find -iname $pattern_dmp -ctime 6`
oldlog=/cygdrive/m/Alliance_backarch/backup/SAG/daily/`find -ctime 6 -regextype posix-egrep -regex '.*(.exp.log)$'`

#echo $oldlog

if [ -f $olddump ] 
   then 
        echo "Backup $olddump OLD file exist" | tee -a $logfile
        rm -v $olddump | tee -a $logfile
        rm -v $oldlog | tee -a $logfile

        elif [ -f $newdump ]
            then 
                echo "Backup $newdump file exist" | tee -a $logfile
       else
        $sagpath/sag_system.bat -- backup $dailybackpatch/$sagdaily | tee -a $logfile 
        tail -n 4 "/cygdrive/m/Alliance_backarch/backup/SAG/daily/`hostname`_`date +%Y%m%d`_daily.exp.log" | tee -a $logfile | email -s "`hostname` $sagdaily" swift@profix.kiev.ua
fi


#Backup Sync
fulltime=`date +%s`
let dotime=$fulltime-$mytime
let backupdate=`date +%H` # time for SAA Backups do nothing
#echo $dotime
        if [ "$backupdate" -le "1" ]; then 
              echo "$backupdate - time for - sleep" | tee -a $logfile
	         elif [ "$mytime" -eq "0" ];then
	            echo do Sync - this is first run | tee -a $logfile
                    mytime=`date +%s`
                    ttnb=$incrbacktime
                dosync #sync now
                        elif [ "$dotime" -ge "$incrbacktime" ]; then
                	   echo do Sync - after $incrbacktime sec | tee -a $logfile
                           mytime=`date +%s`
                           #echo $mytime
                dosync #sync now
        
         else
          let ttnb=$incrbacktime-$dotime
          
        fi


echo ----------- circle time  `date +%H:%M:%S`  ------------- | tee -a $logfile
#echo "last RD-Log count is: $count" | tee -a $logfile
echo "time to next sync: $ttnb sec" | tee -a $logfile

  $sleeptime
done
