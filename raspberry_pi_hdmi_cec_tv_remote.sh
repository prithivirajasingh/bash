#!/bin/bash
# Location: /home/pi/bin/cec_remote.sh
# Requires installation of: cec-client, xdotool   [apt install cec-utils xdotool]
# Execute on login if required. To do so add below line in cron_reboot.sh 
# echo 6484 | su pi -l -c "export DISPLAY=:0; export XAUTHORITY=/home/pi/.Xauthority; /usr/bin/cec-client | /home/pi/bin/cec_remote.sh & disown"

function keychar {
    parin1=$1 #first param; abc1
    parin2=$2 #second param; 0=a, 1=b, 2=c, 3=1, 4=a, ...
    parin2=$((parin2)) #convert to numeric
    parin1len=${#parin1} #length of parin1
    parin2pos=$((parin2 % parin1len)) #position mod
    char=${parin1:parin2pos:1} #char key to simulate
    if [ "$parin2" -gt 0 ]; then #if same key pressed multiple times, delete previous char; write a, delete a write b, delete b write c, ...
        xdotool key "BackSpace"
    fi
    #special cases for xdotool ( X Keysyms )
    if [ "$char" = " " ]; then char="space"; fi
    if [ "$char" = "." ]; then char="period"; fi
    if [ "$char" = "-" ]; then char="minus"; fi
    xdotool key $char
}
datlastkey=$(date +%s%N)
strlastkey=""
intkeychar=0
intmsbetweenkeys=1500 #two presses of a key sooner that this makes it delete previous key and write the next one (a->b->c->1->a->...)
intmousestartspeed=5 #mouse starts moving at this speed (pixels per key press)
intmouseacc=50 #added to the mouse speed for each key press (while holding down key, more key presses are sent from the remote)
intmousespeed=10
FILE=~/bin/functionKey  # sub picture key (cc key to the right of 0) is used as functionKey
if [ -f "$FILE" ]; then
    rm $FILE
fi

while read oneline
do
    #keyline=$(echo $oneline | grep " key ")
    #echo $keyline --- debugAllLines
    keyline=$(echo $oneline | grep " key " | grep "duration\|ms")
    #echo $keyline --- debug keyline
    if [ -n "$keyline" ]; then
        datnow=$(date +%s%N)
        datdiff=$((($datnow - $datlastkey) / 1000000)) #bla bla key pressed: previous channel (123)
        strkey=$(grep -oP '(?<=sed: ).*?(?= \()' <<< "$keyline") #bla bla key pres-->sed: >>previous channel<< (<--123)
        #echo $strkey --- debug strkey
        strstat=$(grep -oP '(?<=key ).*?(?=:)' <<< "$keyline") #bla bla -->key >>pressed<<:<-- previous channel (123)
        #echo $strstat --- debug strstat
        strpressed=$(echo $strstat | grep "pressed")
        #echo $strpressed --- debug strpressed
        strreleased=$(echo $keyline | grep "released")
        #echo $strreleased --- debug strreleased
        if [ -n "$strpressed" ]; then
            #echo $keyline --- debug strpressed
            if [ "$strkey" = "$strlastkey" ] && [ "$datdiff" -lt "$intmsbetweenkeys" ]; then
                intkeychar=$((intkeychar + 1)) #same key pressed for a different char
            else
                intkeychar=0 #different key / too far apart
            fi
            datlastkey=$datnow
            strlastkey=$strkey
            case "$strkey" in
                "1")
                    if [ -f "$FILE" ]; then
                        xdotool mousemove 10 10
                    else
                        keychar "1abcd" intkeychar
                    fi
                    ;;
                "2")
                    if [ -f "$FILE" ]; then
                        xdotool mousemove 640 180
                    else
                        keychar "2efgh" intkeychar
                    fi
                    ;;
                "3")
                    if [ -f "$FILE" ]; then
                        xdotool mousemove 1270 10
                    else
                        keychar "3ijkl" intkeychar
                    fi
                    ;;
                "4")
                    if [ -f "$FILE" ]; then
                        xdotool mousemove 320 360
                    else
                        keychar "4mnop" intkeychar
                    fi
                    ;;
                "5")
                    if [ -f "$FILE" ]; then
                        xdotool mousemove 640 360
                    else
                        keychar "5qrst" intkeychar
                    fi
                    ;;
                "6")
                    if [ -f "$FILE" ]; then
                        xdotool mousemove 960 360
                    else
                        keychar "6uvw" intkeychar
                    fi
                    ;;
                "7")
                    if [ -f "$FILE" ]; then
                        xdotool mousemove 10 710
                    else
                        keychar "7xyz" intkeychar
                    fi
                    ;;
                "8")
                    if [ -f "$FILE" ]; then
                        xdotool mousemove 640 640
                    else
                        keychar "8" intkeychar
                    fi
                    ;;
                "9")
                    if [ -f "$FILE" ]; then
                        xdotool mousemove 1270 710
                    else
                        keychar "9" intkeychar
                    fi
                    ;;
                "0")
                    if [ -f "$FILE" ]; then
                        xdotool key "Ctrl+q"
                    else
                        keychar "0 ._-" intkeychar
                    fi
                    ;;
                "previous channel")
                    xdotool key "Return" #Enter
                    ;;
                "channel up")
                    xdotool click 4 #mouse scroll up
                    ;;
                "channel down")
                    xdotool click 5 #mouse scroll down
                    ;;
                "channels list")
                    xdotool click 3 #right mouse button click"
                    ;;
                "up")
                    if [ -f "$FILE" ]; then
                        xdotool key "Up"
                    else
                        intpixels=$((-1 * intmousespeed))
                        xdotool mousemove_relative -- 0 $intpixels #move mouse up
                        intmousespeed=$((intmousespeed + intmouseacc)) #speed up
                    fi
                    ;;
                "down")
                    if [ -f "$FILE" ]; then
                        xdotool key "Down"
                    else
                        intpixels=$(( 1 * intmousespeed))
                        xdotool mousemove_relative -- 0 $intpixels #move mouse down
                        intmousespeed=$((intmousespeed + intmouseacc)) #speed up
                    fi
                    ;;
                "left")
                    if [ -f "$FILE" ]; then
                        xdotool key "Left"
                    else
                        intpixels=$((-1 * intmousespeed))
                        xdotool mousemove_relative -- $intpixels 0 #move mouse left
                        intmousespeed=$((intmousespeed + intmouseacc)) #speed up
                    fi
                    ;;
                "right")
                    if [ -f "$FILE" ]; then
                        xdotool key "Right"
                    else
                        intpixels=$(( 1 * intmousespeed))
                        xdotool mousemove_relative -- $intpixels 0 #move mouse right
                        intmousespeed=$((intmousespeed + intmouseacc)) #speed up
                    fi
                    ;;
                "select")
                    #echo "select executed --- debug select"
                    if [ -f "$FILE" ]; then
                        xdotool key "Return"
                    else
                        xdotool click 1 #left mouse button click
                    fi
                    ;;
                "return")
                    xdotool key "Alt_L+Left" #WWW-Back
                    ;;
                "exit")
                    #echo Key Pressed: EXIT
                    tempstr=`xdotool getactivewindow getwindowname`
                    if [[ "$tempstr" == *"Mozilla Firefox"* ]]; then
                        xdotool key "Alt_L+Left"
                    else
                        xdotool key "BackSpace"
                    fi
                    ;;
                "F2")
                    # Red in Hisense
                    if [ -f "$FILE" ]; then
                        xdotool key "f"
                    else
                        xdotool key "Escape"
                    fi
                    #firefox "https://www.tamilhdbox.com/" & disown
                    # echo Key Pressed: RED
                    ;;
                "F3")
                    # Green in Hisense
                    if [ -f "$FILE" ]; then
                        pcmanfm ~/bin & disown
                    else
                        xdotool key Page_Up
                    fi
                    #firefox "https://www.1tamilmv.bar/" & disown
                    # echo Key Pressed: GREEN
                    ;;
                "F4")
                    # Yellow in Hisense
                    if [ -f "$FILE" ]; then
                        pcmanfm ~/Downloads/ftp & disown
                    else
                        xdotool key Page_Down
                    fi
                    #firefox "https://www.google.com/" & disown
                    # echo Key Pressed: YELLOW
                    ;;
                "F1")
                    # Blue in Hisense
                    xdotool click 3 #mouse button right click
                    #xdotool getactivewindow windowkill
                    # echo Key Pressed: BLUE
                    ;;
                "rewind")
                    xdotool key "Alt_L+Tab" #Tab cycling
                    #echo Key Pressed: REWIND
                    ;;
                "pause")
                    xdotool key "space"
                    #echo Key Pressed: PAUSE
                    ;;
                "Fast forward")
                    xdotool key "Ctrl+Alt_L+d" #Minimize all windows
                    #echo Key Pressed: FAST FORWARD
                    ;;
                "play")
                    xdotool key "space"
                    #echo Key Pressed: PLAY
                    ;;
                "stop")
                    xdotool key "space"
                    ## with my remote I only got "STOP" as key released (auto-released), not as key pressed; see below
                    #echo Key Pressed: STOP
                    ;;
                "sub picture")
                    touch $FILE
                    #echo Inside dot pressed. touch command executed.
                    #firefox "https://www.1tamilmv.bar/" & disown
                    #echo Dot key pressed --- debug
                    #xdotool key Page_Down
                    ## with my remote I only got "STOP" as key released (auto-released), not as key pressed; see below
                    #echo Key Pressed: STOP
                    ;;
                ".")
                    if [ -f "$FILE" ]; then
                        firefox "https://www.1tamilmv.bar/" & disown
                    else
                        firefox "https://www.tamilhdbox.com/" & disown
                    fi
                    #firefox "https://www.1tamilmv.bar/" & disown
                    #echo sub picture key pressed --- debug
                    #xdotool key Page_Up
                    ## with my remote I only got "STOP" as key released (auto-released), not as key pressed; see below
                    #echo Key Pressed: STOP
                    ;;
                "sound select")
                    #echo Key Pressed: sound select
                    activewindowname=`xdotool getactivewindow getwindowname`
                    if [[ "$activewindowname" == "pcmanfm" ]]; then
                        true
                        lxde-pi-shutdown-helper & disown
                        #echo "No active window to kill"
                    else
                        xdotool getactivewindow windowkill
                    fi
                    #lxde-pi-shutdown-helper & disown
                    ;;
                *)
                    echo Unrecognized Key Pressed: $strkey ; echo CEC Line: $keyline
                    ;;
            esac
        fi
        if [ -n "$strreleased" ]; then
            #echo $keyline --- debug strreleased
            case "$strkey" in
                "stop")
                    echo Key Released: STOP
                    ;;
                "up")
                    intmousespeed=$intmousestartspeed #reset mouse speed
                    ;;
                "down")
                    intmousespeed=$intmousestartspeed #reset mouse speed
                    ;;
                "left")
                    intmousespeed=$intmousestartspeed #reset mouse speed
                    ;;
                "right")
                    intmousespeed=$intmousestartspeed #reset mouse speed
                    ;;
                "sub picture")
                    sleep 2 && rm $FILE &
                    #echo Inside dot released. && sleep 2 && rm $FILE && echo rm command completed &
                    ;;
            esac
        fi
    fi
done

