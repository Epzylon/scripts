#!/bin/sh 
REPORT_FOLDER=/tmp/diskreport;
DISK_FILE=$REPORT_FOLDER/disks;
DISK_SIZES=$REPORT_FOLDER/disks-sizes;
HOSTNAME=`hostname`;

#Make the report folder if it doesn't exists
if [ ! -d $REPORT_FOLDER ];
then
   mkdir -p $REPORT_FOLDER;
fi 
     
# Ugly line! please change to only one awk
ioscan -nfkC disk 2>/dev/null | grep dsk | awk '{ print $1 }' |awk -F '/' '{ print $4 }'  | cut -ds -f1 | uniq > $DISK_FILE;

for i in `cat $DISK_FILE`; do sudo diskinfo /dev/rdsk/$i 2>/dev/null| awk '  $1 == "size:" { print $2/1024/1024 }'; done > $DISK_SIZES;


TOTAL_SIZE=`awk ' { sum += $1 } END { print sum } ' $DISK_SIZES`;

echo $HOSTNAME";"$TOTAL_SIZE
