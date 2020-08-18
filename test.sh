#!/bin/bash

for dir in /home/qweroot/hacking/data/nuclei-templates/*/
do
	echo $dir
	template=$(basename $dir)
	echo $template
done 
