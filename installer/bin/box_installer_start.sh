#!/bin/sh

# Initiates the log facility and starts the installation

if [ ! -e /etc/auto_install_done ] ; then
	syslogd -L -R 192.168.1.2:9999
	/bin/box_installer.sh 2>&1 | logger 
	# create the file always
	touch /etc/auto_install_done
else
	echo "not running auto installation because  /etc/auto_install_done exists"
fi

