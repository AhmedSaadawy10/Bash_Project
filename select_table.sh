#! /usr/bin/bash

#show all tables in dataBase
echo -e "${blue}### Database [${dbname}] Tables ###${reset}"
ls ${path}/${dbname}
echo -e "${blue}###############################${reset} "

#get table name & check
read -p "Enter Table Name To Select data : " tablename
# check table exists
if [ -f $path"/"$dbname"/"$tablename ]; then
	# check if contains record
	count=$(cat $path"/"$dbname"/"$tablename | wc -l)
	if [[ $count > 2 ]]; then
		# Ask to select all or by specific id
		echo -e "${blue} Select Records : ${reset}"
		PS3="Select Option>>"
		select type in "All" "By Id" "Exit"; do
			case $type in
			"All")
				awk -F: '{ if(NR==1) print $0  } {if(NR>2) print $0  }  ' $path"/"$dbname"/"$tablename
				;;
			"By Id")
				read -p "Enter Record id : " id
				if [[ ! $id =~ ^[1-9][0-9]*$ ]]; then
					echo -e "${red}  ID must be integer :) ${reset}"
					source db_menu.sh

				else
					# # search if first field is = id return entire record
					row=$(awk -F":" -v id=$id '{if($1==id) print $0} { if(NR==1) print $0  } ' $path"/"$dbname"/"$tablename)
					if [[ -z $row ]]; then
						echo -e "${red} Record Not Found ${reset}"
						source db_menu.sh
					else
						awk -v id=$id -F":" '{if(NR>2 && $1==id) print $0} { if(NR==1) print $0  } ' $path"/"$dbname"/"$tablename
					fi
				fi
				;;
			"Exit") break ;;
			*)
				echo -e "${red} Invalid Option ${reset} "
				;;
			esac
		done
		# if table empty
	else
		echo -e "${red} Table [${tablename}] dose not contain any records ${reset}"
	fi
	source db_menu.sh
else
	echo -e "${red} Table [${tablename}] Not Found ${reset}"
	source db_menu.sh
fi
