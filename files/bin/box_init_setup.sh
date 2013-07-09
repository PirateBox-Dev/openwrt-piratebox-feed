#!/bin/sh

### Initial Setup script for:
##      - setting password
##      - Date & Time with userinput
##            => initialize timesave script if available.

DEBUG=1

mainmenu() {

	while  true  
	do
		echo "-------------------------------------"
		echo \n
		echo "   1 - Setting password and enable SSH"
		echo "   2 - Set date & time (enable timesave)"
		echo \n
		echo " Everything else causes an exit"
		echo \n
		read -p " Choose an option: " option

		case $option in 
			("1")  _set_password_ ;;
			("2")  _set_date_ ;;
			(*) exit 0;;
		esac
		option=""
	done
}

_set_password_() {

	echo "Please enter your password. The following command won't show you the entered letters."
	local cmd=passwd
	if [ ! $DEBUG ] ; then
		$cmd  && echo "$? ....OK" 
	else
		echo "$cmd"
	fi

}

_set_date_() {

	local year=""
	local time_=""
	
	read -p "Please enter your date in the format  YYYYMMDD : " year
	read -p "Please enter your time in the format  HHMM : " time_
	datetime="$year""$time_"
	local cmd="date $datetime"
	if [ ! $DEBUG ] ; then 
		$cmd && echo "... OK"
	else
		echo "$cmd"
	fi
}

mainmenu
