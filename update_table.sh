#! /usr/bin/bash

#show tables in dataBase
echo -e "${blue}### Database [${dbname}] Tables ###${reset}"
ls ${path}/${dbname}
echo -e "${blue}###############################${reset} "

#get table name & check
read -p "Enter Table Name To Update data : " tablename
# check table exists
if [ -f $path"/"$dbname"/"$tablename ]; then
    # check if contains record
    count=$(cat $path"/"$dbname"/"$tablename | wc -l)
    if [[ $count > 2 ]]; then
        # get Columns name from table
        colNames=$(cut -d ':' -f 2- $path"/"$dbname"/"$tablename)
        IFS=':' read -ra colArray <<<$colNames

        # get Columns data types from table [second record]
        typeArray=$(head -2 $path"/"$dbname"/"$tablename | tail -1 | cut -d ':' -f 2-)
        IFS=':' read -ra dataType <<<$typeArray

        #get record id to update
        read -p "Enter Record Id : " id

        if [[ ! $id =~ ^[1-9][0-9]*$ ]]; then
            echo -e "${red}  ID must be integer  ${reset}"
            source db_menu.sh
        else
            # # search if first field is = id return entire record
            current=$(awk -v id=$id -F":" '{if(NR>2 && $1==id) print $0}' $path"/"$dbname"/"$tablename)

            if [[ ! -z $current ]]; then
                record=()
                # loop for fileds&datatype
                for ((i = 0; i < ${#colArray[@]}; i++)); do
                    read -p "Enter New Value Of [${colArray[$i]}] type [${dataType[$i]}] : " value
                    # check data type which enter is correct
                    if [[ ${dataType[$i]} = "string" ]]; then
                        if [[ ! $value == *[a-zA-z0-9]* ]]; then
                            echo -e "${red} [${colArray[$i]}]  must be string  ${reset}"
                            source db_menu.sh
                        else
                            # convert every space to ( _ )
                            while [[ $value == *" "* ]]; do
                                value="${value/ /_}"
                            done
                            # end convert
                            record[$i]=$value
                        fi
                    # Integer
                    elif [[ ${dataType[$i]} = "integer" ]]; then
                        if [[ ! $value =~ ^[0-9]*$ ]]; then
                            echo -e "${red} [${colArray[$i]}] must be integer ${reset}"
                            source db_menu.sh
                        else
                            record[$i]=$value
                        fi
                    fi
                    # end if => loop remaining names
                done
                # end loop
                data=""
                for item in ${record[@]}; do
                    data+=$item":"
                done
                data=$id":"$data
                updateRecord="${data%?}"
                # echo $updateRecord
                sed -i "/^$id/s/$current/$updateRecord/" $path"/"$dbname"/"$tablename
            else
                echo -e "${red} Record Not Found ${reset}"
                source db_menu.sh
            fi
        fi
        echo -e "${blue}### Record Update Succssfully. ### ${reset}"
        source db_menu.sh
        # table is empty
    else
        echo -e "${red} Table [${tablename}] dose not contain any records ${reset}"
        source db_menu.sh
    fi
# table not exit
else
    echo -e "${red} Table  [${tablename}] Not Found ${reset}"
    source db_menu.sh
fi
