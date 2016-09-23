#!/bin/bash

[[ -z $1 ]] && echo "You must provide a network!" && exit 1

FP=$(which fping)
ARP=$(which arp)
MACFILE="/usr/share/nmap/nmap-mac-prefixes"
TMPFILE="/tmp/mac-ip"


# Lets fill the arp cache
echo "Scanning..."
$FP -ag $1 2>/dev/null 1>&2
$ARP -n | grep -v "incomplete" | awk '!/Address/ { print $1,$3 }' > $TMPFILE 

for mac in $(cat $TMPFILE| awk '{print $2}');
do
	macprefix=$(echo $mac | awk -F: '{print $1$2$3}')
	vendor=$(grep -i $macprefix $MACFILE)
	ip=$(grep $mac $TMPFILE)
	echo $ip "  " $vendor
done
