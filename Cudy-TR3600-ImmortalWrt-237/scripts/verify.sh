#!/bin/bash
set -euo pipefail

echo "==> Verifying TR3600 target"
grep -R "cudy_tr3600-v1" target/linux/mediatek >/dev/null

echo "==> Verifying MT7987"
grep -R "mt7987" target/linux/mediatek >/dev/null

echo "==> Verifying 237 target"
grep -q '^CONFIG_TARGET_mediatek=y' .config
grep -q '^CONFIG_TARGET_mediatek_filogic=y' .config
grep -q '^CONFIG_TARGET_DEVICE_mediatek_filogic_DEVICE_cudy_tr3600-v1=y' .config

echo "==> Verifying firewall policy"
grep -q '^CONFIG_PACKAGE_firewall3=y' .config
if grep -q '^CONFIG_PACKAGE_firewall4=y' .config; then
  echo "ERROR: firewall4 is enabled."
  exit 1
fi
if grep -q '^CONFIG_PACKAGE_nftables=y' .config; then
  echo "ERROR: nftables is enabled as a userspace package."
  exit 1
fi
grep -q '^CONFIG_PACKAGE_iptables=y' .config

echo "==> Verifying required packages"
for p in \
  zram-swap \
  luci-app-openclash \
  luci-app-smartdns \
  luci-app-mosdns \
  frpc \
  luci-app-frpc \
  zerotier \
  luci-app-zerotier \
  vlmcsd \
  luci-app-vlmcsd \
  ocserv \
  luci-app-ocserv \
  luci-app-upnp \
  automount \
  socat
do
  grep -R "Package/${p}" feeds package 2>/dev/null | head -1 >/dev/null || {
    echo "WARNING: package definition not found yet: ${p}"
  }
done

echo "==> Configuration verification passed"
