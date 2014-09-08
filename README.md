# OpenWRT piratebox feed
A custom OpenWRT feed which contains all needed files to generate Makefiles for ipk via OpenWRT toolchain.

## Prerequisits
Copy OpenWRT's default config file to its place:    
    
    cp  feeds.conf.default feeds.conf
    
and append the following line to use this feed in your build:

    src-git piratebox git://github.com/PirateBox-Dev/openwrt-piratebox-feed.git

## Ressources:
* [OpenWRT wiki](http://wiki.openwrt.org/start)
* [Building OpenWRT](http://wiki.openwrt.org/doc/howto/build)
* [Building single package for OpenWRT](http://wiki.openwrt.org/doc/howtobuild/single.package)
* [Using the OpenWRT build system](http://wiki.openwrt.org/doc/howto/buildroot.exigence)
* [Feed Documentation](http://wiki.openwrt.org/doc/devel/feeds)
* [Creating packages](http://wiki.openwrt.org/doc/devel/packages)
* [Init script documentation](http://wiki.openwrt.org/doc/techref/initscripts)
