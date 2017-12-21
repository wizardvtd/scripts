#!/bin/bash

date=`date +%H:%M`

# Variables for script
#--------------------------------
#Server(s) to sync or copy
serverto=( [1]="user@server1" [2]="user@server2" [3]="user@server3" )
#echo ${serverto[@]}

# Logfile logic
mkdir -p /cygdrive/m/sync_log/`date +%A`
cd /cygdrive/m/sync_log/`date +%A`
blogfile=/cygdrive/m/sync_log/`date +%A`/saa_backups.log
testf=`find saa_backups.log -ctime +5`
#testf=`find saa_sync.log -amin +1`
#echo $testf
   if [ -f "$testf" ]; then
      echo "old Logfile exist" | tee -a $blogfile
           rm /cygdrive/m/sync_log/`date +%A`/saa_sync.log | tee -a $blogfile
           echo "new backup log created for `hostname` `date`" | tee -a $blogfile
         elif [ -f "$blogfile" ]; then
         echo "------------- Logfile exist -------------" | tee -a $blogfile
         echo "start backup cyrcle for `hostname` `date` " | tee -a $blogfile
          else 
              echo "start backup log for `hostname` `date`" | tee -a $blogfile
   fi

# Start MFA backup module
       cd /cygdrive/m/alliance_backarch/backup/mfa/
        for dirs in `ls`
                do
                  # zipping dirs if zip file not exist
                  if [ -d $dirs ] && [ "$dirs" != "Restored" ] && ! [ -f $dirs".7z" ];then
                          7z a -r -mx=9 -m0=lzma2 $dirs".7z" $dirs/* | tee -a $blogfile
                  fi        
    # sending to log info about zip files for all zipped dirs 
                        if [ -d $dirs ] && [ "$dirs" != "Restored" ] && [ -f $dirs".7z" ];then
                               echo "zip file for $dirs exist" | tee -a $blogfile
     # Deleting dirs older than 91 day if zips created for him
                                 for del_dir in `find $dirs -mtime +91 -type d -prune`; do
                                     rm -v -r --one-file-system $del_dir | tee -a $blogfile
                                 done
                        fi
        done             


       #Test 7z archives
                         for zips in `ls MEAR*.7z`;do
                              test_arch=`7z t $zips |gawk '/Ok/ {print $0}'` #  grep Ok
                               if [ "$test_arch" == "Everything is Ok" ];then
                                   echo $zips $test_arch | tee -a $blogfile
                                       else
                                         echo $zips $test_arch err | tee -a $blogfile
                                         exit_status_crc="$zips on `hostname` are damaged"
                               fi
                         done




# Compare cyrcle - check if zip file exist on all remote servers
lpath=/cygdrive/m/alliance_backarch/backup/mfa
rpath=/mnt/melony/Melony/alliance_backarch/backup/mfa_`hostname`_zip 

enable_delete=0 # var for enable deletions
check_flag=0 # var for enable deletions

  for rserv in ${serverto[@]};do

               for zips in `ls MEAR*.7z`;do

                      #echo $zips
                    compare=`rsync -e ssh -lzuhrni --compress-level=0 --size-only --delete-after $lpath/$zips $rserv:$rpath/$zips`
                           if [ -z "$compare" ];then
                                echo "file $zips is exist on destination $rserv" | tee -a $blogfile

                                 else
                                  echo "We have diferens between $compare on $rserv, try to sync" | tee -a $blogfile
                                 rsync -e ssh -lzupogthvri --compress-level=0 --delete-after $lpath/$zips $rserv:$rpath/$zips | tee -a $blogfile
                               (( check_flag++ ))
                           fi
# Cyrcle for compare agan after sync
         if [ "$check_flag" != "0" ];then
         let check_flag=0
         # try to compare agan
                    compare=`rsync -e ssh -lzuhrni --compress-level=0 --size-only --delete-after $lpath/$zips $rserv:$rpath/$zips`
                           if [ -z "$compare" ];then
                                echo "file $zips is exist on destination $rserv" | tee -a $blogfile
                           else
                           (( enable_delete++ ))
                           echo "Warning! Can't sync $enable_delete times" | tee -a $blogfile
                            echo ----------- error time `date +%H:%M:%S`  ------------- | tee -a $blogfile
                             exit_status_sync="$zips sync Error on `hostname`"
                           fi

         fi
               done
  done

                               

         if [ "$enable_delete" -eq "0" ];then
         # Deleting zip files older than 91 day if these files exist on remote servers
                                 for del_zip in `find MEAR*.7z -mtime +91`; do
                                     #echo $del_zip - marked for del
                                    rm -v -r --one-file-system $del_zip | tee -a $blogfile
                               
                                 done
                     exit_status="0; all is ok on `hostname`"
                else
                echo "Warning! not all files on all remote servers Deletions is disabled" | tee -a $blogfile
         fi

echo ----------- end circle time  `date +%H:%M:%S`  ------------- | tee -a $blogfile

# Alarm file for nagios generation
if [ ! -z "$exit_status_crc" ] || [ ! -z "$exit_status_sync" ];then
         exit_status="2; $exit_status_crc, $exit_status_sync"
   echo $exit_status | tee -a $blogfile
   echo $exit_status > /cygdrive/m/sync_log/nag_backup_status.log
  else 
     echo $exit_status | tee -a $blogfile
     echo "$exit_status" > /cygdrive/m/sync_log/nag_backup_status.log | tee -a $blogfile

fi

