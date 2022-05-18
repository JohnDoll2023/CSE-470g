#!/bin/bash
#John Doll, cse470g, scripting #1

ips=();
echo -e "IP \t num2xx \t num3xx \t num4xx \t num5xx" 
while read line
do 
	ip=$(echo $line | tr -s ' ' | cut -d " " -f 1)
	if [[ " ${ips[*]} "  =~ " ${ip} " ]]; then
		continue;
	fi
	ips+=($ip)
	code200=0
        code300=0
        code400=0
        code500=0
	allMatches=$(cat /var/log/apache2/access.log | tr -s ' ' | grep "${ip}")
	while IFS= read -r duplicate
	do
		status_code=$(echo $duplicate | tr -s ' ' | cut -d '"' -f 3 | cut -d ' ' -f 2)
		if [[ ${status_code::1} = "2" ]]; then
			code200=$((code200+1))
		elif [[ ${status_code::1} = "3" ]]; then
                        code300=$((code300+1))
                elif [[ ${status_code::1} = "4" ]]; then
                        code400=$((code400+1))
                elif [[ ${status_code::1} = "5" ]]; then
                        code500=$((code500+1))
		fi
	done <<< ${allMatches}
	echo -e "${ip} \t ${code200} \t ${code300} \t ${code400} \t ${code500}"
done < /var/log/apache2/access.log
