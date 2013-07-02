include $(TOPDIR)/rules.mk

PKG_NAME:=extendRoot
PKG_VERSION:=0.1.13
PKG_RELEASE:=1


include $(INCLUDE_DIR)/package.mk

define Package/extendRoot/Default
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=extendRoot
  URL:=http://piratebox.aod-rpg.de/dokuwiki/doku.php/extendRoot
#  SUBMENU:=
endef

define Package/extendRoot
  $(call Package/extendRoot/Default)
  DEPENDS:= +kmod-usb2 +kmod-usb-storage +kmod-fs-vfat +kmod-nls-cp437 +kmod-nls-cp850 +kmod-nls-iso8859-1 +kmod-nls-iso8859-15 +kmod-fs-ext4 +block-mount +kmod-loop +losetup 
  PKGARCH:=all
  MAINTAINER:=Matthias Strubel <matthias.strubel@aod-rgp.de>
  Menu:=1
endef

define Package/extendRoot/description
  Creates and extend-mount-point on USB-SDA1
endef

define Package/extendRoot-python
  $(call Package/extendRoot/Default)
  TITLE:=Python on extendRoot
  DEPENDS:=extendRoot +python
endef

define Package/extendRoot-python/description
   not valid as a direct install.
   if you install extendRoot-python to your installaiton destiniation, it does everything needed to link the needed files to the places needed by
   the dependend package
endef


define Package/extendRoot/postinst
	#!/bin/sh
	. /etc/ext.config
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


define Package/extendRoot-python/description/postinst
	#!/bin/sh
	#start the init from piratebox scripts
	. /etc/ext.config
	ln -s $$ext_linktarget/usr/bin/python /usr/bin/
	ln -s $$ext_linktarget/usr/lib/python* /usr/lib/
i	exit 0
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
