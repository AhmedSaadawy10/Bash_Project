#! /usr/bin/bash

# get dataBase name and check syntax
read -p "Enter database name : " dbname

# check if it empty,start with num or contain these special charachters
while [[ -z $dbname || $dbname =~ ^[0-9] || $dbname == *['!''@#/$\"*{^})(+|,;:~`.%&/=-]>[<?']* ]]; do
    echo -e "${red} Invaild Name  ${reset}"
    read -p "Enter database name : " dbname
done

# convert any space to ( _ )
while [[ $dbname == *" "* ]]; do
    dbname="${dbname/ /_}"
done
# check if dataBase exists
if [ -d $path"/"$dbname ]; then
    echo -e "${red} Database [${dbname}] already exists ${reset}"
else
    mkdir $path"/"$dbname
    echo -e "${blue}### Database [${dbname}] created succssfully ### ${reset}"
fi

source main.sh
