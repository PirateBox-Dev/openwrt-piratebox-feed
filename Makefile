include $(TOPDIR)/rules.mk
PKG_NAME:=box-installer
PKG_VERSION:=0.0.1
PKG_RELEASE:=2

include $(INCLUDE_DIR)/package.mk

#----------- Defaults
define Package/box-installer/Default
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=box-installer Scripts
  URL:=https://github.com/LibraryBox-Dev/LibraryBox-Installer/
  PKGARCH:=all
  MAINTAINER:=Matthias Strubel <matthias.strubel@aod-rpg.de>
#  SUBMENU:=
endef

define Package/box-installer/Default/description
  See https://github.com/LibraryBox-Dev/LibraryBox-Installer/ for more information.   (Script is responsible for some kind of auto installation) 
endef


define Package/box-installer/postinst/Default
    #!/bin/sh
    sed 's|^exit|#exit|' -i /etc/rc.local
    echo '/bin/box_installer_start.sh'
endef

define Package/box-installer/prerm/Default
   #!/bin/sh
   sed 's|/bin/box_installer_start.sh||' -i  -i /etc/rc.local
endef

define Package/box-installer/install/Default
	$(INSTALL_DIR)  $(1)/bin
	$(INSTALL_BIN)  ./files/bin/box_installer.sh $(1)/bin
	$(INSTALL_BIN)  ./files/bin/box_installer_start.sh  $(1)/bin
endef

#---------- Base Package
define Package/box-installer
  $(call Package/box-installer/Default)
  DEPENDS:= +extendRoot
#  MENU:=1
endef

define Package/box-installer/description
  $(call  Package/box-installer/Default/description) 
  This package comes without a package which should be installed. It contains only the installer itself
endef

define Package/box-installer/postinst
  $(call Package/box-installer/postinst/Default)
endef

define Package/box-installer/prerm
  $(call Package/box-installer/prerm/Default)
endef

define Package/box-installer/install
  $(call Package/box-installer/install/Default)
endef

#------------------
$(eval $(call BuildPackage,box-installer))
