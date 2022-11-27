#!/bin/sh
#hosts to block in dnsmasq (Services\Additional Dnsmasq Options\addn-hosts=/jffs/badhosts)
#https://forum.dd-wrt.com/phpBB2/viewtopic.php?t=315773)
if mkdir /tmp/customlock 2> /dev/null
then
echo "Inside first instance. Check time below." > /jffs/badhosts.log
date >> /jffs/badhosts.log
cd /jffs/
pwd >> /jffs/badhosts.log
sleep 60
echo "sleep 60 completed" >> /jffs/badhosts.log                                                                               
date >> /jffs/badhosts.log                                      
curl -s https://raw.githubusercontent.com/prithivirajasingh/bash/main/known_macs.txt > known_macs.txt 2>> /jffs/badhosts.log   
echo "known_macs completed" >> /jffs/badhosts.log                                                                          
curl -s https://winhelp2002.mvps.org/hosts.txt > temphosts.txt  2>> /jffs/badhosts.log                                     
echo "curl1 completed, winhelp2002" >> /jffs/badhosts.log                             
date >> /jffs/badhosts.log                                                            
curl -s http://sbc.io/hosts/hosts  >> temphosts.txt  2>> /jffs/badhosts.log
echo "curl2 completed, sbc" >> /jffs/badhosts.log                                             
date >> /jffs/badhosts.log                                                                    
curl -s https://someonewhocares.org/hosts/zero/hosts  >> temphosts.txt  2>> /jffs/badhosts.log
echo "curl3 completed, someonewhocares" >> /jffs/badhosts.log                                                     
date >> /jffs/badhosts.log                                                                                        
curl -s https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts  >> temphosts.txt  2>> /jffs/badhosts.log
echo "curl4 completed, stevenblack master" >> /jffs/badhosts.log                                                                                  
date >> /jffs/badhosts.log                                                                                                                        
curl -s https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts >> temphosts.txt 2>> /jffs/badhosts.log
echo "curl5 completed, stevenblack gambling" >> /jffs/badhosts.log                                                                                
date >> /jffs/badhosts.log                                                                                                                        
curl -s https://raw.githubusercontent.com/prithivirajasingh/bash/main/badhostslocal.txt > badhostslocal 2>> /jffs/badhosts.log
echo "curl6 completed, badhostslocal" >> /jffs/badhosts.log                                                                                                                                                                
date >> /jffs/badhosts.log                                                                                                                                                                                                 
sed 's/\t/ /g; /^0\.0\.0\.0 /!d; /www\.googleadservices\.com/d; /0 googleadservices\.com/d; /amazon/d; /clickserve\.dartsearch\.net/d; /ad\.doubleclick\.net/d; / doubleclick\.net/d; s/ *\#.*$//; s/\r//' temphosts.txt -i
echo "sed completed" >> /jffs/badhosts.log                                                                                                                                                                                 
date >> /jffs/badhosts.log                                                                                                                                                                                                 
sort temphosts.txt -o temp.txt             
echo "sort completed" >> /jffs/badhosts.log
date >> /jffs/badhosts.log                              
sort -u temp.txt -o temphosts.txt                       
echo "remove duplicates completed" >> /jffs/badhosts.log
date >> /jffs/badhosts.log                              
cat hosts.bak temphosts.txt > badhosts                  
echo "hosts.bak prepended" >> /jffs/badhosts.log
date >> /jffs/badhosts.log                         
cat /jffs/badhostslocal >> /jffs/badhosts          
echo "badhostslocal appended" >> /jffs/badhosts.log
date >> /jffs/badhosts.log                                                                                    
date >> /jffs/custom.sh.log                                                                                   
stopservice dnsmasq && startservice dnsmasq && echo "dnsmasq service restart successful" >> /jffs/badhosts.log
date >> /jffs/badhosts.log                                                                                    
rmdir /tmp/customlock/ && echo "customlock directory removed" >> /jffs/badhosts.log                           
date >> /jffs/badhosts.log                                                         
echo "Task completed successfully" >> /jffs/badhosts.log                           
date >> /jffs/badhosts.log                                               
else                                                                     
echo "Inside duplicate instance. Check time below." >> /jffs/badhosts.log
date >> /jffs/badhosts.log                                               
echo "Custom $(date)" >> /jffs/secondinstance                            
fi                                           

