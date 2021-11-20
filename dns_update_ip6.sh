#!/bin/bash
# CRON NOT LESS THAN 30 MINS

# echo "" > ~/ip6.txt
# lk_ip6=`cat ~/ip6.txt 2> /dev/null`
lk_ip6=`nslookup printer6000.crabdance.com | grep answer -A10 | grep Address | awk '{print $2}'`
echo "Last known ip6 address of printer6000.crabdance.com:"
echo $lk_ip6
# echo ""
# lk_ip6='nslookup printer6000.crabdance.com | grep answer -A10 | grep Address | awk '{print $2}''
# echo "ifconfig inet6 output:"
# ifconfig | grep inet6
# ifconfig | grep inet6 | grep global -m1 | awk '{print $2}' > ~/ip6.txt
# echo "" > ~/ip6.txt
# current_ip6=`cat ~/ip6.txt`
current_ip6=`ifconfig | grep inet6 | grep global -m1 | awk '{print $2}'`
echo "Current ip6 address:"
echo $current_ip6
# echo ""
if [ "$current_ip6" != "$lk_ip6" -a ${#current_ip6} -gt 1 ]; then
	echo "Updating printer6000.crabdance.com"
	# printer6000.crabdance.com
	update_url="https://freedns.afraid.org/dynamic/update.php?aGNUeUtsY1VSQTlKVEtnNHN0NVBkWlh5OjIwMDU2NzEy&address=${current_ip6}"
	curl $update_url
else
	echo "No action needed for printer6000.crabdance.com"
fi

echo ""

# echo "" > ~/ip6.txt
# lk_ip6=`cat ~/ip6.txt 2> /dev/null`
lk_ip6=`nslookup prithivi6.crabdance.com | grep answer -A10 | grep Address | awk '{print $2}'`
echo "Last known ip6 address of prithivi6.crabdance.com:"
echo $lk_ip6
# echo ""
# lk_ip6='nslookup printer6000.crabdance.com | grep answer -A10 | grep Address | awk '{print $2}''
# echo "ifconfig inet6 output:"
# ifconfig | grep inet6
# ifconfig | grep inet6 | grep global -m1 | awk '{print $2}' > ~/ip6.txt
# echo "" > ~/ip6.txt
# current_ip6=`cat ~/ip6.txt`
current_ip6=`ifconfig | grep inet6 | grep global -m1 | awk '{print $2}'`
echo "Current ip6 address:"
echo $current_ip6
# echo ""
if [ "$current_ip6" != "$lk_ip6" -a ${#current_ip6} -gt 1 ]; then
	echo "Updating prithivi6.crabdance.com"
	# prithivi6.crabdance.com
	update_url="http://freedns.afraid.org/dynamic/update.php?UGxRWjRyaU9tWFdrVmNqekNtNEJaQ2JjOjIwMDU4MDg3&address=${current_ip6}"
	curl $update_url
else
	echo "No action needed for prithivi6.crabdance.com"
fi
