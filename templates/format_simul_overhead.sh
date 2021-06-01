#!/bin/bash

file="$1"
output="$2"

if [ -z $file ] || [ -z $output ]; then
        echo "./script log/slurmctld.log output_name"
        exit 1
fi

grep "stats: bf total time\|stats: normal sched total" $d/log/slurmctld.log | sed -e 's/normal//g' -e 's|,||g' -e 's/queue//g' | awk '{print $3" "$6" "$13}' >> ${output}
sed -i '1s/^/type ttime jobstriedorqueue\n/' ${output}

