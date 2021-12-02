#!/bin/bash
# Location: /home/$USERNAME/bin/raspberry_pi_hdmi_cec_tv_remote.sh
# Requires installation of: cec-client, xdotool   [Run "sudo apt install cec-utils xdotool"]
# Execute on login if required. To do so uncomment and add below line in cron_reboot.sh and cron it to run reboot
# echo password | su $USERNAME -l -c "export DISPLAY=:0; export XAUTHORITY=/home/pi/.Xauthority; /usr/bin/cec-client | /home/$USERNAME/bin/raspberry_pi_hdmi_cec_tv_remote.sh & disown"

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
                    keychar "1abcd" intkeychar
                    ;;
                    #xdotool key "BackSpace"
                    #;;
                "2")
                    keychar "2efgh" intkeychar
                    ;;
                "3")
                    keychar "3ijkl" intkeychar
                    ;;
                "4")
                    keychar "4mnop" intkeychar
                    ;;
                "5")
                    keychar "5qrst" intkeychar
                    ;;
                "6")
                    keychar "6uvw" intkeychar
                    ;;
                "7")
                    keychar "7xyz" intkeychar
                    ;;
                "8")
                    keychar "8" intkeychar
                    ;;
                "9")
                    keychar "9" intkeychar
                    ;;
                "0")
                    keychar "0 .-" intkeychar
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
                    intpixels=$((-1 * intmousespeed))
                    xdotool mousemove_relative -- 0 $intpixels #move mouse up
                    intmousespeed=$((intmousespeed + intmouseacc)) #speed up
                    ;;
                "down")
                    intpixels=$(( 1 * intmousespeed))
                    xdotool mousemove_relative -- 0 $intpixels #move mouse down
                    intmousespeed=$((intmousespeed + intmouseacc)) #speed up
                    ;;
                "left")
                    intpixels=$((-1 * intmousespeed))
                    xdotool mousemove_relative -- $intpixels 0 #move mouse left
                    intmousespeed=$((intmousespeed + intmouseacc)) #speed up
                    ;;
                "right")
                    intpixels=$(( 1 * intmousespeed))
                    xdotool mousemove_relative -- $intpixels 0 #move mouse right
                    intmousespeed=$((intmousespeed + intmouseacc)) #speed up
                    ;;
                "select")
                    #echo "select executed --- debug select"
                    xdotool click 1 #left mouse button click
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
                    xdotool key "Escape"
                    #firefox "https://www.tamilhdbox.com/" & disown
                    # echo Key Pressed: RED
                    ;;
                "F3")
                    # Green in Hisense
                    xdotool key Page_Up
                    #firefox "https://www.1tamilmv.bar/" & disown
                    # echo Key Pressed: GREEN
                    ;;
                "F4")
                    # Yellow in Hisense
                    xdotool key Page_Down
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
                ".")
                    firefox "https://www.tamilhdbox.com/" & disown
                    #echo Dot key pressed --- debug
                    #xdotool key Page_Down
                    ## with my remote I only got "STOP" as key released (auto-released), not as key pressed; see below
                    #echo Key Pressed: STOP
                    ;;
                "sub picture")
                    firefox "https://www.1tamilmv.bar/" & disown
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
            esac
        fi
    fi
done
