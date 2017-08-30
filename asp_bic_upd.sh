# by Zhirakhivskyi Ihor aka Wizard
#-----------------------------------------------------
# Script for ASP Uptate file syncronisation
#-----------------------------------------------------
# StauSes:
# work - script is running
# error - file exist in error dir
# update - have file for update
# newfile - backup dir not contained the backup files
statusfile=/cygdrive/m/asp_bic_upd.status
time_now=`date +%Y_%m_%d_%H_%M_%S`

#dirs
remoteupdatedir=/\/\192.168.1.1/\storage/\SWIFT_BICs/\ASP
BackupDirLocal=/cygdrive/m/saa_conf/update/back
UpdateDirLocal=/cygdrive/m/saa_conf/update
ErrorDirLocal=/cygdrive/m/saa_conf/update/error

# script Body
# If file in Error dir - Alarm!

cd $ErrorDirLocal
 for errfile in `ls`
   do 
     if [ -s $ErrorDirLocal/$errfile ]
        then 
           echo "ASP file load error!!! $errfile"
           echo "error $time_now" > $statusfile
exit
     fi
 done
# If file in Update dir - check diff, if not identical -> copying again
cd $UpdateDirLocal
 for ufile in `ls`
   do 
     if [ -s $UpdateDirLocal/$ufile ]
        then 
           echo "ASP file exist for load $ufile"
           #diff -s $remoteupdatedir/$ufile $UpdateDirLocal/$ufile
           	if diff $remoteupdatedir/$ufile $UpdateDirLocal/$ufile
	           then echo "files are identical"
	        else
                      cp $remoteupdatedir/$ufile $UpdateDirLocal/$ufile
                      echo "update $time_now" > $statusfile
        fi

exit
     fi
 done
# How many ASP files
cd $remoteupdatedir
   for numrem in `ls | wc -l`
    do
     echo $numrem remote ASP files
    massrem=(`ls --sort=time`)
   done
cd $BackupDirLocal
    for numloc in `ls | wc -l`
    do
    echo $numloc local ASP files
    done  
   

  if [ "$numloc" == "0" ] 
      then 
	      declare num=1 
	elif [ "$numloc" -le "$numrem" ]
	    then
	      declare num=$numloc
           else 
              declare num=$numrem
	fi
echo $num - checked files

#exit
    massloc=(`ls --sort=time | awk -F. '{print $1"."$2}'`)

	for (( count=0; count<$num; count++ ))
	do
		if [ ${massrem[$count]} = ${massloc[$count]} ]
		then
                    echo "ASP file alredy loaded ${massrem[$count]}"
                    echo "work $time_now" > $statusfile

		else 
#		echo is not equal ${massrem[$count]}
                         echo "ASP the New file exist ${massrem[$count]}"
                         cp -v $remoteupdatedir/${massrem[$count]} $UpdateDirLocal
                         diff -s $remoteupdatedir/${massrem[$count]} $UpdateDirLocal/$rfile

	fi

 
	done



