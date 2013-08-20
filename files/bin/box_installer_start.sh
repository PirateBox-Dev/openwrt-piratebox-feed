#!/bin/sh


PID=/var/run/auto_syslogd

# Initiates the log facility and starts the installation
if [  -e /mnt/usb/install/auto_package ] || [ !  /etc/init.d/ext enabled ] ; then
	start-stop-daemon -b -S -m -p $PID -x syslogd -- -n -L -R 192.168.1.2:9999
	/bin/box_installer.sh 2>&1 | logger 
	# create the file always
	mv /mnt/usb/install/auto_package  /mnt/usb/install/auto_package_done
	logger "Initiating reboot after installation"
	reboot
else
	echo "Does not run because /mnt/usb/install/auto_package  does not exists"
fi

