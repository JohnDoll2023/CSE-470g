#!/bin/bash
#John Doll, cse470g, script 2

paths=();
while read line
do
	path=$(echo $line | tr -s ' ' | cut -d '"' -f 2 | cut -d ' ' -f 2)
	if [[ " ${paths[*]} " =~ " ${path} " ]]; then
		continue;
	elif [[ "$path" == *\\* ]]; then
		continue;
	elif [[ ${#path} = 0 ]]; then
		continue;
	fi
	paths+=($path)
	ips=();
	echo "$path"
	allMatches=$(cat /var/log/apache2/access.log | tr -s ' ' | grep "\b $path \b")	
	while IFS= read -r rowMatches
	do
		ip=$(echo $rowMatches | tr -s ' ' | cut -d " " -f 1)
		if [[ " ${ips[*]} "  =~ " ${ip} " ]]; then
               		continue;
        	fi
		echo "$ip"
		ips+=($ip)
	done <<< ${allMatches}
        echo ""
		
done < /var/log/apache2/access.log
