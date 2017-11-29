#!/bin/bash

logfile=/var/log/scripts/sha256_check.log
nagfile=/var/log/scripts/src_log_nagios.log

if [ -f $logfile ];then
        mv -v $logfile /var/log/scripts/sha256_check_old.log
        fi

server=`hostname`

cd /mnt/melony/Melony/alliance_backarch/backup
pwd
 for back_dir in `ls`
     do
        if [ -d /mnt/melony/Melony/alliance_backarch/backup/$back_dir ]; then
    cd /mnt/melony/Melony/alliance_backarch/backup/$back_dir
    echo `date +%Y/%m/%d:%T` | tee -a $logfile
    pwd | tee -a $logfile

#    echo $back_dir
            for back_file in `ls *.*z* | grep -v sha256`
                do
                  check_file=/mnt/melony/Melony/alliance_backarch/backup/$back_dir/$back_file.sha256
                   if [ -f  $check_file ];then
                       sha256sum -c $check_file | tee -a $logfile
                      else 
               echo New files added $back_dir $back_file `date +%Y/%m/%d:%T` | tee -a $logfile
               sha256sum -b $back_file | tee -a $check_file
                   fi 
            done
        else
          echo $back_dir is a file
        fi
 done

echo "------- Report `date +%Y/%m/%d:%T` --------" | tee -a $logfile

cat $logfile | grep FAILED | tee -a $logfile
cat $logfile | grep WARNING | tee -a $logfile
cat $logfile | grep added | tee -a $logfile

    for err in `cat $logfile | awk -F":" '/FAILED/ {n++};END{print n/2}'` #{n++};END{print n+0}
        do

    if [ "$err" -eq "0" ];then
            echo "0; src on $server is OK" > $nagfile
           else
                echo "2; Bad src for $err files on $server" > $nagfile
        fi
    done
