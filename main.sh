#! /usr/bin/bash

# exports red color for invalid operation, reset for main color and blue for sucssess
export red='\033[1;31m'
export reset='\033[0m'
export blue='\033[0;34m'

#export dataBase path
export path="./database"

# check if dataBase file exists or it's the first time so (create database dir)
if [ ! -d database ]; then
	mkdir database
fi

# main select menu
PS3="Select Option>>"
select option in "Create Database" "List Database" "Connect Database" "Drop Database" "Exit"; do
	case $option in
	"Create Database")
		source create_db.sh
		;;
	"List Database")
		source list_db.sh
		;;
	"Drop Database")
		source drop_db.sh
		;;
	"Connect Database")
		source connect_db.sh
		;;
	"Exit")
		exit
		;;
	*)
		echo -e "${red} Invalid Option ${reset}"
		;;
	esac
done
