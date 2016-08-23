#!/bin/bash
IP=$(which ip)
FPING=$(which fping)
NET_LIST=$($IP -4 -o addr ls | awk '!/127.0.0.1/ { print $4 }')
FPING_COMMAND="$FPING -ag"

#NULL_OUTPUT="2>/dev/null"
if [[ $1 == "-v" ]];
then
	VER="yes"
else
	VER="no"
fi
echo $NULL_OUTPUT

#Lets search for conneced interfaces
for net in $NET_LIST;
do
	if [[ $VER == "yes" ]];
	then
			echo "IPs on Network $net:"
			$FPING_COMMAND $net
	else
			$FPING_COMMAND $net 2>/dev/null
	fi
done
