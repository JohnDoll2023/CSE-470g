#!/bin/bash
#John Doll, cse470g, script3

while read line
do
	status_code=$(echo $line | tr -s ' ' | cut -d '"' -f 3 | cut -d ' ' -f 2)
	if [[ ${status_code} = "404" ]]; then
	       	echo $(echo $line | tr -s ' ' | cut -d " " -f 7) 	
	fi
done < /var/log/apache2/access.log
