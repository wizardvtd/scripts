#!/bin/bash

date=`date +%H:%M`

# Variables for script
#--------------------------------
#Server(s) to sync or copy
serverto=( [1]="backup@sync.253.int" [2]="backup@sync2.253.int" [3]="backup@vcsinus.waw253.int" )
#echo ${serverto[@]}

logfname=saa_backups_full.log

# Logfile logic
function logging {


   mkdir -p /cygdrive/m/sync_log/`date +%A`
   cd /cygdrive/m/sync_log/`date +%A`
    blogfile=/cygdrive/m/sync_log/`date +%A`/$logfname
   testf=`find $logfname -ctime +5`
 #testf=`find saa_sync.log -amin +1`
 #echo $testf
   if [ -f "$testf" ]; then
      echo "old Logfile exist" | tee -a $blogfile
           rm $blogfile | tee -a $blogfile
           echo "new backup log created for `hostname` `date`" | tee -a $blogfile
         elif [ -f "$blogfile" ]; then
         echo "------------- Logfile exist -------------" | tee -a $blogfile
         echo "start backup cyrcle for `hostname` `date` " | tee -a $blogfile
          else 
              echo "start backup log for `hostname` `date`" | tee -a $blogfile
   fi

}


function ZipDelBackupDirs {
# Start MFA backup module
#       cd /cygdrive/m/alliance_backarch/backup/mfa/
        for dirs in `ls`
                do
                  # zipping dirs if zip file not exist
                  if [ -d $dirs ] && [ "$dirs" != "Restored" ] && ! [ -f $dirs".7z" ];then
echo zipping $dirs | tee -a $blogfile
                          7z a -r -mx=9 -ppassword -m0=lzma2 $dirs".7z" $dirs/* | tee -a $blogfile
                  fi        
    # sending to log info about zip files for all zipped dirs 
                        if [ -d $dirs ] && [ "$dirs" != "Restored" ] && [ -f $dirs".7z" ];then
                               echo "zip file for $dirs exist" | tee -a $blogfile
     # Deleting dirs older than 91 day if zips created for him
                                 for del_dir in `find $dirs -mtime +$DelPer -type d -prune`; do
                                     rm -v -r --one-file-system $del_dir | tee -a $blogfile
                                      echo Dir to del $del_dir
                                 done
                        fi
        done             

                            #Test 7z archives
                         for zips in `ls $Prefix*.7z`;do
                              test_arch=`7z t -ppassword $zips |gawk '/Ok/ {print $0}'` #  grep Ok
                               if [ "$test_arch" == "Everything is Ok" ];then
                                   echo $zips $test_arch | tee -a $blogfile
                                       else
                                         echo $zips $test_arch err | tee -a $blogfile
                                         exit_status_crc="$zips on `hostname` are damaged"
                               fi
                         done
}

function RsyncCompareBackup {

# Compare cyrcle - check if zip file exist on all remote servers
#lpath=/cygdrive/m/alliance_backarch/backup/mfa
#rpath=/mnt/melony/Melony/alliance_backarch/backup/mfa_`hostname`_zip 

enable_delete=0 # var for enable deletions
check_flag=0 # var for enable deletions

  for rserv in ${serverto[@]};do

               for zips in `ls $Prefix*.7z`;do

                      #echo $zips
                    compare=`rsync -e ssh -lzuhrni --compress-level=0 --size-only --delete-after $lpath/$zips $rserv:$rpath/$zips`
                           if [ -z "$compare" ];then
                                echo "file $zips is exist on destination $rserv" | tee -a $blogfile

                                 else
                                  echo "We have diferens between $compare on $rserv, try to sync" | tee -a $blogfile
                                 rsync -e ssh -lzupogthvri --compress-level=0 --delete-after $lpath/$zips $rserv:$rpath/$zips | tee -a $blogfile
                               (( check_flag++ ))
#                           fi
# Cyrcle for compare agan after sync
         if [ "$check_flag" != "0" ];then
         let check_flag=0
         # try to compare agan
                    compare=`rsync -e ssh -lzuhrni --compress-level=0 --size-only --delete-after $lpath/$zips $rserv:$rpath/$zips`
                           if [ -z "$compare" ];then
                                echo "file $zips is exist on destination $rserv" | tee -a $blogfile
                                echo "-------------- check again result after sync ----------------" | tee -a $blogfile
                           else
                           (( enable_delete++ ))
                           echo "Warning! Can't sync $enable_delete times" | tee -a $blogfile
                            echo ----------- error time `date +%H:%M:%S`  ------------- | tee -a $blogfile
                             exit_status_sync="$zips sync Error on `hostname`"
                           fi
                           fi
                           fi
               done
  done

}

logging

  cd /cygdrive/m/alliance_backarch/backup/
        for bdirs in mfa eja db
                 do
            cd /cygdrive/m/alliance_backarch/backup/$bdirs 
            echo "Working dir is: `pwd`"  | tee -a $blogfile
               if [ "$bdirs" == "mfa" ];then
               Prefix=MEAR
               DelPer="+91"
               lpath=/cygdrive/m/alliance_backarch/backup/$bdirs
               rpath=/mnt/melony/Melony/alliance_backarch/backup/"$bdirs"_`hostname`_zip 

                  elif [ "$bdirs" == "eja" ];then
                 Prefix=JRAR
                 DelPer="+6"
                 lpath=/cygdrive/m/alliance_backarch/backup/$bdirs
                 rpath=/mnt/melony/Melony/alliance_backarch/backup/"$bdirs"_`hostname`_zip 

                     elif [ "$bdirs" == "db" ];then
                    Prefix=*SAA_DATA
                    DelPer="+6"
               lpath=/cygdrive/m/alliance_backarch/backup/$bdirs
               rpath=/mnt/sync/SYNC/srv_sync/DB_Backup/"$bdirs"_`hostname`_zip

               fi
           echo "-- Params is: --" | tee -a $blogfile
           echo "the arc prefix is: $Prefix, the delete period is: $DelPer" | tee -a $blogfile
           echo "Local patch: $lpath" | tee -a $blogfile
           echo "Remote patch: $rpath" | tee -a $blogfile

echo -- Zipping Cyrcle -- | tee -a $blogfile
ZipDelBackupDirs
echo ---- Rsync Cyrcle ---- | tee -a $blogfile
RsyncCompareBackup
echo " -- Deletion Status is $enable_delete, Enable - 0, if no - Error -- " | tee -a $blogfile
# status file
bstatusfile=/cygdrive/m/sync_log/"$bdirs"_bstatus.stat


         if [ "$enable_delete" -eq "0" ];then
         # Deleting zip files older than $DelPer day if these files exist on remote servers
                                 for del_zip in `find $Prefix*.7z -mtime $DelPer`; do
                                     echo $del_zip - marked for del | tee -a $blogfile
                                     rm -v -r --one-file-system $del_zip | tee -a $blogfile
                               
                                 done
                     exit_status="0; $bdirs; all is ok on `hostname`" 
                     echo $exit_status > $bstatusfile
                else
                echo "Warning! not all files on all remote servers Deletions is disabled" | tee -a $blogfile
                     exit_status="2; $bdirs; $exit_status_crc, $exit_status_sync" 
                echo $exit_status > $bstatusfile
         fi

        done

            

echo "----------- end circle time  `date +%H:%M:%S`  -------------" | tee -a $blogfile
