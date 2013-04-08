include $(TOPDIR)/rules.mk

PKG_NAME:=piratebox-mod-imageboard
PKG_VERSION:=0.0.1
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/piratebox-mod-imageboard-$(PKG_VERSION)

#####PKG_CAT:=zcat
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/mod-imageboard
  SECTION:=net
  CATEGORY:=Network
  TITLE:=imageboard
  SUBMENU:=PirateBox
  #DESCRIPTION:=This variable is obsolete. use the Package/name/description define instead!
  URL:=http://piratebox.aod-rpg.de
  DEPENDS:=+perl +perlbase-base   +perlbase-cgi  +perlbase-essential  +perlbase-file  +perlbase-bytes  +perlbase-config   +perlbase-data  +perlbase-db-file   +perlbase-digest +perlbase-encode  +perlbase-encoding  +perlbase-fcntl  +perlbase-gdbm-file  +perlbase-integer  +perlbase-socket  +perlbase-time  +perlbase-unicode  +perlbase-unicore  +perlbase-utf8  +perlbase-xsloader  +unzip
endef

define Package/mod-imageboard/description
   not valid as a direct install.
   Installs the needed packages and configurations to enhance the piratebox imageboard stuff
endef

define Package/postinst
        #stuff needed because there is no ext-perl package
	ln -s /usr/local/bin/perl /usr/bin/perl
	ln -s /usr/local/lib/perl* /usr/lib/
	#start the init from piratebox scripts
        . /etc/piratebox.config
	$pb_pbmount/bin/install_piratebox.sh  "$pb_piratebox_conf"  imageboard
endef

$(eval $(call BuildPackage,mod-imageboard))
