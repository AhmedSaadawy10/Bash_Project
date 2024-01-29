#! /usr/bin/bash
#show all dataBases
echo -e "${blue}### your databases ### ${reset}"
ls -F ${path} | grep / | tr '/' ' '
echo -e "${blue}#####################${reset}"
# get database name&check
read -p "Enter database name to drop : " dbname

# convert any space to ( _ )
while [[ $dbname == *" "* ]]; do
    dbname="${dbname/ /_}"
done

#check dataBase is exists to drop it
if [[ -z $dbname || ! -d $path"/"$dbname ]]; then
    echo -e "${red}  Database [${dbname}] not Found ${reset}"
else
    echo -e "${red} Are you sure to delete [${dbname}] [y/n] : ${reset}  "
    read answer
    if [ $answer == "y" -o $answer == "Y" ]; then
        rm -r $path"/"$dbname
        echo -e "${blue} ### Database [${dbname}] deleted succssfully. ### ${reset}"
    fi
fi
source main.sh
