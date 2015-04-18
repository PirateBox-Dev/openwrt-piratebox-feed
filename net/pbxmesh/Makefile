include $(TOPDIR)/rules.mk

PKG_NAME:=piratebox-mesh
PKG_VERSION:=1.1.2
PKG_RELEASE:=2

PKG_BUILD_DIR:=$(BUILD_DIR)/PirateBox-Mesh-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/PirateBox-Dev/PirateBox-Mesh/archive/
PKG_MD5SUM:=d0fecc8400f1b7757d52ea933a49289b
PKG_CAT:=zcat

include $(INCLUDE_DIR)/package.mk

define Package/pbxmesh
  SECTION:=utils
  CATEGORY:=Network
  TITLE:=Mesh-Integration
  URL:=http://piratebox.cc
  PKGARCH:=all
  SUBMENU:=PirateBox
  DEPENDS:=+kmod-batman-adv +wireless-tools +iptables-mod-extra
  MAINTAINER:=Matthias Strubel <matthias.strubel@aod-rpg.de>
endef

define Package/pbxmesh/description
  Description: Installs script for implementing B.A.T.M.A.N. adv on openwrt. It does not use the in build configurations, because the same script runs on other hardware too.
endef

define Package/pbxmesh/postinst
endef

define Package/pbxmesh/preinst
endef

define Package/pbxmesh/prerm
	#!/bin/sh
	. /etc/mesh.config
	. /usr/share/mesh/mesh.common
	rm $IPV4_IP_SAVE

	/etc/init.d/mesh disable
	/etc/init.d/mesh stop

	openwrt_preremove
endef

define Build/Compile
endef

define Build/Configure
endef

define Package/pbxmesh/install
	$(INSTALL_DIR) $(1)/usr/share/mesh
	$(INSTALL_DIR) $(1)/etc/init.d

	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/data/usr/share/mesh/mesh.common $(1)/usr/share/mesh/mesh.common
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/data/etc/mesh.config $(1)/etc/mesh.config
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/data/etc/init.d/mesh $(1)/etc/init.d/mesh
endef

$(eval $(call BuildPackage,pbxmesh))
