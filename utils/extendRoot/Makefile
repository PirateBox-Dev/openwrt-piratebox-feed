include $(TOPDIR)/rules.mk

PKG_NAME:=extendRoot
PKG_VERSION:=0.5.0
PKG_RELEASE:=1


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

define Package/extendRoot-librarybox
   $(call Package/extendRoot/Default)
   TITLE:=LibraryBox on extendRoot
   DEPENDS:=extendRoot +extendRoot-lighttpd +extendRoot-python +librarybox +extendRoot-php +extendRoot-zoneinfo +extendRoot-proftpd 
endef

define Package/extendRoot-php
   $(call Package/extendRoot/Default)
   TITLE:=PHP on extendRoot
   DEPENDS:=extendRoot +php5 +php5-cli +php5-cgi +php5-mod-gd +php5-mod-json +php5-mod-http +php5-mod-dom +php5-mod-pdo +php5-mod-pdo-sqlite +php5-mod-sqlite +php5-mod-sqlite3 +php5-mod-xml +php5-mod-xmlreader +php5-mod-xmlwriter +php5-mod-zip
endef

define Package/extendRoot-php-fastcgi
    $(call Package/extendRoot/Default)
    TITLE:=PHP-fastcgi server on extendRoot
    DEPENDS:=extendRoot  +php5 +php5-fastcgi
endef

define Package/extendRoot-zoneinfo
    $(call Package/extendRoot/Default)
    TITLE:=zoneinfo-core for PHP applications on extendRoot
    DEPENDS:=+zoneinfo-core 
endef

define Package/extendRoot-proftpd
	$(call Package/extendRoot/Default)
	 TITLE:=proftpd server on extendRoot
	 DEPENDS:=extendRoot
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

define Package/extendRoot-librarybox/description
	not valid as a direct install on root
endef

define Package/extendRoot-php/description
	not valid as a direct install on root
	Installs PHP with a huge bundle of modules
endef

define Package/extendRoot-php-fastcgi/description
 	not valid as a direct install on root
	Installs fastcgi-php 
endef

define Package/extendRoot-zoneinfo/description
	not valid as direct isntall on root
	Installs zoneinfo to extend root and links needed folder
endef

define Package/extendRoot-proftpd/description
	not valid as direct isntall on root
	Installs proftpd to extend root and links needed folder
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

define Package/extendRoot-php/postinst
	#!/bin/sh
	. /etc/ext.config
	ln -s $$ext_linktarget/etc/php.ini /etc
	ln -s $$ext_linktarget/etc/php5 /etc
	ln -s $$ext_linktarget/usr/bin/php-cgi /usr/bin/
	sed  's,extension_dir = \"/usr/lib/php\",extension_dir = \"/usr/local/usr/lib/php\",g' -i /etc/php.ini
	#disable that security feature :/
	sed  's,doc_root,;doc_root,' -i /etc/php.ini
	sed  's,;extension=gd.so,extension=gd.so,g' -i /etc/php.ini
        sed  's,;extension=json.so,extension=json.so,g' -i /etc/php.ini
	sed  's,;extension=dom.so,extension=dom.so,g' -i /etc/php.ini
	sed  's,;extension=pdo.so,extension=pdo.so,g' -i /etc/php.ini
	sed  's,;extension=pdo_sqlite.so,extension=pdo_sqlite.so,g' -i /etc/php.ini
	sed  's,;extension=sqlite.so,extension=sqlite.so,g' -i /etc/php.ini
	sed  's,;extension=sqlite3.so,extension=sqlite3.so,g' -i /etc/php.ini
	sed  's,;extension=xml.so,extension=xml.so,g' -i /etc/php.ini
	sed  's,;extension=xmlreader.so,extension=xmlreader.so,g' -i /etc/php.ini
	sed  's,;extension=xmlwriter.so,extension=xmlwriter.so,g' -i /etc/php.ini
endef

define Package/extendRoot-php/prerm
	#!/bin/sh
	rm /etc/php.ini
	rm /etc/php5
	rm /usr/bin/php-cgi
endef

define Package/extendRoot-php-fastcgi/postinst
	#!/bin/sh
	. /etc/ext.config
	ln -s  $$ext_linktarget/etc/config/php5-fastcgi /etc/config/
	ln -s  $$ext_linktarget/etc/init.d/php5-fastcgi /etc/init.d/
	ln -s  $$ext_linktarget/usr/local/usr/bin/php-fcgi /usr/bin/
endef

define Package/extendRoot-php-fastcgi/prerm
	#!/bin/sh
	rm  /etc/config/php5-fastcgi
	rm  /etc/init.d/php5-fastcgi
	rm  /usr/bin/php-fcgi 
endef



define Package/extendRoot-zoneinfo/postinst
	#!/bin/sh
	. /etc/ext.config
	mkdir -p /usr/share
	ln -s $$ext_linktarget/usr/share/zoneinfo /usr/share
endef	

define Package/extendRoot-zoneinfo/prerm
	#!/bin/sh
	rm /usr/share/zoneinfo
endef

define Package/extendRoot-proftpd/postinst
	#!/bin/sh
	. /etc/ext.config
	ln -s $$ext_linktarget/etc/proftpd.conf /etc
	ln -s $$ext_linktarget/etc/init.d/proftpd /etc/init.d
	ln -s $$ext_linktarget/usr/sbin/proftpd /usr/sbin
	ln -s $$ext_linktarget/usr/sbin/ftpshut /usr/sbin
	ln -s $$ext_linktarget/usr/sbin/in.proftpd /usr/sbin
endef

define Package/extendRoot-proftpd/prerm
	#!/bin/sh
        rm /etc/proftpd.conf
	rm /etc/init.d/proftpd 
	rm /usr/sbin/proftpd 
	rm /usr/sbin/ftpshut
	rm /usr/sbin/in.proftpd 
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
$(eval $(call BuildPlugin,extendRoot-php))
$(eval $(call BuildPlugin,extendRoot-php-fastcgi))
$(eval $(call BuildPlugin,extendRoot-zoneinfo))
$(eval $(call BuildPlugin,extendRoot-librarybox))
$(eval $(call BuildPlugin,extendRoot-proftpd))

