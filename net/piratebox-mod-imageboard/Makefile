include $(TOPDIR)/rules.mk

PKG_NAME:=piratebox-mod-imageboard
PKG_VERSION:=0.0.1
PKG_RELEASE:=2


include $(INCLUDE_DIR)/package.mk

define Package/piratebox-mod-imageboard
  SECTION:=net
  CATEGORY:=Network
  TITLE:=imageboard modification
  SUBMENU:=PirateBox
  URL:=http://piratebox.aod-rpg.de
  DEPENDS:=piratebox +perl +perlbase-base   +perlbase-cgi  +perlbase-essential  +perlbase-file  +perlbase-bytes  +perlbase-config   +perlbase-data  +perlbase-db-file   +perlbase-digest +perlbase-encode  +perlbase-encoding  +perlbase-fcntl  +perlbase-gdbm-file  +perlbase-integer  +perlbase-socket  +perlbase-time  +perlbase-unicode  +perlbase-unicore  +perlbase-utf8  +perlbase-xsloader  +unzip
  PKGARCH:=all
  MAINTAINER:=Matthias Strubel <matthias.strubel@aod-rgp.de>
endef

define Package/piratebox-mod-imageboard/description
   not valid as a direct install.
   Installs the needed packages and configurations to enhance the piratebox imageboard stuff
endef


define Package/piratebox-mod-imageboard/postinst
        #!/bin/sh
        #stuff needed because there is no ext-perl package
	ln -s /usr/local/bin/perl /usr/bin/perl
	ln -s /usr/local/lib/perl* /usr/lib/
	#start the init from piratebox scripts
        . /etc/piratebox.config
	$$pb_pbmount/bin/install_piratebox.sh  "$$pb_piratebox_conf"  imageboard
       exit 0
endef


define Build/Compile
endef

define Build/Configure
endef


define Package/piratebox-mod-imageboard/install
	$(INSTALL_DIR) $(1)/tmp/imageboard
	$(INSTALL_BIN) ./files/spacer $(1)/tmp/imageboard/spacer
endef

$(eval $(call BuildPackage,piratebox-mod-imageboard))
