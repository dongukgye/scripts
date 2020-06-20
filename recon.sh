#!/bin/bash

DOMAIN=$1
WORKSPACE=$HACKING_RESULT/$DOMAIN


# Make working directory
if [ ! -d "$WORKSPACE" ]; then
	echo "[*] Making directory for domain"
	mkdir "$WORKSPACE"
fi


# Enumerate subdomains
echo "[*] Enumerating subdomains"
if [ ! -e "$WORKSPACE/subdomains.txt" ]; then 
	if ! amass enum -active -d $DOMAIN -o $WORKSPACE/subdomains.txt; then
		echo "[!] amass error"
		exit
	fi
fi


# Check live subdomains
echo "[*] Checking live subdomains"
if [ ! -e "$WORKSPACE/live.txt" ]; then 
	cat $WORKSPACE/subdomains.txt | httprobe | tee $WORKSPACE/live.txt
	# while read line; do
	# 	subdomain=`echo $line | cut -d ' ' -f1`
		
		# if curl -m 2 "$subdomain" &> /dev/null; then
		# 	echo "$line" >> $WORKSPACE/live.txt
		# fi
	# done < $WORKSPACE/subdomains.txt
fi
