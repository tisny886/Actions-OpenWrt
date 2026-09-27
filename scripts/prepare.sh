#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OPENWRT_DIR="${ROOT_DIR}/openwrt"
cd "${OPENWRT_DIR}"

CUDY_PAGE="https://www.cudy.com/zh-cn/pages/download-center/tr3600-1-0"
CUDY_ZIP_URL="https://www.cudy.com/cdn/shop/files/Develop_files_for_TR3600.zip?v=4621844316444592836"

echo "==> Importing Cudy TR3600 official development package"

mkdir -p "${OPENWRT_DIR}/.cudy-dev"
cd "${OPENWRT_DIR}/.cudy-dev"

curl -L --fail --retry 5 --retry-delay 3 \
  "${CUDY_ZIP_URL}" -o Develop_files_for_TR3600.zip

rm -rf extracted
mkdir extracted
unzip -oq Develop_files_for_TR3600.zip -d extracted

echo "==> Cudy package contents:"
find extracted -maxdepth 5 -type f | sort | sed -n '1,240p'

cd "${OPENWRT_DIR}"

echo "==> Applying official Cudy patches"

mapfile -t PATCHES < <(find .cudy-dev/extracted -type f \
  \( -iname '*.patch' -o -iname '*.diff' \) | sort)

if [ "${#PATCHES[@]}" -eq 0 ]; then
  echo "ERROR: Cudy development ZIP did not contain a patch/diff file."
  echo "See: ${CUDY_PAGE}"
  exit 1
fi

PATCH_OK=0
for p in "${PATCHES[@]}"; do
  echo "---- ${p}"
  if git apply --check --3way "${p}" >/dev/null 2>&1; then
    git apply --3way "${p}"
    PATCH_OK=$((PATCH_OK+1))
  else
    echo "Patch did not apply cleanly to this 237 source tree:"
    echo "${p}"
    echo "Trying normal git apply check for diagnostics..."
    git apply --check "${p}" || true
  fi
done

echo "Applied ${PATCH_OK}/${#PATCHES[@]} official patch files."

if [ "${PATCH_OK}" -eq 0 ]; then
  echo "ERROR: No official Cudy patch could be applied."
  echo "This is intentional: do not build a TR3600 image without device support."
  exit 1
fi

echo "==> Copying TR3600 DTS files from official development package"

find .cudy-dev/extracted -type f \
  \( -iname '*tr3600*.dts' -o -iname '*tr3600*.dtsi' \) \
  -print0 | while IFS= read -r -d '' f; do
    base="$(basename "$f")"
    echo "Installing DTS: ${base}"
    mkdir -p target/linux/mediatek/dts
    cp -f "$f" "target/linux/mediatek/dts/${base}"
  done

echo "==> Adding third-party packages"

mkdir -p package/custom

clone_or_update() {
  local repo="$1"
  local dest="$2"
  local branch="${3:-}"
  rm -rf "${dest}"
  if [ -n "${branch}" ]; then
    git clone --depth=1 -b "${branch}" "${repo}" "${dest}"
  else
    git clone --depth=1 "${repo}" "${dest}"
  fi
}

# OpenClash
clone_or_update \
  https://github.com/vernesong/OpenClash.git \
  package/custom/openclash-src
if [ -d package/custom/openclash-src/luci-app-openclash ]; then
  rm -rf package/custom/luci-app-openclash
  cp -a package/custom/openclash-src/luci-app-openclash package/custom/luci-app-openclash
fi
rm -rf package/custom/openclash-src

# MosDNS
clone_or_update \
  https://github.com/sbwml/luci-app-mosdns.git \
  package/custom/mosdns
if [ -d package/custom/mosdns ]; then
  :
fi

# SmartDNS daemon + LuCI
rm -rf feeds/packages/net/smartdns
mkdir -p feeds/packages/net/smartdns
curl -L --fail --retry 5 \
  https://github.com/pymumu/openwrt-smartdns/archive/refs/heads/master.zip \
  -o /tmp/smartdns.zip
unzip -oq /tmp/smartdns.zip -d /tmp
cp -a /tmp/openwrt-smartdns-master/. feeds/packages/net/smartdns/
rm -rf /tmp/openwrt-smartdns-master /tmp/smartdns.zip

rm -rf feeds/luci/applications/luci-app-smartdns
git clone --depth=1 https://github.com/pymumu/luci-app-smartdns.git \
  feeds/luci/applications/luci-app-smartdns

# FRPC LuCI
clone_or_update \
  https://github.com/kuoruan/luci-app-frpc.git \
  package/custom/luci-app-frpc

# ZeroTier LuCI; daemon comes from packages feed.
clone_or_update \
  https://github.com/zhengmz/luci-app-zerotier.git \
  package/custom/luci-app-zerotier

# KMS / vlmcsd
clone_or_update \
  https://github.com/mchome/openwrt-vlmcsd.git \
  package/custom/vlmcsd

clone_or_update \
  https://github.com/openwrt-develop/luci-app-vlmcsd.git \
  package/custom/luci-app-vlmcsd

# OCSERV LuCI (daemon is from packages feed)
if [ ! -d feeds/luci/applications/luci-app-ocserv ]; then
  git clone --depth=1 \
    https://github.com/coolsnowwolf/luci.git /tmp/luci-extra
  if [ -d /tmp/luci-extra/applications/luci-app-ocserv ]; then
    cp -a /tmp/luci-extra/applications/luci-app-ocserv \
      feeds/luci/applications/luci-app-ocserv
  fi
  rm -rf /tmp/luci-extra
fi

echo "==> Ensuring required TR3600 target is visible"
grep -R "cudy_tr3600-v1" target/linux/mediatek 2>/dev/null | head -20 || true

echo "==> Prepare complete"
