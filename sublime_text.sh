#!/bin/zsh
#echo $1
#echo 'seperator'
if [ $# -eq 0 ]
then
	#echo 'Inside if'
	/opt/sublime_text/sublime_text /home/prithivi/temp.txt
	sleep 0.7
	xdotool key Escape
	sleep 0.7
	exit
fi
#echo $1
/opt/sublime_text/sublime_text $1
sleep 0.7
xdotool key Escape
sleep 0.7
exit
