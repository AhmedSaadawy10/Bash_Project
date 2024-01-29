#! /usr/bin/bash
#show all tables which u can drop it
echo -e "${blue}### tables in this dataBase ### ${reset}"
ls -F $path"/"$dbname
echo -e "${blue}#####################${reset}"

# get table name&check
read -p "Enter Table Name To Drop : " tablename
if [ -f $path"/"$dbname"/"$tablename -a ! -z $tablename ]; then
    echo -e "${red}Are you sure to delete [${tablename}] [y/n] : ${reset}  "
    read ans
    if [ $ans == "y" -o $ans == "Y" ]; then
        rm $path"/"$dbname"/"$tablename
        echo -e "${blue} ### Table [${tablename}] deleted succssfully. ### ${reset}"
    fi
    source db_menu.sh

elif [[ -z $tablename || ! -f $path"/"$dbname"/"$tablename ]]; then
    echo -e "${red} Table [${tablename}] Not Found ${reset}"
    source db_menu.sh
fi
