#/bin/bash
timepair=`date +%Y:%m:%d`
#logfile=/var/log/scripts/ftps_passwd.log
logfile=/root/scripts/pwd/update_ftps_passwd.log

for bic4 in `mysql -B -N -u user -pPassworD vsftpd -Be  "SELECT username FROM accounts"`
do 
echo $bic4

#mysql -B -N -u user -pPassworD vsftpd -Be "SELECT TIMESTAMPDIFF(MONTH,NOW(),(SELECT datepass FROM accounts WHERE username='$bic4'))"
if [ `mysql -B -N -u user -pPassworD vsftpd -Be "SELECT TIMESTAMPDIFF(MONTH,NOW(),(SELECT datepass FROM accounts WHERE username='$bic4'))"` -le "-13" ]
#if [ $bic4=sbxa ]
then 

    if [ -e /root/scripts/pwd/tmp_pwd/$bic4.pwd ]
    then
    echo password file for $bic4 exist 


         if [ -e /mnt/leora/ftps_dirs/$bic4/Transit/$bic4.req ]
          then
          echo $bic4 req received | tee -a $logfile
pass=$( awk -F";" '{print $2}' < /root/scripts/pwd/tmp_pwd/$bic4.pwd )
#echo $pass
mysql -B -N -u user -pPassworD vsftpd -Be "UPDATE accounts SET pass=PASSWORD( '$pass' ),datepass=CURRENT_TIMESTAMP WHERE username = '$bic4'"
echo "password $bic4 cnanged? check date!" | tee -a $logfile > /mnt/leora/ftps_dirs/$bic4/Transit/$bic4.res
mysql -B -N -u user -pPassworD vsftpd -Be "SELECT datepass FROM accounts WHERE username='$bic4'" | tee -a $logfile >> /mnt/leora/ftps_dirs/$bic4/Transit/$bic4.res
mv /mnt/leora/ftps_dirs/$bic4/Transit/$bic4.pwd /mnt/leora/ftps_dirs/$bic4/Transit/$bic4.pwd.$timepair
mv /mnt/leora/ftps_dirs/$bic4/Transit/$bic4.req /mnt/leora/ftps_dirs/$bic4/Transit/$bic4.req.$timepair
mv /root/scripts/pwd/tmp_pwd/$bic4.pwd /root/scripts/pwd/tmp_pwd/$bic4.pwd.$timepair
#exit
      else
      echo $bic4 req not received | tee -a $logfile
         fi
    else
pass=`pwgen -c -n -B -s -1 20 1`
echo "$bic4;$pass" >> /root/scripts/pwd/tmp_pwd/$bic4.pwd
      if [ ! -e /mnt/leora/ftps_dirs/$bic4/Transit/$bic4.pwd ]
        then
           cp -v /root/scripts/pwd/tmp_pwd/$bic4.pwd /mnt/leora/ftps_dirs/$bic4/Transit/$bic4.pwd
        else
        echo pwd file for $bic4 exist
      fi

echo New pass generated | tee -a $logfile

    fi


fi

done

