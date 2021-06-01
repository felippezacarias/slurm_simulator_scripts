#!/bin/bash

file="$1"
output="$2"

if [ -z $file ] || [ -z $output ]; then
	echo "./script slurmctld.log output_name"
	exit 1
fi

grep "debug_utilization"  $file | sed 's/_//g' | sed -e 's/[a-z]*=//g' | awk '{print $3" "$4" "$5" "$6" "$7" "$8" "$9}' >> $output

sed -i '1s/^/start_end job_id job_scan_id nodes memoryallocated partition load\n/' $output

sed -i '/(null)/d' $output

