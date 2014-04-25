#!/bin/sh

#   Auto Install script for LibraryBox.
#     Installs the one listed package from auto_package to ext-install

INSTALL_PACKAGE_FILE=/mnt/usb/install/auto_package

CACHE_LOCATION="/mnt/usb/install/cache"
INSTALL_DESTINATION="-d ext"

OPKG="opkg --cache $CACHE_LOCATION "
OPKG_DEST="$OPKG $INSTALL_DESTINATION "

NEXT_STEP="run_test"
ALL_STEPS="yes"

LED_EXTENDROOT=/sys/class/leds/*wlan
LED_PACKAGE=/sys/class/leds/*[usb,3g]



_signaling_start(){
	if [ -e $1/trigger ] ; then
		for file in  $1 ; do echo "timer" > $file/trigger ; done
	fi
	return 0
}

_signaling_stop(){
	if [ -e $1/trigger ] ; then
		echo "none" > $1/trigger
		for file in  $1 ; do echo "none" > $file/trigger ; done
	fi
	[ -e $1/brightness ] && for file in  $1 ; do echo "1" > $file/brightness ; done
	return 0
}

calc_next_step() {

	case $NEXT_STEP in

	 'run_test') NEXT_STEP="run_signaling_extendRoot_start" ;;
	 'run_signaling_extendRoot_start') NEXT_STEP="run_prepare_extendRoot" ;;
	 'run_prepare_extendRoot') NEXT_STEP="run_init_extendRoot" ;;
	 'run_init_extendRoot') NEXT_STEP="run_signaling_extendRoot_stop" ;;
	 'run_signaling_extendRoot_stop') NEXT_STEP="run_fake_opkg_update" ;;
	 'run_fake_opkg_update') NEXT_STEP="run_signaling_package_start" ;;
	 'run_signaling_package_start') NEXT_STEP="run_install_package" ;;
	 'run_install_package') NEXT_STEP="run_signaling_package_stop" ;;
	 'run_signaling_package_stop') NEXT_STEP="exit" ;;
	 *) echo "$0 : unknown previous step..exiting"
	    exit 255 ;;
	esac
}

run_test() {
	#This section includes some tests to ensure everything is as we need it
	echo "$0 : Testing requirements..."
	if   lsmod | grep -q usb_storage ; then
		echo "$0 : .. USB storage modules available"
	else
		echo "$0 : No usb-storage storage modules detected..exit"
		exit 255
	fi
	if opkg list-installed extendRoot | grep -q extendRoot ; then
		echo "$0 : extendRoot package is installed"
	else
		echo "$0 : extendRoot not available, exiting"
		exit 255
	fi
}


run_signaling_extendRoot_start(){
	#Switch wlan-light online, that extendRoot init is running
	_signaling_start  "$LED_EXTENDROOT"
	return 0
}

run_prepare_extendRoot(){
	#sets flags for installation of extendRoot to prevent the package asking the user
	echo "$0 : configure initi step for extendRoot"
	. /etc/ext.config
	touch  $ext_force_ext_overwrite
	[ $? ] || exit $?
}

run_init_extendRoot() {
	if  /etc/init.d/ext enabled  ; then
		echo "$0 : not running extendRoot init, because it already is"
		return 0
	fi
	/etc/init.d/ext init
	[ $? ] || exit $?
	echo "$0 : Fixing paths"
	/bin/ext_path_fixer
}

# Signalize with a steady wifi light, that extendRoot initialization is done
run_signaling_extendRoot_stop(){
	_signaling_stop "$LED_EXTENDROOT"
}

run_fake_opkg_update() {
	echo "$0 : Getting main Repository from /etc/opkg.conf"
	local repo=$(head -n1 /etc/opkg.conf  | cut -d ' ' -f 2)
	echo "$0 : Doing fake opkg update (copy from cache folder ($repo)"
	cp $CACHE_LOCATION/Package.gz_main /var/opkg-lists/$repo
	[ $? ] || exit $?
	echo "$0 : .. doing it for Piratebox repository (optional)"
	cp $CACHE_LOCATION/Package.gz_piratebox /var/opkg-lists/piratebox
}

run_signaling_package_start(){
	#Blinking 3g/USB LED 
	_signaling_start "$LED_PACKAGE"
}

run_install_package(){
	# This can only happen if extendRoot is not initialized 
	#  and the auto-install file is not on the USB Stick
	if [ ! -e $INSTALL_PACKAGE_FILE ] ; then
		echo "$0 : ERROR: $INSTALL_PACKAGE_FILE is not set"
		exit 255
	fi

	INSTALL_PACKAGE=`head -n 1 $INSTALL_PACKAGE_FILE`
	echo "$0 : Installing packge $INSTALL_PACKAGE "
	$OPKG_DEST install $INSTALL_PACKAGE
	[ $? ] || exit $?
}

run_signaling_package_stop(){
        #Blinking 3g/USB LED 
        _signaling_stop "$LED_PACKAGE"
}



# Implement and option to process single steps
if [ ! -z $1 ] ; then
	ALL_STEPS="no"
	[ !-z $2 ] && ALL_STEPS="yes"  #resume
	NEXT_STEP="$1"
fi

while true; do
    echo "$0 : executing $NEXT_STEP"
    $NEXT_STEP

    if [ "$ALL_STEPS" = "yes" ] ; then
    	echo "$0 : Trying to find next step"
	calc_next_step 
    else
    	echo "$0 : exiting because we run only one step"
    	exit $?
    fi
done

