#! /usr/bin/bash

#show tables in dataBase
echo -e "${blue}### Database [${dbname}] Tables ###${reset}"
ls ${path}/${dbname}
echo -e "${blue}###############################${reset} "

#get table name & check
read -p "Enter Table Name To Delete data : " tablename

# check table exists
if [ -f $path"/"$dbname"/"$tablename ]; then
    # check if contains record
    count=$(cat $path"/"$dbname"/"$tablename | wc -l)
    if [[ $count > 2 ]]; then
        # Ask to delete all or by specific id
        echo -e "${red} Delete : ${reset}"
        PS3="Select Option>>"
        select type in "All" "By Id" "Exit"; do
            case $type in
            "All")
                echo -e "${red}Are you sure to delete  all records from [${tablename}] [y/n] : ${reset}  "
                read answer
                if [ $answer == "y" -o $answer == "Y" ]; then
                    sed -i '3,$d' $path"/"$dbname"/"$tablename
                    echo -e "${blue}### [${tablename}] Records deleted succssfully. ###${reset}"
                    source db_menu.sh
                fi
                ;;
            "By Id")
                read -p "Enter Record id : " id
                if [[ ! $id =~ ^[1-9][0-9]*$ ]]; then
                    echo -e "${red}  ID must be integer  ${reset}"
                    source db_menu.sh
                else
                    # delete now
                    row=$(awk -F":" -v id=$id '{if($1==id) print $0}' $path"/"$dbname"/"$tablename)
                    if [[ -z $row ]]; then
                        echo -e "${red} Record Not Found ${reset}"
                        source db_menu.sh
                    else
                        echo -e "${red}Are you sure to delete Record ${row} [y/n] : ${reset}  "
                        read answer
                        if [ $answer == "y" -o $answer == "Y" ]; then
                            sed -i '/'${row}'/d' $path"/"$dbname"/"$tablename
                            echo -e "${blue} ### Record deleted from [${tablename}] succssfully. ### ${reset}"
                        fi
                        source db_menu.sh
                    fi

                fi
                ;;
            "Exit")
                break
                source db_menu.sh
                ;;
            *)
                echo -e "${red} Invalid Option ${reset} "
                source db_menu.sh
                ;;
            esac
        done
        # table is empty
    else
        echo -e "${red} Table [${tablename}] dose not contain any records ${reset}"
        source db_menu.sh
    fi
# table not exit
else
    echo -e "${red} Table [${tablename}] Not Found ${reset}"
    source db_menu.sh
fi
