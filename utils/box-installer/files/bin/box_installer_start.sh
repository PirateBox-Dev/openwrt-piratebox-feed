#!/bin/sh

auto_package=/mnt/usb/install/auto_package
auto_package_done=/mnt/usb/install/auto_package_done
logfile=/mnt/usb/install.log
image_prefix="openwrt"

new_image_location=/mnt/usb/auto_flash
stopfile=/mnt/usb/stop.txt

start_log(){
##Central function for logging;
	[ -e $logfile ] && echo "---------------------------------------------" >> $logfile
	uci set system.@system[0].log_file='/tmp/messages' 
	uci set system.@system[0].log_type='file' 
	uci set system.@system[0].log_remote='1' 
	uci set system.@system[0].log_ip='192.168.1.2'
	uci set system.@system[0].log_port='9999'
	uci set system.@system[0].log_proto='udp'
	/etc/init.d/log restart
	sleep 2
	uci revert system
}

finish_log(){
	## Copy log to USB disc
	echo "$0 : Logging install log to USB-Stick"
	cat /tmp/messages >>  $logfile
}

auto_flash_supported(){
    # that file is generated during boot up and contains the board name
    test ! -e /tmp/sysinfo/board_name && return 1

    if  model_type=$( cat /tmp/sysinfo/board_name ) ; then
    	echo "$: Model Type ${model_type} identified" | logger
	    return 0
    else
        echo "$: Error getting board name from  /tmp/sysinfo/board_name" | logger
        return 1
    fi
}



if  auto_flash_supported && ls -1  "${new_image_location}"/${image_prefix}-*.bin >> /dev/null 2>&1  ; then
	## Found image(s) at the download location
	found_images=$( ls  ${new_image_location}/${image_prefix}-*${model_type}*.bin | wc -w )

	if [ "$found_images" -eq 1 ] ; then
		cnt=$( ls $new_image_location/${image_prefix}-*${model_type}*.bin* | wc -w  )
		image_path=$( ls -1 ${new_image_location}/${image_prefix}-*${model_type}*.bin )
		echo "$0 : Creating backup of image file - name: ${image_path}.${cnt} "
		mv  $image_path     "${image_path}.${cnt}" 
		echo "$0: Copy image to /tmp "
		filename=$(basename ${image_path} )
		cp "${image_path}.${cnt}"  "/tmp/${filename}"
		start-stop-daemon -b -S -x sysupgrade --  -n  "/tmp/${filename}"  2>&1
		echo "Backgrounded sysupgrade, exiting now."
		exit 0 	
	else
		echo "$0 : More than one image found fitting to: "
		echo "$0 :      modeltype: ${model_type} "
		ls  ${new_image_location}/${image_prefix}-*${model_type}*.bin 
	fi
else
	 auto_flash_supported || echo "$0 : unsupported architecture for auto flash- ${DISTRIB_TARGET}"
fi

if [ -e $stopfile ] ; then
	start_log
	logger "$0 : Stop file detected. Ending processing"
	rm  $stopfile   2>&1 | logger 
	logger "$0 : Stop file removed."
	finish_log
	exit 0
fi

if ! uci get fstab.piratebox.target > /dev/null 2>&1  ; then
	start_log

	logger "$0 : Doing extendRoot initilization"

	/bin/box_installer.sh -e 2>&1 | logger

	RC=$?
	if [ "$RC" -gt "0" ] ; then
		logger "$0 : An error occured - Stopping process here ; $RC"
		finish_log
		exit $RC
	fi

	finish_log
fi


# Initiates the log facility and starts the installation
if  [ -e /mnt/usb/install/auto_package ]; then

	start_log

	/bin/box_installer.sh -p 2>&1 | logger 


	# Always move the first line only
	head -n 1 $auto_package  >> $auto_package_done

	#Count containing lines, and only shift first to "done"
	package_lines=`cat $auto_package | wc -l`
	if [ "$package_lines" -gt "1" ] ; then
		logger "$0 : Multiple line auto_package found. Shifting 1st line to auto_package_done"
		tail -n +2 $auto_package > /tmp/auto_install_new
		mv /tmp/auto_install_new $auto_package
	else
		rm $auto_package
	fi


	logger "$0 : Initiating reboot after installation"
	finish_log
	sync && reboot
else
	echo "Does not run because /mnt/usb/install/auto_package  does not exists"
fi


