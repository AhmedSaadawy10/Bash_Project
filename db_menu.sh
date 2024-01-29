#! /usr/bin/bash

#connect successfully to dataBase
echo -e "${blue} ### You connected to database [${dbname}] successfully ### ${reset}"

#select menu
PS3="Select Option>>"
select option in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "Back To Menu"; do
	case $option in
	"Create Table")
		source create_table.sh
		;;
	"List Tables")
		source list_table.sh
		;;
	"Drop Table")
		source drop_table.sh
		;;
	"Insert into Table")
		source insert_table.sh
		;;
	"Select From Table")
		source select_table.sh
		;;
	"Delete From Table")
		source delete_table.sh
		;;
	"Update Table")
		source update_table.sh
		;;
	"Back To Menu")
		source main.sh
		;;

	*)
		echo -e "${red} Invalid option ${reset}"
		;;
	esac
done
