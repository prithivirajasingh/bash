#!/bin/sh
#hosts to block in dnsmasq (Services\Additional Dnsmasq Options\addn-hosts=/jffs/badhosts)
#https://forum.dd-wrt.com/phpBB2/viewtopic.php?t=315773)
if mkdir /tmp/customlock 2> /dev/null
then
cd /jffs/
pwd
sleep 0
echo "Sleep completed"
curl -s https://winhelp2002.mvps.org/hosts.txt > temphosts.txt  2> badhosts.log
echo "Curl1 completed"
curl -s http://sbc.io/hosts/hosts  >> temphosts.txt  2>> badhosts.log
echo "Curl2 completed"
curl -s https://someonewhocares.org/hosts/zero/hosts  >> temphosts.txt  2>> badhosts.log
echo "Curl3 completed"
curl -s https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts  >> temphosts.txt  2>> badhosts.log
echo "Curl4 completed"
curl -s https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts >> temphosts.txt 2>> badhosts.log
echo "Curl5 completed"
sed 's/\t/ /g; /^0\.0\.0\.0 /!d; /www\.googleadservices\.com/d; /0 googleadservices\.com/d; /amazon/d; /clickserve\.dartsearch\.net/d; /ad\.doubleclick\.net/d; / doubleclick\.net/d; s/ *\#.*$//; s/\r//' temphosts.txt -i
echo "sed completed"
sort temphosts.txt -o temp.txt
echo "sort completed"
sort -u temp.txt -o temphosts.txt
echo "Remove duplicates completed"
cat hosts.bak temphosts.txt > badhosts
echo "Hosts.bak prepended"
cat /jffs/badhostslocal >> /jffs/badhosts
echo "Badhostslocal appended"
date >> /jffs/custom.sh.log
stopservice dnsmasq && startservice dnsmasq 
rmdir /tmp/customlock/
else
echo "Custom $(date)" >> /jffs/secondinstance
fi
