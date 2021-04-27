#!/bin/bash
# aranges false possitives beautifuly

while read p; do
	if [ -z "$p" ]
	then
		continue
	fi
	if [[ $p == \.\/* ]]
	then
		if [[ $p != *error* ]]
		then
			echo -e "\n~\c"
			ok=1
		else
			ok=0
		fi
	fi
	if [[ $ok == 1 ]]
	then
		echo -e "|\c"
		echo "$p"
	fi
done < err.txt
