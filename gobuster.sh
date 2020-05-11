#!/bin/bash

DOMAIN=$1
WORKSPACE=$HACKING_BASE/$DOMAIN


# Bruteforce directory for each subdomains
echo "[*] Brute forcing directories for live subdomains"
if [ ! -d "$WORKSPACE/gobuster" ]; then
	echo "[*] Making directory for domain"
	mkdir "$WORKSPACE/gobuster"
fi
while read subdomain; do
	URL="https://$subdomain" 
	OUTPUT="$WORKSPACE/gobuster/$URL.txt"
	echo $OUTPUT
	if ! gobuster dir -u "$URL" -w /Users/qweroot/Tools/wordlist/SecLists/Discovery/Web-Content/big.txt -o "$WORKSPACE/gobuster/$subdomain.txt"; then
		echo "[!] gobuster error"
		exit
	fi
done < $WORKSPACE/live.txt
