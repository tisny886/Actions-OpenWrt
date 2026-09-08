#!/bin/bash
 # 默认IP 192.168.6.1
 sed -i 's/192.168.1.1/192.168.30.1/g' package/base-files/files/bin/config_generate
 # 移除netifd firewall4依赖
 sed -i 's/firewall4//g' package/network/config/netifd/Makefile
