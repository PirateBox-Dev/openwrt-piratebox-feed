include $(TOPDIR)/rules.mk

PKG_NAME:=pbxopkg
PKG_VERSION:=0.2.1
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/pbxopkg/Default
  SECTION:=utils
  CATEGORY:=Network
  TITLE:=Repository-Integration
  URL:=http://piratebox.cc
  PKGARCH:=all
  SUBMENU:=PirateBox
  MAINTAINER:=Matthias Strubel <matthias.strubel@aod-rpg.de>
endef

define Package/pbxopkg
  $(call Package/pbxopkg/Default)
endef

define Package/pbxopkg/description
  Adds PirateBox OpenWRT Package-Tree to opkg.conf
endef

define Package/pbxopkg/postinst
  #!/bin/sh
  if [ -e $${IPKG_INSTROOT}/etc/opkg/customfeeds.conf ]; then
    if grep '[ \t]*src/gz[ \t]*piratebox[ \t]*' $${IPKG_INSTROOT}/etc/opkg/customfeeds.conf  > /dev/null; then
      exit 0
    else
      echo "src/gz piratebox http://stable.openwrt.piratebox.de/all/packages" >> $${IPKG_INSTROOT}/etc/opkg/customfeeds.conf
    fi
  fi
endef

define Package/pbxopkg/preinst
endef

define Package/pbxopkg/prerm
  #!/bin/sh
  sed -i '/src\/gz piratebox.*/d' $${IPKG_INSTROOT}/etc/opkg/customfeeds.conf
endef

define Package/pbxopkg-beta
  $(call Package/pbxopkg/Default)
  SUBMENU:=PirateBox
  TITLE:=Repository-Integration (BETA)
endef

define Package/pbxopkg-beta/description
  Adds the beta PirateBox OpenWRT Package-Tree to opkg.conf
endef

define Package/pbxopkg-beta/postinst
  #!/bin/sh
  if [ -e $${IPKG_INSTROOT}/etc/opkg/customfeeds.conf ]; then
    if grep '[ \t]*src/gz[ \t]*piratebox[ \t]*' $${IPKG_INSTROOT}/etc/opkg/customfeeds.conf > /dev/null; then
      exit 0
    else
      echo "src/gz piratebox http://beta.openwrt.piratebox.de/all/packages" >> $${IPKG_INSTROOT}/etc/opkg/customfeeds.conf
    fi
  fi
endef

define Package/pbxopkg-beta/preinst
endef

define Package/pbxopkg-beta/prerm
  $(call Package/pbxopkg/prerm)
endef

define Build/Compile
endef

define Build/Configure
endef

define Package/pbxopkg/install
	$(INSTALL_DIR) $(1)/etc/
	$(INSTALL_DIR) $(1)/etc/opkg
	$(INSTALL_DIR) $(1)/etc/opkg/keys
	$(INSTALL_BIN) ./files/lede_public.key  $(1)/opkg/keys/437dd44386518241 
endef

define Package/pbxopkg-beta/install
	$(INSTALL_DIR) $(1)/etc/
	$(INSTALL_DIR) $(1)/etc/opkg
	$(INSTALL_DIR) $(1)/etc/opkg/keys
	$(INSTALL_BIN) ./files/lede_public.key  $(1)/etc/opkg/keys/437dd44386518241 
endef

$(eval $(call BuildPackage,pbxopkg))
$(eval $(call BuildPackage,pbxopkg-beta))
