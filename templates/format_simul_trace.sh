#!/bin/bash

file="$1"
output="$2"

if [ -z $file ] || [ -z $output ]; then
        echo "./script TRACES/trace.test output_name"
        exit 1
fi

aux="aux${output}.out"

head -n 1 $file | sed -e 's/,/-/g' -e 's/=[[:alnum:]]*-*[[:alnum:]]*:*[[:alnum:]]*:*[[:alnum:]]*//g' -e 's/\[[[:alnum:]]*-*[[:alnum:]]*:*[[:alnum:]]*\]//g' -e 's/[[:digit:]]*-*[[:digit:]]*//g' -e 's/\[\]//g' | tr '[:upper:]' '[:lower:]' >> $output
sed -e 's/= /=x /g' -e  's/=$/=x/g'  $file | sed 's/[[:alpha:]]*=//g' > $aux

while IFS= read -r line
do
	nodelist=$(echo "$line" | awk '{print $9}')
	memnodelist=$(echo "$line" | awk '{print $13}')
	id=$(echo $line | awk '{print $1}')
	nodeexpanded="x"
	memnodeexpanded="x"
	echo $line" "$nodeexpanded" "$memnodeexpanded >> $output

done < "$aux"

rm $aux

