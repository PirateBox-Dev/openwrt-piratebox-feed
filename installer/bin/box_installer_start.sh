#!/bin/sh

# Initiates the log facility and starts the installation

syslogd -L -R 192.168.1.2:9999
/bin/box_installer.sh 2>&1 | logger 
