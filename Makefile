include $(TOPDIR)/rules.mk

PKG_NAME:=pbxopkg
PKG_VERSION:=0.1.1
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
  if [ -e $$PKG_ROOT/etc/opkg.conf ]; then
    if grep '[ \t]*src/gz[ \t]*piratebox[ \t]*' $$PKG_ROOT/etc/opkg.conf > /dev/null; then
      exit 0
    else
      echo "src/gz piratebox http://stable.openwrt.piratebox.de/all/packages" >> $$PKG_ROOT/etc/opkg.conf
    fi
  fi
endef

define Package/pbxopkg/preinst
endef

define Package/pbxopkg/prerm
  #!/bin/sh
  sed -i '/src\/gz piratebox.*/d' $$PKG_ROOT/etc/opkg.conf
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
  if [ -e $$PKG_ROOT/etc/opkg.conf ]; then
    if grep '[ \t]*src/gz[ \t]*piratebox[ \t]*' $$PKG_ROOT/etc/opkg.conf > /dev/null; then
      exit 0
    else
      echo "src/gz piratebox http://beta.openwrt.piratebox.de/all/packages" >> $$PKG_ROOT/etc/opkg.conf
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
# This is not allowed to be empty otherwise no ipk will be generated.
endef

define Package/pbxopkg-beta/install
# This is not allowed to be empty otherwise no ipk will be generated.
endef

$(eval $(call BuildPackage,pbxopkg))
$(eval $(call BuildPackage,pbxopkg-beta))
