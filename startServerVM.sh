#!/bin/bash
# John Doll, cse470g, Assignment 9/16

# given function
is_int()  { case ${1#[-+]} in '' | *[!0-9]*              ) return 1;; esac ;}
if ! is_int $1;
then
	    echo "Must be an integer argument 0->9"
	        exit
fi

# check to make sure valid input
if ! is_int $1; 
then
	echo "Must enter integer between 0 and 9"
	exit
fi
if [[ "$1" -lt 0 || "$1" -gt 9 ]]; then
	echo "Must enter integer between 0 and 9"
	exit
fi

# get server name
serverName="server$1"

# destroy and undefine servers with same name
virsh destroy ${serverName}
virsh undefine ${serverName}

# create server
qemu-img create -f qcow2 -b /qemu/server.qcow2 $serverName.qcow2
virt-install \
	--name $serverName \
	--memory 2048 \
	--vcpus 2 \
	--disk $serverName.qcow2 \
	--import \
	--os-variant ubuntu20.04 \
	--graphics none \
	--noautoconsole

sleep 10

# create port varialbe
port=808$1

# get ip table entries to loop through
ipTablesEntries=$(sudo iptables -t nat -L PREROUTING | grep "${port}")

# remove all previous ip tables entries for host port
while read line
do
	ip=$(echo $line | tr -s ' ' | cut -d " " -f 8 | cut -c 4-)
	echo $ip
	sudo iptables -t nat -D PREROUTING -p tcp --dport $port -j DNAT --to ${ip}
done <<< ${ipTablesEntries}

#get domain id
ID=`virsh list | grep ${serverName} | tr -s ' ' | cut -d ' ' -f 2`
#Now dump the xml config file for the new vm and extract the MAC address
MAC=`virsh dumpxml ${ID} | xpath -q -e "string(//@address)"`
#Now we can truly find the IP address for the new vm
IP=`virsh net-dhcp-leases default| grep "${MAC}" | tr -s ' ' | cut -d ' ' -f 6 | sed s'/\/.*//'`

# create port forwarding rule
sudo iptables -t nat -I PREROUTING -p tcp --dport ${port} -j DNAT --to ${IP}:80

# remove accept all forwarding rules
while [ $? -eq 0 ]
do
	sudo iptables -D FORWARD -j ACCEPT
done 

# create one forwarding accept rule
sudo iptables -I FORWARD -j ACCEPT

# get date
DATE=$(date)

# create index.html file
echo "This is a new server running on IP ${IP}<br>Server is created at ${DATE}<br>Server created by dolljm<br>Server Name is ${serverName}" > index.html 

# send file to virtual machine and move to directory
ssh devops@${IP} sudo rm -r /var/www/html/*
scp index.html devops@${IP}:/home/devops
ssh devops@${IP} sudo mv index.html /var/www/html/

# echo name, ip, and prot
echo ${serverName}
echo ${IP}
echo ${port}
