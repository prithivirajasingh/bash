#!/bin/bash
cd /home/prithivi/bin/hosts/
curl https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts > /home/prithivi/bin/hosts/hosts_master.txt   
curl https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts > /home/prithivi/bin/hosts/hosts_alternate.txt
rm /home/prithivi/bin/hosts/hosts
cat /home/prithivi/bin/hosts/hosts.bak /home/prithivi/bin/hosts/hosts_master.txt /home/prithivi/bin/hosts/hosts_alternate.txt > /home/prithivi/bin/hosts/hosts
