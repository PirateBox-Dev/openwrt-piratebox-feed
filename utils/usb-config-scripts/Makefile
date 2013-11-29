include $(TOPDIR)/rules.mk

PKG_NAME:=usb-config-scripts
PKG_VERSION:=0.3.0
PKG_RELEASE:=7

PKG_BUILD_DIR:=$(BUILD_DIR)/usb-config-scripts-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/LibraryBox-Dev/usb-config-scripts/archive/
PKG_MD5SUM:=89d292a3b3b717b5bbc3cd8cf4a1d790
PKG_CAT:=zcat


include $(INCLUDE_DIR)/package.mk

define Package/usb-config-scripts
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Scripts for USB-Config files
  SUBMENU:=PirateBox
  URL:=http:///github.com/MaStr/usb-config-scripts
  DEPENDS:=
  PKGARCH:=all
  MAINTAINER:=Matthias Strubel <matthias.strubel@aod-rpg.de>
endef

define Package/usb-config-scripts-librarybox
  $(call Package/usb-config-scripts)
  TITLE+= with customizations for LibraryBox
endef 

define Package/usb-config-scripts/description
	Helps easier configuration via simple files on USB Stick for i.e. LibraryBox
endef




define Package/usb-config-scripts/postinst
endef


define Package/usb-config-scripts-librarybox/postinst
	#!/bin/sh
	echo "Linking used modules"
	ln -s ../modules.available/10_openwrt_ssid.sh $$PKG_ROOT/opt/autocfg/modules.enabled
	ln -s ../modules.available/11_openwrt_txpower.sh $$PKG_ROOT/opt/autocfg/modules.enabled
	ln -s ../modules.available/12_openwrt_channel.sh $$PKG_ROOT/opt/autocfg/modules.enabled
	ln -s ../modules.available/13_openwrt_hostname.sh $$PKG_ROOT/opt/autocfg/modules.enabled
	ln -s ../modules.available/60_librarybox_ftp.sh $$PKG_ROOT/opt/autocfg/modules.enabled
	ln -s ../modules.available/60_librarybox_ftpadmin.sh $$PKG_ROOT/opt/autocfg/modules.enabled
	ln -s ../modules.available/60_librarybox_ftpanon.sh $$PKG_ROOT/opt/autocfg/modules.enabled
	ln -s ../modules.available/60_librarybox_ftpsync.sh $$PKG_ROOT/opt/autocfg/modules.enabled
	ln -s ../modules.available/60_librarybox_ftpsyncport.sh $$PKG_ROOT/opt/autocfg/modules.enabled
	ln -s ../modules.available/61_librarybox_shoutbox.sh $$PKG_ROOT/opt/autocfg/modules.enabled
	#- default piratebox
	ln -s ../modules.available/50_piratebox_hostname.sh $$PKG_ROOT/opt/autocfg/modules.enabled
endef

define Build/Compile
endef

define Build/Configure
endef


define Package/usb-config-scripts/install
	$(INSTALL_DIR) $(1)/opt/autocfg
	$(INSTALL_DIR) $(1)/opt/autocfg/{bin,conf,lib}
	$(INSTALL_DIR) $(1)/opt/autocfg/modules.{available,enabled}
	$(INSTALL_DIR) $(1)/etc/init.d

	$(INSTALL_BIN) ./files/etc/init.d/autocfg  	$(1)/etc/init.d/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/* 	$(1)/opt/autocfg/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/conf/* 	$(1)/opt/autocfg/conf/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/lib/* 	$(1)/opt/autocfg/lib/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/modules.available/* 	$(1)/opt/autocfg/modules.available/
endef


Package/usb-config-scripts-librarybox/install = $(Package/usb-config-scripts/install)

$(eval $(call BuildPackage,usb-config-scripts))
$(eval $(call BuildPackage,usb-config-scripts-librarybox))

