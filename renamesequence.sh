#!/bin/bash
read -p "Enter any key to continue, "a" to abort: " userinput
if [ "$userinput" = "a" ]; then
	exit
fi
if [ "$userinput" = "A" ]; then
	exit
fi

a=1
for i in *; do 
	if [ -f "$i" ]; then
		new=$(printf "%04d" "$a") #0.d pad length
		# printf $new
		# printf '\n'
		# printf `pwd`
		# printf '\n'
		echo "$i"
		mv -i -- "`pwd`/$i" "`pwd`/$new"
		a=`expr $a + 1`
	fi
done
