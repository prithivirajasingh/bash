#!/bin/bash
# example # ffmpeg -ss 30 -i input.mp3 -c copy output.mp3
# example # ffmpeg -ss 10 -t 50 -i input.MP4 -vcodec h264_nvenc -an output.mp4
# example # ffmpeg -ss 13:30 -t 6:30 -i input.MP4 -vcodec h264_nvenc -acodec copy output.mp4

# read -p "Enter any key to continue, "a" to abort: " userinput
if [ "$userinput" = "a" ]; then
	printf "Program terminated by user."
	exit
fi
if [ "$userinput" = "A" ]; then
	printf "Program terminated by user."
	exit
fi

printf "Task started.\n"

read -p "Enter file extension with dot (Eg. .mp4): " fileextension
if [ -z "$fileextension" ]; then echo "Set to default extension .mp4" && fileextension=".mp4"; fi

read -p "Enter filecount: " filecount
if [ -z "$filecount" ]; then echo "Input cannot be empty. Program will now exit." & exit; fi


if [ "$filecount" -ge "1000" ]; then
	echo "Out of range. Program will now exit."
	exit
fi

echo "file '0001$fileextension'" > "`pwd`/list.txt"

for (( i=2; i<=$filecount; i++ )); do
	if [ "$i" -le "9" ]; then
		echo "file '000$i$fileextension'" >> "`pwd`/list.txt"
		continue
	fi
	if [ "$i" -le "99" ]; then
		echo "file '00$i$fileextension'" >> "`pwd`/list.txt"
		continue
	fi
	if [ "$i" -le "999" ]; then
		echo "file '0$i$fileextension'" >> "`pwd`/list.txt"
		continue
	fi
done

printf "Task completed."
