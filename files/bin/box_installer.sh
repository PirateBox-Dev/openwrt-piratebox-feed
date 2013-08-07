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

calc_next_step() {

	case $NEXT_STEP in

	 'run_test') NEXT_STEP="run_prepare_extendRoot" ;;
	 'run_prepare_extendRoot') NEXT_STEP="run_init_extendRoot" ;;
	 'run_init_extendRoot') NEXT_STEP="run_fake_opkg_update" ;;
	 'run_fake_opkg_update') NEXT_STEP="run_install_package" ;;
	 'run_install_package') NEXT_STEP="exit" ;;
	 *) echo "unknown previous step..exiting"
	    exit 255 ;;
	esac
}

run_test() {
	#This section includes some tests to ensure everything is as we need it
	echo "Testing requirements..."
	if   lsmod | grep -q usb_storage ; then
		echo ".. USB storage modules available"
	else
		echo "No usb-storage storage modules detected..exit"
		exit 255
	fi
	if opkg list-installed extendRoot | grep -q extendRoot ; then
		echo "extendRoot package is installed"
	else
		echo "extendRoot not available, exiting"
		exit 255
	fi
}

run_prepare_extendRoot(){
	#sets flags for installation of extendRoot to prevent the package asking the user
	echo "configure initi step for extendRoot"
	. /etc/ext.config
	touch  $ext_force_ext_overwrite
	[ $? ] || exit $?
}

run_init_extendRoot() {
	if [ /etc/init.d/ext enabled ] ; then
		echo "not running extendRoot init, because it already is"
		exit 0
	fi
	/etc/init.d/ext init
	[ $? ] || exit $?
	echo "Fixing paths"
	/bin/ext_path_fixer
}

run_fake_opkg_update() {
	echo "Doing fake opkg update (copy from cache folder (AA)"
	cp $CACHE_LOCATION/Package.gz_attitude_adjustment /var/opkg-lists/attitude_adjustment
	[ $? ] || exit $?
	echo ".. doing it for Piratebox repository (optional)"
	cp $CACHE_LOCATION/Package.gz_piratebox /var/opkg-lists/piratebox
}

run_install_package(){
	INSTALL_PACKAGE=`head -n 1 $INSTALL_PACKAGE_FILE`
	echo "Installing packge $INSTALL_PACKAGE "
	$OPKG_DEST install $INSTALL_PACKAGE
	[ $? ] || exit $?
}

# Implement and option to process single steps
if [ ! -z $1 ] ; then
	ALL_STEPS="no"
	[ !-z $2 ] && ALL_STEPS="yes"  #resume
	NEXT_STEP="$1"
fi

if [ ! -e $INSTALL_PACKAGE_FILE ] ; then
	echo "ERROR: $INSTALL_PACKAGE_FILE is not set"
	exit 255
fi

while true; do
    echo "executing $NEXT_STEP"
    $NEXT_STEP

    if [ "$ALL_STEPS" = "yes" ] ; then
    	echo "Trying to find next step"
	calc_next_step 
    else
    	echo "exiting because we run only one step"
    	exit $?
    fi
done

