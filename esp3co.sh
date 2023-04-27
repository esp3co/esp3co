#!/bin/bash

# Teste if the $1 is set
if [ -z $1 ]; then
        echo "usage: ./esp3co <domains.txt>"
        exit
fi

# Teste if the $1 exists#!/bin/bash
while IFS= read -r domain; do

        today=$(date +'%Y%m%d')
        domain_dir=$domain'_'$today

        echo "domain $domain read"

        if [ ! -d $domain_dir ]; then
                mkdir $domain_dir
                echo "domain dir created: $domain_dir"

                # vars
                subs_file=$domain_dir'/subs.txt'
                nuclei_file=$domain_dir'/nuclei.txt'

                echo "running chaos ..."
                chaos -d $domain | httpx -silent > $subs_file

                echo "found $(cat $subs_file | wc -l) sub domains"

                echo "running nuclei ..."
                nuclei -l $subs_file -stats -o $nuclei_file -s high,critical -mhe 5 -timeout 5
        else
                echo "domain dir already exists: $domain_dir"
        fi

done < $1