#! /usr/bin/bash

# get table name&check
read -p "Enter table name : " tablename
while [[ -z $tablename || $tablename =~ ^[0-9] || $tablename == *['!''@#/$\"*{^})(+|,;:~`.%&/=-]>[<?']* ]]; do
    echo -e "$red Invaild Name $reset"
    read -p "Enter table name : " tablename
done
# convert every space to _
while [[ $tablename == *" "* ]]; do
    tablename="${tablename/ /_}"
done
if [ -f $path"/"$dbname"/"$tablename ]; then
    echo -e "${red} Table [${tablename}] already exists ${reset}"
else
    touch $path"/"$dbname"/"$tablename
    echo -e "${blue}### Table [${tablename}] created succssfully ###${reset}"
    # create metadata of table
    read -p "Enter Num.Of Columns For Table [${tablename}] : " numCols
    # check if input is valid [number]
    #try convert input to integer
    while ! [[ $numCols =~ ^[1-9][0-9]*$ ]]; do
        echo -e "$red Invaild Number $reset"
        read -p "Enter Num.Of Columns For Table [${tablename}] : " numCols
    done
    # convert numCols to intger [enable us to operate]
    let numCols=$numCols
    #Database Engine Tables accept at least two columns
    #i don`t need make empty table (file)
    while [[ $numCols < 2 ]]; do
        echo -e "$red Minimum Number Of Columns Is 2 $reset"
        read -p "Enter Num.Of Columns For Table [${tablename}] : " numCols
    done
    # by default first field name:id & constraint:PK
    # loop until numCols to get table columns name&type [string&int]
    echo -e "${blue}### Note that first column name is id and it is PK ###${reset}"
    record_name=''
    record_type=''
    for ((i = 2; i <= $numCols; i++)); do
        read -p "Enter Column [${i}] Name : " colName
        # start check col name
        while [[ -z $colName || $colName =~ ^[0-9] || $colName == *['!''@#/$\"*{^})(+|,;:~`.%&/=-]>[<?']* ]]; do
            echo -e "${red} Invaild colName ${reset}"
            read -p "Enter Column [${i}] Name : " colName
        done
        # end check col name
        # convert every space to _
        while [[ $colName == *" "* ]]; do
            colName="${colName/ /_}"
        done
        # end convert
        # check if colName found or not
        while [[ $record_name == *"${colName}"* || $colName == "id" ]]; do
            echo -e "${red} Column Name [${colName}] is Existed ${reset}"
            read -p "Enter Column [${i}] Name : " colName
        done
        # set 1st col=> id:primary key => if this first loop iteration
        # not ? append new column name
        if [ $i -eq 2 ]; then #check
            record_name+="id:"$colName
        else
            record_name+=":"$colName
        fi
        # end append col name to record
    done
    # write columns name in table file
    echo $record_name >>$path"/"$dbname"/"$tablename
    #  Get Columns Name Data Types
    echo -e "${blue}### Enter Data Types [string || integer] ###${reset}"
    # get Columns name from table
    colNames=$(cut -d ':' -f 2-$numCols $path"/"$dbname"/"$tablename)
    IFS=':' read -ra colArray <<<$colNames
    let c=0
    for ((i = 2; i <= $numCols; i++)); do
        echo "Enter data type for [${colArray[$c]}] column : "
        c+=1
        # select data types
        PS3="Select Option>>"
        select choice in "string" "integer"; do
            case $choice in
            "string")
                if [ $i -eq 2 ]; then
                    record_type=integer:string
                else
                    record_type+=:string
                fi
                break
                ;;
            "integer")
                if [ $i -eq 2 ]; then
                    record_type=integer:integer
                else
                    record_type+=:integer
                fi
                break
                ;;

            *)
                echo -e " ${red} Invaild data type ${reset}"
                continue
                ;;
            esac
            # end select
        done
        # end for
    done
    echo $record_type >>$path"/"$dbname"/"$tablename
    echo -e "${blue}Your table [${tablename}] meta data is : ${reset}\n $record_name \n $record_type "
    echo -e "${blue}###################${reset}"
fi
source db_menu.sh
