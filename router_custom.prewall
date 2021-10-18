#!/bin/sh
# location: /jffs/etc/config/custom.prewall
if mkdir /tmp/prewalllock 2> /dev/null
then
sleep 30
date >> /jffs/custom.startup.log
/jffs/custom.sh &
iptables -I FORWARD -d 104.22.15.170 -j DROP
rmdir /tmp/prewalllock/
else
echo "Startup $(date)" >> /jffs/secondinstance
fi
