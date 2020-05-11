#!/bin/bash

if [ -z $1 ]; then
	echo >&2 "ERROR: URL not set"
	exit 2
fi

if [ -z $2 ]; then
	echo >&2 "ERROR: Wordlist not set"
	exit 2
fi

gobuster dir -u $1 -w $2
