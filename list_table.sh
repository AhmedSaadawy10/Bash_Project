#! /usr/bin/bash

# check if there tables
let count=$(ls $path"/"$dbname | wc -l)
if [[ $count > 0 ]]; then
    echo -e "${blue}### You have [${count}] taples ### ${reset}"
    ls -F $path"/"$dbname
else
    echo -e "${red} No Tables Found ${reset}"
fi
source db_menu.sh
