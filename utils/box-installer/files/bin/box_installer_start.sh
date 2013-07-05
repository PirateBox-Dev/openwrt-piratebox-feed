#!/bin/sh

# Initiates the log facility and starts the installation
if [  -e /mnt/usb/install/auto_package || !  /etc/init.d/ext enabled ] ; then
	syslogd -L -R 192.168.1.2:9999
	/bin/box_installer.sh 2>&1 | logger 
	# create the file always
	mv /mnt/usb/install/auto_package  /mnt/usb/install/auto_package_done
else
	echo "Does not run because /mnt/usb/install/auto_package  does not exists"
fi

