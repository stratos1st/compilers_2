#!/bin/bash
# counts correct
# den ine telio, metrai +1 sosto

bad=0
good=0
total=-1
while read p; do
	# echo "$p"

	if [ -z "$p" ]
	then
		continue
	fi
	if [[ $p == =* ]]
	then
		continue
	fi
	if [[ $p == -* ]]
	then
		total=$((total+1))
		if [[ $pabla == 1 ]]
		then
			good=$((good+1))
		else
			bad=$((bad+1))
		fi
		pabla=1
	else
		pabla=0
	fi
done < out.txt
echo "sosta: "$good"/"$total" la8os: "$bad"/"$total
