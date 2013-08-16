include $(TOPDIR)/rules.mk

PKG_NAME:=librarybox
PKG_VERSION:=2.0.0
PKG_RELEASE:=13


include $(INCLUDE_DIR)/package.mk

define Package/librarybox
  SECTION:=net
  CATEGORY:=Network
  TITLE:=LibraryBox-Main package
  SUBMENU:=PirateBox
  URL:=http://www.librarybox.us
  DEPENDS:= +python +lighttpd +lighttpd-mod-cgi +lighttpd-mod-redirect +lighttpd-mod-alias +lighttpd-mod-setenv +lighttpd-mod-fastcgi +php5-cgi +zoneinfo-core +zoneinfo-simple +php5-mod-json  +php5-mod-sqlite3 +php5-mod-pdo-sqlite +php5-mod-sqlite +php5-mod-pdo +proftpd
  PKGARCH:=all
  MAINTAINER:=Matthias Strubel <matthias.strubel@aod-rpg.de>
endef

define Package/librarybox/description
	Turns your OpenWRT Router into a LibraryBox; see http://www.librarybox.us
	LibraryBox is a PirateBox Fork
endef


define Package/librarybox/postinst
	#!/bin/sh
	##------ Preparerations for /mnt/ext dependencies
	if [ ! -e /etc/init.d/piratebox ] ; then
	   ln -s $$PKG_ROOT/etc/init.d/piratebox /etc/init.d/
	fi

	if [ ! -e /etc/piratebox.config ] ; then
	   ln -s $$PKG_ROOT/etc/piratebox.config /etc
	fi

	if [ ! -e /etc/auto.config ] ; then
	   ln -s $$PKG_ROOT/etc/auto.config /etc
	fi

	# include PirateBox shared functionality
	. $$PKG_ROOT/usr/share/piratebox/piratebox.common
	. $$PKG_ROOT/etc/piratebox.config

	# disable web interface, start PirateBox instead
	# Only disable if installed!
	if [ -e /etc/init.d/uhttpd ] ; then 
	   echo "Stopping uttpd and disable it"
	   /etc/init.d/uhttpd stop
	   /etc/init.d/uhttpd disable
	fi

	if [ -e /etc/init.d/luci_fixtime ] ; then
	   echo "Stopping luci_fixtime and disable it"
	  /etc/init.d/luci_fixtime stop
	  /etc/init.d/luci_fixtime disable
	fi

	if [ -e /etc/init.d/luci_dhcp_migrate ] ; then
	  /etc/init.d/luci_dhcp_migrate stop
	  /etc/init.d/luci_dhcp_migrate disable
	fi

	if [ -e /etc/init.d/dnsmasq ] ; then
	   /etc/init.d/dnsmasq stop
	   /etc/init.d/dnsmasq disable
	fi

	if [ -e /etc/init.d/watchdog ] ; then
		/etc/init.d/watchdog stop
		/etc/init.d/watchdog disable
	fi

	##only do network config etc, when first install
	setup_run=0
	if [ ! -e  $$pb_inst_done ]  ; then
	    # configure USB, network
	     /etc/init.d/piratebox setup
	     [ $$? -ne 0 ] && exit 99
	     setup_run=1
	fi
	# prepare USB partition and install PirateBox
	/etc/init.d/piratebox init
	[ $$? -ne 0 ] && exit 99
	# start PirateBox service
	/etc/init.d/piratebox enable 
	/etc/init.d/piratebox start
	
	echo "Bringing PirateBox down again and leave image mounted"
 	echo " for further installation"
	/etc/init.d/piratebox  stop_keep
 
	if [ $$setup_run  -eq 1 ] ; then
	  # give some user feedback
	  echo ""
  	  echo "PirateBox wireless SSID: $$pb_wireless_ssid "
	  echo "PirateBox DNS and hostname: $$pb_hostname "
   	  echo "  hostname with unique suffix is: "  `uci get system.@system[0].hostname`
   	  echo "PirateBox LAN IP address: $$pb_ip"
   	  echo "PirateBox shared directory: $$pb_share"
	  echo
   	  echo "Setup complete, PirateBox started."
   	  echo "You can remove the WAN connection now."
   	  echo "Please reboot your PirateBox now: "
   	  echo "   # reboot "
	fi
	echo "Done"
endef

define Package/librarybox/preinst
	#!/bin/sh
	#Disable Piratebox, it it seems that it is installed
	if [ -e  /etc/init.d/piratebox  ] ; then
	   /etc/init.d/piratebox stop
	fi

	exit 0
endef

define Build/Compile
endef

define Build/Configure
endef


define Package/librarybox/install
	$(INSTALL_DIR) $(1)/usr/share/piratebox
	$(INSTALL_DIR) $(1)/etc/	
	$(INSTALL_DIR) $(1)/etc/init.d
<<<<<<< HEAD
	$(INSTALL_BIN) ./files/usr/share/piratebox/piratebox.common  $(1)/usr/share/piratebox/piratebox.common
	$(INSTALL_BIN) ./files/usr/share/piratebox/autoconfig.common $(1)/usr/share/piratebox/autoconfig.common
	$(INSTALL_BIN) ./files/etc/piratebox.config 	$(1)/etc/piratebox.config
	$(INSTALL_BIN) ./files/etc/auto.config 		$(1)/etc/auto.config
	$(INSTALL_BIN) ./files/etc/init.d/piratebox 	$(1)/etc/init.d/piratebox
=======
	$(INSTALL_BIN) ./files/usr/share/piratebox/piratebox.common $(1)/usr/share/piratebox/piratebox.common
	$(INSTALL_BIN) ./files/usr/share/piratebox/timesave.common  $(1)/usr/share/piratebox/timesave.common
	$(INSTALL_BIN) ./files/etc/piratebox.config $(1)/etc/piratebox.config
	$(INSTALL_BIN) ./files/etc/init.d/piratebox $(1)/etc/init.d/piratebox
>>>>>>> timesave_fix
endef

$(eval $(call BuildPackage,librarybox))
