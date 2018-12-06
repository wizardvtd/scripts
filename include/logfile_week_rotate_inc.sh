# Logfile logic include
# $log_file_name can be defined in main script
#
# Usage:
# log_file_name=file.log
# source ~/bin/inc/logfile_week_rotate_inc.sh
#



mkdir -p /cygdrive/m/sync_log/`date +%A`
cd /cygdrive/m/sync_log/`date +%A`
logfile=/cygdrive/m/sync_log/`date +%A`/$log_file_name
testf=`find $log_file_name -ctime +5`
#testf=`find saa_sync.log -amin +1`
#echo $testf
   if [ -f "$testf" ]; then
      echo "old Logfile exist $log_file_name" | tee -a $logfile
           rm /cygdrive/m/sync_log/`date +%A`/$log_file_name | tee -a $logfile
           echo "new log created for `hostname` `date` scriptname: $0 " | tee -a $logfile
         elif [ -f "$logfile" ]; then
         echo "------------- Logfile exist -------------" #| tee -a $logfile
         echo "New cyrcle for `hostname` `date` scriptname: $0 " #| tee -a $logfile
          else 
              echo "start log for `hostname` `date` scriptname: $0 " | tee -a $logfile
   fi
