#!/bin/bash

DOMAIN=$1
WORKSPACE=$HACKING_BASE/$DOMAIN


# Make working directory
if [ ! -d "$WORKSPACE" ]; then
	echo "[*] Making directory for domain"
	mkdir "$WORKSPACE"
fi


# Enumerate subdomains
echo "[*] Enumerating subdomains"
if [ ! -e "$WORKSPACE/subdomains.txt" ]; then 
	if ! amass enum -active -d $DOMAIN -o $WORKSPACE/subdomains.txt &>/dev/null; then
		echo "[!] amass error"
		exit
	fi
fi


# Check live subdomains
echo "[*] Checking live subdomains"
if [ ! -e "$WORKSPACE/live.txt" ]; then 
	while read subdomain; do
		if host "$subdomain" > /dev/null; then
			echo "$subdomain" >> $WORKSPACE/live.txt
		fi
	done < $WORKSPACE/subdomains.txt
fi


# Get Screenshots
echo "[*] Getting screenshots for live subdomains"
if [ ! -d "$WORKSPACE/eyewitness" ]; then
	echo "[*] Making directory for domain"
	mkdir "$WORKSPACE/eyewitness"
fi

if ! docker run --rm -it -v $WORKSPACE:/tmp/EyeWitness eyewitness -f /tmp/EyeWitness/live.txt -d /tmp/EyeWitness/eyewitness  --no-prompt 1>/dev/null; then
	echo "[!] eyewitness error"
	exit
fi
