#!/bin/bash

while read subdomain
do
	host=$(echo $subdomain | unfurl domains)
	dirsearch -u $subdomain -E --plain-text-report=$host.txt	
done < $1
