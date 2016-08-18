#!/bin/ksh 
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
iostat -Ee | awk ' $1 == "Size:" { print $2 }' | cut -dG -f1 > $DISK_SIZES;

if [ ! -s $DISK_SIZES ];
then
    iostat -Ee | awk ' $5 == "Size:" { print $6 }' | cut -dG -f1 >$DISK_SIZES;
fi
 
for size in `cat $DISK_SIZES`;
do
BCLINE=$BCLINE$size"+";
done

BCLINE=`echo ${BCLINE%?}`
TOTAL_SIZE=`echo $BCLINE | bc`;

echo $HOSTNAME";"$TOTAL_SIZE
