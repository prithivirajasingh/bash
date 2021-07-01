#!/bin/bash
read -p "Enter any key to continue, "a" to abort: " userinput
if [ "$userinput" = "a" ]; then
	printf "Program terminated by user."
	exit
fi
if [ "$userinput" = "A" ]; then
	printf "Program terminated by user."
	exit
fi

printf "Task started."

read -p "Enter file extension with dot (Eg. .mp4): " fileextension
if [ -z "$fileextension" ]; then echo "Set to default extension .mp4" && fileextension=".mp4"; fi

a=1
for i in *; do 
	if [ -f "$i" ]; then
		new=$(printf "%04d" "$a") #0.d pad length
		# printf $new
		# printf '\n'
		# printf `pwd`
		# printf '\n'
		echo "$i"
		mv -i -- "`pwd`/$i" "`pwd`/$new$fileextension"
		a=`expr $a + 1`
	fi
done
printf "Task completed."
