#!/bin/sh
# John Doll, cse470g, openstack script

openstack server create --image focal --flavor class --network provider --key-name dolljm-ceclnx01  dolljm-s2 --user-data cloudInitScript.sh

ip=""

while [$ip == ""]
do
	serverState=$(openstack server list | grep dolljm-s2 | tr -s ' ' | cut -d "|" -f 4)
	if [ $serverState != "BUILD" ]; then
		ip=$(openstack server list | tr -s ' ' | grep dolljm-s2 | cut -d "|" -f 5 | cut -d "=" -f 2)
		break
	fi
	sleep 3
done
echo "$ip dolljm-s2@devops.csi.miamioh.edu"
