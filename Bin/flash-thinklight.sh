#!/bin/bash
times=3

state=`cat /proc/acpi/ibm/light | grep status | cut -f 3`

for (( i = 0; $i < $times * 2; i++ )); do
	if [ "x$state" == "xon" ]; then
		state="off";
	else
		state="on";
	fi
	
	echo "$state" > /proc/acpi/ibm/light
	
	sleep 0.1s;
done;
