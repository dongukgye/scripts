#!/bin/bash 

DOMAIN=$1

ports=$(nmap -p- --min-rate=1000 -T4 $DOMAIN | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)
nmap -sC -sV -p$ports $DOMAIN
