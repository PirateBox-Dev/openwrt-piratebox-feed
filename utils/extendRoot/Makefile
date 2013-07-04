include $(TOPDIR)/rules.mk

PKG_NAME:=extendRoot
PKG_VERSION:=0.1.13
PKG_RELEASE:=3


include $(INCLUDE_DIR)/package.mk

define Package/extendRoot/Default
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=extendRoot
  URL:=http://piratebox.aod-rpg.de/dokuwiki/doku.php/extendRoot
  PKGARCH:=all
  MAINTAINER:=Matthias Strubel <matthias.strubel@aod-rgp.de>
#  SUBMENU:=
endef

define Package/extendRoot
  $(call Package/extendRoot/Default)
  DEPENDS:= +kmod-usb2 +kmod-usb-storage +kmod-fs-vfat +kmod-nls-cp437 +kmod-nls-cp850 +kmod-nls-iso8859-1 +kmod-nls-iso8859-15 +kmod-fs-ext4 +block-mount +kmod-loop +losetup 
  MENU:=1
endef

define Package/extendRoot/description
  Creates and extend-mount-point on USB-SDA1
endef

define Package/extendRoot-python
  $(call Package/extendRoot/Default)
  TITLE:=Python on extendRoot
  DEPENDS:=extendRoot +python
endef

define Package/extendRoot-lighttpd
  $(call Package/extendRoot/Default)
  TITLE:=Lighttpd on extendRoot
  DEPENDS:=extendRoot +lighttpd
endef

define Package/extendRoot-piratebox
   $(call Package/extendRoot/Default)
   TITLE:=PirateBox on extendRoot
   DEPENDS:=extendRoot +extendRoot-lighttpd +extendRoot-python +piratebox
endef

define Package/extendRoot-piratebox/description
   not valid as a direct install on root. 
   run opkg -d ext install extendRoot-piratebox
   that creates a fully linked installation of all needed packages from extended root mount pointing into the normal firmware
endef

define Package/extendRoot-python/description
   not valid as a direct install on root.
   if you install extendRoot-python to your installaiton destiniation, it does everything needed to link the needed files to the places needed by
   the dependend package
endef


define Package/extendRoot-lighttpd/description
   not valid as a direct install on root.
   if you install extendRoot-python to your installaiton destiniation, it does everything needed to link the needed files to the places needed by
   the dependend package
endef

define Package/extendRoot/postinst
	#!/bin/sh

	. $$PKG_ROOT/etc/ext.config
	# run initialisation only  if /tmp/ext_auto_install exists
	if [ -e $$ext_auto_install  ] ; then
	   echo "Run init because $$ext_auto_install exists "
	   /etc/init.d/ext init
	   exit $$?
	fi
	exit 0
endef

define Package/extendRoot/prerm
	#!/bin/ssh
	#/etc/init.d/ext deinstall
endef


define Build/Compile
endef

define Build/Configure
endef


define Package/extendRoot-python/postinst
	#!/bin/sh
	#start the init from piratebox scripts
	. /etc/ext.config
	ln -s $$ext_linktarget/usr/bin/python /usr/bin/
	ln -s $$ext_linktarget/usr/lib/python* /usr/lib/
	exit 0
endef

define Package/extendRoot-python/prerm
	rm /usr/bin/python
	rm /usr/bin/python* 
endef


define Package/extendRoot-lighttpd/postinst
	#!/bin/sh
	#start the init from piratebox scripts
	. /etc/ext.config
	ln -s $$ext_linktarget/usr/sbin/lighttpd  /usr/sbin/lighttpd
    	ln -s $$ext_linktarget/usr/lib/lighttpd  /usr/lib/lighttpd
	ln -s $$ext_linktarget/etc/init.d/lighttpd /etc/init.d/lighttpd
	exit 0
endef

define Package/extendRoot-lighttpd/prerm
	rm /usr/sbin/lighttpd
	rm /usr/lib/lighttpd
	rm /etc/init.d/lighttpd
endef
 
define Package/extendRoot/install
	$(INSTALL_DIR) $(1)/usr/share/ext
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/usr/share/ext/* $(1)/usr/share/ext/
	$(INSTALL_BIN) ./files/etc/init.d/* $(1)/etc/init.d/
	$(INSTALL_BIN) ./files/etc/ext.config $(1)/etc/
endef

define BuildPlugin
  define Package/$(1)/install
	$(INSTALL_DIR) $(1)/tmp/ext
	$(INSTALL_BIN) ./files/spacer $(1)/tmp/ext/spacer
  endef
  $$(eval $$(call BuildPackage,$(1)))
endef

$(eval $(call BuildPackage,extendRoot))
$(eval $(call BuildPlugin,extendRoot-python))
$(eval $(call BuildPlugin,extendRoot-lighttpd))
$(eval $(call BuildPlugin,extendRoot-piratebox))
