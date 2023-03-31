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
# 修改默认IP
sed -i 's/192.168.1.1/192.168.133.1/g' package/base-files/files/bin/config_generate

#改内核5.10
#sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=5.10/g' ./target/linux/ramips/Makefile
#sed -i 's/KERNEL_PATCHVER:=5.4/KERNEL_PATCHVER:=5.10/g' ./target/linux/ramips/Makefile
#改内核5.15
#sed -i 's/KERNEL_PATCHVER:=5.10/KERNEL_PATCHVER:=5.15/g' ./target/linux/ramips/Makefile

# Uncomment a feed source

#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git smpackage https://github.com/kenzok78/small-package' feeds.conf.default
sed -i '$a src-git small8 https://github.com/kenzok8/small-package' feeds.conf.default
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-packages' feeds.conf.default
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
src-git helloworld https://github.com/fw876/helloworld
src-git passwall https://github.com/xiaorouji/openwrt-passwall
#git clone https://github.com/yaof2/luci-app-ikoolproxy.git package/luci-app-ikoolproxy
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome
git clone https://github.com/thinktip/luci-theme-neobird.git package/luci-theme-neobird
git clone https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot

#添加smartdns
#svn co https://github.com/project-openwrt/openwrt/trunk/package/ntlf9t/smartdns package/smartdns
#svn co https://github.com/project-openwrt/openwrt/trunk/package/ntlf9t/luci-app-smartdns package/luci-app-smartdns
#svn co https://github.com/openwrt/luci/trunk/applications/luci-app-smartdns package/luci-app-smartdns
#svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-smartdns package/luci-app-smartdns

# smartdns
#sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.2022.37.1/g' feeds/packages/net/smartdns/Makefile
#sed -i 's/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=96d3deb595eae4f849cb2a51c69a9be89947fa0d/g' feeds/packages/net/smartdns/Makefile
#sed -i 's/PKG_MIRROR_HASH:=.*/PKG_MIRROR_HASH:=8a1b92fec63b9ce4084c7cb2713f7418a54b7713a9f609528fab6c951ef05cfd/g' feeds/packages/net/smartdns/Makefile
#sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.2022.37/g' package/luci-app-smartdns/Makefile

# 科学上网插件
git clone --depth 1 https://github.com/jerrykuku/luci-app-vssr package/luci-app-vssr
git clone --depth 1 https://github.com/jerrykuku/lua-maxminddb package/lua-maxminddb
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
#svn co https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall package/luci-app-passwall
svn co https://github.com/xiaorouji/openwrt-passwall2/trunk/luci-app-passwall2 package/luci-app-passwall2
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus

# 科学上网插件依赖
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/brook package/brook
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/chinadns-ng package/chinadns-ng
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/dns2socks package/dns2socks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/dns2tcp package/dns2tcp
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/hysteria package/hysteria
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/ipt2socks package/ipt2socks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/microsocks package/microsocks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/naiveproxy package/naiveproxy
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/pdnsd-alt package/pdnsd-alt
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/sagernet-core package/sagernet-core
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/ssocks package/ssocks
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/tcping package/tcping
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-go package/trojan-go
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/trojan-plus package/trojan-plus
svn co https://github.com/xiaorouji/openwrt-passwall/trunk/v2ray-geodata package/v2ray-geodata
svn co https://github.com/fw876/helloworld/trunk/simple-obfs package/simple-obfs
svn co https://github.com/fw876/helloworld/trunk/v2ray-core package/v2ray-core
svn co https://github.com/fw876/helloworld/trunk/v2ray-plugin package/v2ray-plugin
svn co https://github.com/fw876/helloworld/trunk/shadowsocks-rust package/shadowsocks-rust
svn co https://github.com/fw876/helloworld/trunk/shadowsocksr-libev package/shadowsocksr-libev
svn co https://github.com/fw876/helloworld/trunk/xray-core package/xray-core
svn co https://github.com/fw876/helloworld/trunk/xray-plugin package/xray-plugin
svn co https://github.com/fw876/helloworld/trunk/lua-neturl package/lua-neturl
svn co https://github.com/fw876/helloworld/trunk/trojan package/trojan
svn co https://github.com/fw876/helloworld/trunk/redsocks2 package/redsocks2

# Add luci-theme-opentomcat
git clone https://github.com/Leo-Jo-My/luci-theme-opentomcat.git theme-temp/luci-theme-opentomcat
rm -rf theme-temp/luci-theme-opentomcat/LICENSE
rm -rf theme-temp/luci-theme-opentomcat/README.md
mv -f theme-temp/luci-theme-opentomcat package/lean/
rm -rf theme-temp

# Add luci-app-vssr
git clone https://github.com/jerrykuku/lua-maxminddb.git package-temp/lua-maxminddb
git clone https://github.com/jerrykuku/luci-app-vssr.git package-temp/luci-app-vssr
git clone https://github.com/kenzok8/small.git package-temp/small
cp -r package-temp/small/* package/lean/
mv -f package-temp/lua-maxminddb package/lean/
mv -f package-temp/luci-app-vssr package/lean/
rm -rf package-temp
