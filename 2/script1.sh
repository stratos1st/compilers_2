#!/bin/bash
# makes mirror directory of input with my ouputs 

while read p; do
	if [ -z "$p" ]
	then
		continue
	fi
	if [[ $p == \.\/* ]]
	then
		file_name="./my_offsets"${p:1}
		# echo $file_name
		> $file_name
	else
		echo "$p" >> $file_name
	fi
done < outs.out
