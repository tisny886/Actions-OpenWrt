#!/bin/bash

# 第三方插件源
echo "src-git turboacc https://github.com/mufeng05/turboacc.git;main" >> feeds.conf.default
echo "src-git openclash https://github.com/vernesong/OpenClash.git;master" >> feeds.conf.default
echo "src-git mosdns https://github.com/sbwml/luci-app-mosdns.git;v5" >> feeds.conf.default
echo "src-git easytier https://github.com/EasyTier/luci-app-easytier.git;main" >> feeds.conf.default
echo "src-git zerotier https://github.com/mwarning/zerotier-openwrt.git;master" >> feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install -a
