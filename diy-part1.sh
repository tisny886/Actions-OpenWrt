#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git smpackage https://github.com/kenzok78/small-package' feeds.conf.default
sed -i '$a src-git small8 https://github.com/kenzok8/small-package' feeds.conf.default
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-packages' feeds.conf.default
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
git clone https://github.com/yaof2/luci-app-ikoolproxy.git package/luci-app-ikoolproxy
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome
git clone https://github.com/thinktip/luci-theme-neobird.git package/luci-theme-neobird
git clone https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot

#添加smartdns
#svn co https://github.com/project-openwrt/openwrt/trunk/package/ntlf9t/smartdns package/smartdns
#svn co https://github.com/project-openwrt/openwrt/trunk/package/ntlf9t/luci-app-smartdns package/luci-app-smartdns
#svn co https://github.com/openwrt/luci/trunk/applications/luci-app-smartdns package/luci-app-smartdns
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-smartdns package/luci-app-smartdns

# smartdns
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.2022.37.1/g' feeds/packages/net/smartdns/Makefile
sed -i 's/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=96d3deb595eae4f849cb2a51c69a9be89947fa0d/g' feeds/packages/net/smartdns/Makefile
sed -i 's/PKG_MIRROR_HASH:=.*/PKG_MIRROR_HASH:=8a1b92fec63b9ce4084c7cb2713f7418a54b7713a9f609528fab6c951ef05cfd/g' feeds/packages/net/smartdns/Makefile
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.2022.37/g' package/luci-app-smartdns/Makefile
