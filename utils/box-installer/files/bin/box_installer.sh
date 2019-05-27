#!/bin/sh

#   Auto Install script for LibraryBox.
#     Installs the one listed package from auto_package to ext-install

INSTALL_PACKAGE_FILE=/mnt/usb/install/auto_package

CACHE_LOCATION="/mnt/usb/install/cache"
INSTALL_DESTINATION="-d ext"


OPKG="opkg --cache $CACHE_LOCATION "
OPKG_CONFIG_NOSIG="/tmp/opkg_nosig.conf"
OPKG_CONFIG="-f $OPKG_CONFIG_NOSIG"
OPKG_DEST="$OPKG $OPKG_CONFIG $INSTALL_DESTINATION "

NEXT_STEP="run_test"
ALL_STEPS="yes"
DO_PACKAGE="no"
DO_EXT="no"


LED_EXTENDROOT=/sys/class/leds/*wlan
LED_PACKAGE_1=/sys/class/leds/*3g
LED_PACKAGE_2=/sys/class/leds/*usb



_signaling_start(){
	for file in  $1 ; do echo "timer" > $file/trigger ; done
	return 0
}

_signaling_stop(){
	for file in  $1 ; do echo "none" > $file/trigger ; done
	for file in  $1 ; do echo "1" > $file/brightness ; done
	return 0
}

calc_next_step() {

	case $NEXT_STEP in

	 'run_test') NEXT_STEP="run_signaling_extendRoot_start" ;;
	 'run_signaling_extendRoot_start') NEXT_STEP="run_prepare_extendRoot" ;;
	 'run_prepare_extendRoot') NEXT_STEP="run_init_extendRoot" ;;
	 'run_init_extendRoot') NEXT_STEP="run_signaling_extendRoot_stop" ;;

	 'run_signaling_extendRoot_stop') 
			if [ "$DO_PACKAGE" = "yes" ] ; then
				NEXT_STEP="run_test_installation_destination" 
			else
				NEXT_STEP="exit"
			fi 	;;
	 'run_test_installation_destination') NEXT_STEP='run_fake_opkg_update' ;;
	 'run_fake_opkg_update') NEXT_STEP="run_opkg_disable_sig_config" ;;
	 'run_opkg_disable_sig_config') NEXT_STEP="run_signaling_package_start" ;;
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
	if  uci get fstab.piratebox.target > /dev/null 2>&1  ; then
		echo "$0 : not running extendRoot init, because it already is"
		return 0
	fi
	/etc/init.d/ext init
	[ $? ] || exit $?

}

# Signalize with a steady wifi light, that extendRoot initialization is done
run_signaling_extendRoot_stop(){
	_signaling_stop "$LED_EXTENDROOT"
}

run_test_installation_destination(){
	echo "$0 : Testing if installation destination by extendRoot is available."
	/etc/init.d/ext is_ready && OK="yes"
	if [ "$OK" = "yes"  ] ; then
		echo "$0 : Installation destination is available."
	else
		echo "$0 : Something happend to extendRoot filesystem. Printing debug output..."
		echo "$0 : Mount output"
		mount
		echo "$0 : dmesg | grep sd "
		dmesg | grep sd
		echo "$0 : dmesg | grep loop"
		dmesg | grep loop
		echo "$0 : dmesg | grep ext"
		dmesg | grep ext
		echo "$0 : Exiting box-installer routine"
		exit 255
	fi 
}


run_fake_opkg_update() {
	echo "$0 : Creating opkg-lists folder, if missing"
	mkdir -p /var/opkg-lists
    cd "$CACHE_LOCATION"
    ls -1 Package.gz_* > /tmp/repofiles
    while read repofile ; do
       repo=$( echo "$repofile" | sed -e 's|Packages.gz_||' )
       echo "$0 : Doing fake opkg update (copy from cache folder ($repo))"
	   cp "$CACHE_LOCATION/$repofile" "/var/opkg-lists/$repo" && \
           cp "$CACHE_LOCATION/Packages.sig_$repo" "/var/opkg-lists/${repo}.sig"
	   [ $? ] || exit $?
    done < /tmp/repofiles
}

run_opkg_disable_sig_config(){
    echo "$0: Create custom opkg.conf ${OPKG_CONFIG_NOSIG} with signature check"
    sed -e 's|option check_signature 1||'  /etc/opkg.conf > "${OPKG_CONFIG_NOSIG}"
    sed -i 's|option check_signature||'  "${OPKG_CONFIG_NOSIG}"
}

run_signaling_package_start(){
	#Blinking 3g/USB LED 
	_signaling_start "$LED_PACKAGE_1"
	_signaling_start "$LED_PACKAGE_2"
}

run_install_package(){
	# This can only happen if extendRoot is not initialized 
	#  and the auto-install file is not on the USB Stick
	if [ ! -e $INSTALL_PACKAGE_FILE ] ; then
		echo "$0 : ERROR: $INSTALL_PACKAGE_FILE is not set"
		exit 255
	fi

	echo "$0 : Fixing paths"
	/bin/ext_path_fixer

	INSTALL_PACKAGE=`head -n 1 $INSTALL_PACKAGE_FILE`
	echo "$0 : Installing packge $INSTALL_PACKAGE "
	$OPKG_DEST install $INSTALL_PACKAGE
	[ $? ] || exit $?
}

run_signaling_package_stop(){
        #Blinking 3g/USB LED 
        _signaling_stop "$LED_PACKAGE_1"
        _signaling_stop "$LED_PACKAGE_2"
}



# Implement and option to process single steps
usage(){
echo " Auto installer core script.

Use the following parameter to trigger actions
    -e          : extendRoot init only
    -p          : install auto package file
    -n <step>   : resume with step
    -o          : resume only named step

one of -e or -p is required.
";
exit 1
}

while getopts ":epon:" opt; do
	case "${opt}" in
		n) NEXT_STEP="${OPTARG}" ;;
		p) DO_PACKAGE="yes" ;;
		e) DO_EXT="yes" ;;
		o) ALL_STEPS="no";;
		?) usage ;;
	esac
done

if [ "$DO_EXT" = "no" ] && [ "$DO_PACKAGE" = "no" ] ; then
	usage
fi

## Default parameter starts with extendRoot 
##   and ends after it init, when DO_PACKAGE=no

if [ "$DO_EXT" = "no" ] && [ "$DO_PACKAGE" = "yes" ]  ; then 
	NEXT_STEP="run_test_installation_destination"
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

