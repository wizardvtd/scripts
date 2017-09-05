#!/bin/bash

# Скрипт для копирования RGE формата в другую директорию с лимитами по валюте/сумме по полю 32A
# указываются "2:I103\|2:I202" типы МТ,  суммы без ,00
# 
# описание:
# вписываем лимиты в массив limit=([USD]=50000 [EUR]=50000 [GBP]=50000) имя валюты, лимит
# в цикл if [[ $val -eq "USD" || $val -eq "EUR" || $val -eq "GBP" || $val -eq "CZK" ]] имя валюты
# при проверке лимит по сумме вызываем ${limit[$val]
#
# суть работы:
# если валюта совпала с условием if проверится лимит по имени валюты из массива копируется в указанный каталог.


#for del
odbdrive=y
driveto=y
#

FromODB=/cygdrive/$odbdrive/FromODB/
AuthMsg=/cygdrive/$driveto/temp/batch/AuthMsg/
cd $FromODB


limits () {
    field32=`gawk ' BEGIN {FS=":"} /':32A:'/ { print $3 } ' < $file`
    echo $field32 #>> aaa.txt
    val=`expr substr $field32 7 3`
    ssum=`expr substr $field32 10 10 | awk 'BEGIN {FS=","}  {print $1}' `
#echo $val
#echo $ssum

    limit=([USD]=50000 [EUR]=50000 [GBP]=50000)

	if [[ $val -eq "USD" || $val -eq "EUR" || $val -eq "GBP" || $val -eq "CZK" ]]
	    then 
	    echo $val $ssum 
	    echo ${limit[$val]}
		    if [ $ssum -le  ${limit[$val]} ]
		       then 
			   echo  $ssum  ${limit[$val]} 
                           cp $file $AuthMsg | tee -a $logile
		    fi
	else
	echo "Валюты нет в списке"
	fi
}


       for file in *; do
# Find 103xx 202xx MT                   
                grep "2:I103\|2:I202" $file

            if [ $? -eq 0 ]; then

limits
#                cp $file $AuthMsg | tee -a $logile
            fi
done

#      for file in *; do
# Find 103 MT                   
#                grep "2:I103" $file
#
#            if [ $? -eq 0 ]; then
#
#limits
#                cp $file $AuthMsg | tee -a $logile
#            fi
#done
