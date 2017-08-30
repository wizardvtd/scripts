timepair=`date +%Y_%m_%d`
time_now=`date +%Y_%m_%d_%H_%M_%S`
logfile=passwd_upd_db.log #Log file
cd /usr/local/bin
pwd | tee -a $logfile
login=$(awk '/open/ {print $2}' < "sigma_script" )

WinScp.com /command "open $login" "get -nopreservetime -transfer=binary /Transit/*.pwd" "exit" | tee -a $logfile
# Test if file exits and received
if [ -f *.pwd ]
	then echo 'pwd file exist' |tee -a $logfile
	pwdfile=`ls *.pwd`
	echo "====== > Received password file $pwdfile" | tee -a $logfile
	bic4=`expr substr $pwdfile 1 4`
	echo "====== > Start renew password for user $bic4 " | tee -a $logfile
	oldpasswd=$(expr substr $login 13 20)
#echo $oldpasswd
	newpasswd=`gawk 'BEGIN {FS=";"}{print $2}' $pwdfile`
#echo $newpasswd
	   if [ -f "$bic4".req ]
	      then
	      echo "$bic4".req exist, so password already changed | tee -a $logfile
	      else
                cp sigma_script sigma_script.$time_now
		sed s/$oldpasswd/$newpasswd/g sigma_script.$time_now > sigma_script

		echo "$bic4 password renewed at $time_now" |tee -a $bic4.req
		WinScp.com /command "open $login" "put -transfer=binary $bic4.req /Transit/$bic4.req" "exit" | tee -a $logfile
		echo "===== > Waiting when the server change password" | tee -a $logfile

	   fi

  while test=1
do
	if [ ! -s "$bic4.res" ]; then 
	sleep 5
        loginnew=$( awk '/open/ {print $2}' < "sigma_script" )
        echo $loginnew
	WinScp.com /command "open $loginnew" "get -nopreservetime -transfer=binary /Transit/$bic4.res" "exit" | tee -a $logfile
		else	
	echo "===>"
	cat $bic4.res | tee -a $logfile
	mv $bic4.pwd $bic4.pwd.$time_now
	mv $bic4.req $bic4.req.$time_now
	mv $bic4.res $bic4.res.$time_now
	break
	fi
done
		else echo 'pwd file is not exist'; exit
  fi
