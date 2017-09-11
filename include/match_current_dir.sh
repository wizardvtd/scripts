#!/bin/bash

# Script for check directory before operations (is exist, is dir, and is mach to needed dir)

# Usage:
# 
# source /scripts/include/match_current_dir.sh
# matchdir="$Dir for Work"
# match_dir ()

match_dir () {
realdir=`pwd`
echo $realdir
echo $matchdir
    if [[ -z $matchdir ]];then 
           echo "Dirictory for compare not exist, set Dir in variable matchdir"
        exit
    elif ! [ -d $matcdir ];then 
       echo "Dir is not exist $matchdir"
        exit
	elif [[ "$realdir" ==  "$matchdir" ]];then 
	       echo "Dir is good $realdir"

    	    else
		echo "Dir is not matched!!! Exit"
		exit
    fi
}

#matchdir="/libs/scripts/include"
#match_dir

