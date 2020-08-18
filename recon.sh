#!/bin/bash

domain=$1
workspace=$HACKRESULT/$domain


# Make working directory
if [ ! -d "$workspace" ]; then
	echo "[*] Making directory for domain"
	mkdir -p "$workspace"
fi


# Enumerate subdomains
echo "[*] Enumerating subdomains"
if [ ! -e "$workspace/subdomains" ]; then 
	echo "[*] Get subdomains with 'amass'"
	if ! amass enum -passive -d $domain -o $workspace/sd1 > /dev/null 2>&1; then
		echo "[!] amass error"
	fi
	
	echo "[*] Get subdomains with 'subfinder'"
	if ! subfinder -d $domain -o $workspace/sd2 > /dev/null 2>&1; then
		echo "[!] subfinder error"
	fi

	echo "[*] Get subdomains with 'findomain'"
	if ! findomain -t $domain -o $workspace/sd2 > /dev/null 2>&1; then
		echo "[!] subfinder error"
	fi

	echo "[*] Merge subdomains from amass and subfinder"
	cat $workspace/sd* | sort -u > $workspace/subdomains.txt
	rm -f $workspace/sd*
fi


# Check live subdomains
echo "[*] Checking live subdomains"
if [ ! -e "$workspace/hosts" ]; then 
	httpx -l $workspace/subdomains.txt -status-code -title -silent -o $workspace/httpx.txt -no-color -silent
	cat $workspace/httpx.txt | cut -d' ' -f1 > $workspace/httpx_ho.txt
fi


# Run all nuclei template against hosts
'''
workspace_nuclei="$workspace/nuclei-results"
if [ ! -d $workspace_nuclei ]; then
	echo "[*] Making directory for nuclei results"
	mkdir -p $workspace_nuclei
fi

for dir in $HACKDATA/nuclei-templates/*/
do
	template=$(basename $dir)
	if ! nuclei -l $workspace/httpx_ho.txt -t $dir -o "$workspace_nuclei/$template" > /dev/null 2>&1; then 
		echo "[!] nuclei error with template: $template"
	fi
done
'''
