#! /usr/bin/bash

#listing taples in the dataBase
echo -e "${blue}### Database [${dbname}] Tables ###${reset}"
ls ${path}/${dbname}
echo -e "${blue}###############################${reset} "

#select taple to insert into
read -p "Enter Table Name To Insert data : " tablename

# check table exists
if [ -f $path"/"$dbname"/"$tablename ]; then
    # get Columns name from table
    colNames=$(cut -d ':' -f 1- $path"/"$dbname"/"$tablename)
    IFS=':' read -ra colArray <<<$colNames
    # echo "Names" ${colArray[@]}
    # get Columns data types from table [second record]
   
    types=$(awk -F":" '{if(NR==2) print $0}' $path"/"$dbname"/"$tablename)
    IFS=':' read -ra typeArray <<<$types
 
    # Note that first field [id => integer => PK]
    # get All Pks in table
    pks=($(awk -F":" '{if(NR>2) print $1}' $path"/"$dbname"/"$tablename))
    # echo ${pks[@]}
    # define record to store inputs
    record=()
    for ((i = 0; i < ${#colArray[@]}; i++)); do
        # check PK
        if [[ ${colArray[$i]} == "id" ]]; then
            read -p "insert into [${colArray[$i]}] type [${typeArray[$i]}] & [Unique] Value : " value

            if [[ ${pks[@]} =~ $value ]]; then
                echo -e "${red}  ID must be unique  ${reset}"
                source db_menu.sh
            elif [[ $value -le 0 || ! $value =~ ^[1-9][0-9]*$ ]]; then
                echo -e "${red}  ID must be integer  ${reset}"
                source db_menu.sh
            else
                record[$i]=$value
            fi
        # remaining fields
        else
            read -p "insert into [${colArray[$i]}] type [${typeArray[$i]}] Value : " value

            # check datatype
            # string datatype
            if [[ ${typeArray[$i]} = "string" ]]; then
                if [[ ! $value == *[a-zA-z0-9]* ]]; then
                    echo -e "${red} [${colArray[$i]}] must be string  ${reset}"
                    source db_menu.sh
                else
                    # convert every space to _
                    while [[ $value == *" "* ]]; do
                        value="${value/ /_}"
                    done
                    # end convert
                    record[$i]=$value
                fi
            # Integer
            elif [[ ${typeArray[$i]} = "integer" ]]; then
                if [[ ! $value =~ ^[0-9]*$ ]]; then
                    echo -e "${red} [${colArray[$i]}] must be integer  ${reset}"
                    source db_menu.sh
                else
                    record[$i]=$value
                fi

            fi
        # end if => loop remaining names
        fi
    done
    data=""
    for item in ${record[@]}; do
        data+=$item":"
    done
    # remove last :
    data="${data%?}"
    echo $data >>$path"/"$dbname"/"$tablename
    echo -e "${blue} ### Inserted  [$data] in [$tablename] Succsfully ###${reset}"
    source db_menu.sh
# Table not found
else
    echo -e "${red} Table [${tablename}] Not Found ${reset}"
    source db_menu.sh
fi
