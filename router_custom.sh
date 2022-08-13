#!/bin/sh
#hosts to block in dnsmasq (Services\Additional Dnsmasq Options\addn-hosts=/jffs/badhosts)
#https://forum.dd-wrt.com/phpBB2/viewtopic.php?t=315773)
if mkdir /tmp/customlock 2> /dev/null
then
echo "Inside if" > /jffs/badhosts.log
date >> /jffs/badhosts.log
cd /jffs/
pwd >> /jffs/badhosts.log
sleep 30
echo "Sleep 30 completed" >> /jffs/badhosts.log
curl -s https://raw.githubusercontent.com/prithivirajasingh/bash/main/badhostslocal.txt > badhostslocal 2>> /jffs/badhosts.log
echo "badhostslocal command completed" >> /jffs/badhosts.log
curl -s https://winhelp2002.mvps.org/hosts.txt > temphosts.txt  2>> /jffs/badhosts.log
echo "winhelp2002 Curl1 completed" >> /jffs/badhosts.log
curl -s http://sbc.io/hosts/hosts  >> temphosts.txt  2>> /jffs/badhosts.log
echo "sbc Curl2 completed" >> /jffs/badhosts.log
curl -s https://someonewhocares.org/hosts/zero/hosts  >> temphosts.txt  2>> /jffs/badhosts.log
echo "someonewhocares Curl3 completed" >> /jffs/badhosts.log
curl -s https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts  >> temphosts.txt  2>> /jffs/badhosts.log
echo "stevenblack master Curl4 completed" >> /jffs/badhosts.log
curl -s https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts >> temphosts.txt 2>> /jffs/badhosts.log
echo "stevenblack gambling Curl5 completed" >> /jffs/badhosts.log
sed 's/\t/ /g; /^0\.0\.0\.0 /!d; /www\.googleadservices\.com/d; /0 googleadservices\.com/d; /amazon/d; /clickserve\.dartsearch\.net/d; /ad\.doubleclick\.net/d; / doubleclick\.net/d; s/ *\#.*$//; s/\r//' temphosts.txt -i
echo "sed completed" >> /jffs/badhosts.log
sort temphosts.txt -o temp.txt
echo "sort completed" >> /jffs/badhosts.log
sort -u temp.txt -o temphosts.txt
echo "Remove duplicates completed" >> /jffs/badhosts.log
cat hosts.bak temphosts.txt > badhosts
echo "hosts.bak prepended" >> /jffs/badhosts.log
cat /jffs/badhostslocal >> /jffs/badhosts
echo "badhostslocal appended" >> /jffs/badhosts.log
date >> /jffs/custom.sh.log
stopservice dnsmasq && startservice dnsmasq && echo "dnsmasq service restart successful" >> /jffs/badhosts.log
rmdir /tmp/customlock/ && echo "customlock directory removed" >> /jffs/badhosts.log
date >> /jffs/badhosts.log                                   
echo "Task completed successfully" >> /jffs/badhosts.log
else                                         
echo "Inside else" >> /jffs/badhosts.log     
date >> /jffs/badhosts.log                   
echo "Custom $(date)" >> /jffs/secondinstance
fi
