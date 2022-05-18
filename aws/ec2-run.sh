#!/bin/bash
#! John Doll, cse470, aws instance script

aws ec2 run-instances --image-id ami-09e67e426f25ce0d7 --count 1 --instance-type t2.micro --key-name dolljm-ceclnx01 --security-group-ids default --user-data file://ec2-script1.sh

aws ec2 run-instances --image-id ami-09e67e426f25ce0d7 --count 1 --instance-type t2.micro --key-name dolljm-ceclnx01 --security-group-ids default --user-data file://ec2-script2.sh

aws ec2 run-instances --image-id ami-09e67e426f25ce0d7 --count 1 --instance-type t2.micro --key-name dolljm-ceclnx01 --security-group-ids default --user-data file://ec2-script3.sh

aws ec2 run-instances --image-id ami-09e67e426f25ce0d7 --count 1 --instance-type t2.micro --key-name dolljm-ceclnx01 --security-group-ids default --user-data file://ec2-script4.sh
