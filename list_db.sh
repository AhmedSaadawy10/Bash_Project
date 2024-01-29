#!/usr/bin/bash

# check if there databases
count=$(ls ${path} | wc -l)
if [[ $count > 0 ]]; then
    echo -e "${blue}### You have [${count}] Databases ###${reset}"
    ls -F ${path} | grep / | tr '/' ' '
    echo -e "${blue}#####################${reset}"
else
    echo -e "${red} No Databases Found ${reset}"
fi

source main.sh
