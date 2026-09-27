# Cudy TR3600 V1 · ImmortalWrt 6.6 / 237 · GitHub Actions

> **目标设备：Cudy TR3600 V1.0（256MB NAND / 512MB DDR4）**
>
> 这个仓库用于从 `padavanonly/immortalwrt-mt798x-6.6` 的 `openwrt-24.10-6.6` 分支云编译 TR3600 V1。
>
> **重要：本仓库不会使用 TR3000 的 BL2/FIP/U-BootMod，也不会生成可直接从原厂系统跳刷的 factory 镜像。**
>
> TR3600 的首刷应按照 Cudy 官方 `Develop_files_for_TR3600.zip` 的说明，先使用官方 Intermediate Firmware，再从 Intermediate OpenWrt 使用本项目生成的 TR3600 `sysupgrade.bin`。

## 已核对的硬件

- Cudy TR3600 V1.0
- MediaTek Filogic / MT7987B
- 512MB DDR4
- 256MB (2Gbit) NAND
- MT7990 Wi-Fi
- 2 × 2.5GbE
- USB 3.0

Cudy 官方下载中心目前提供 `Develop_files_for_TR3600.zip`，包含 DTS、Intermediate Firmware 和 Patch；官方页面要求开发 OpenWrt 时阅读其中 Readme。

## 本项目配置

- 237 系 ImmortalWrt 6.6
- TR3600 V1 专用 DTS / image 定义由 Cudy 官方开发包导入
- iptables / firewall3 路线
- firewall4 / nftables 不作为默认防火墙
- zram
- MTK HNAT / TurboACC-MTK（仅使用与当前源码兼容的 MTK 加速组件）
- OpenClash
- SmartDNS
- MosDNS
- FRPC
- ZeroTier
- KMS / vlmcsd
- OCSERV
- UPnP
- automount
- socat
- USB 3.0 / USB storage
- Argon

## 为什么不直接套 TR3000

TR3000 是 MT7981；TR3600 是 MT7987B + MT7990。两者的 DTS、启动链、NAND 布局和无线驱动不能混用。

**禁止：**

- TR3000 BL2
- TR3000 FIP
- TR3000 U-BootMod
- TR3000 factory.bin
- TR3000 DTS
- TR3000 256MB 镜像

## 首刷顺序

```text
Cudy 原厂
   ↓
Cudy 官方 Intermediate Firmware
   ↓
Intermediate OpenWrt
   ↓
本项目生成的 TR3600 V1 sysupgrade.bin
```

### 1. 官方资料

Cudy TR3600 V1 下载中心：

https://www.cudy.com/zh-cn/pages/download-center/tr3600-1-0

下载：

```text
Develop_files_for_TR3600.zip
```

以及需要时的原厂：

```text
m_upgrade_TR3600-R126-2.5.19-20260708-144409-sysupgrade_79962.zip
```

### 2. 编译

Fork 本仓库后：

1. 打开 GitHub → Actions
2. 启用 Actions
3. 运行 `Build TR3600`
4. 下载 Actions Artifact

输出重点文件：

```text
bin/
└── targets/mediatek/filogic/
    └── *cudy_tr3600-v1*sysupgrade.bin
```

同时会生成 SHA256。

## 关于“iptables”

本项目明确把 `firewall3` 和 iptables 作为目标路线。

由于新 OpenWrt/ImmortalWrt 代码树主要围绕 firewall4/nftables 演进，GitHub Actions 在进入编译前会检查 firewall3 是否存在；如果当前 237 源码已经删除 firewall3，脚本会自动从 OpenWrt firewall3 项目恢复 OpenWrt 包 Makefile 所需的兼容层。

如果 firewall3 恢复失败，Actions 会 **主动失败**，而不是偷偷改成 nftables。

## 关于 TurboACC

这里不采用“把 TR3000 TurboACC 整套硬拷贝过来”的方式。

TR3600 使用 MT7987B，因此只启用源码中与 MTK Filogic/MT7987 相容的 MTK HNAT/TurboACC 组件。不要把 TR3000 的 MT7981 专用 BL2/FIP 或 DTS 带入。

## 关于 256MB

TR3600 V1 原厂硬件本身就是 256MB NAND / 512MB RAM，因此本项目不再制作 TR3000 那种 `128M / 256M / ubootmod` 多布局选择。

**当前版本不包含 U-BootMod。**

先把：

```text
原厂 → Intermediate → ImmortalWrt
```

跑稳定，再单独研究 U-BootMod，是更安全的路线。

## 风险

这是给 TR3600 V1 的开发/编译仓库，不是官方 Cudy 固件。

第一次刷写前请：

- 确认机器底部标签是 `TR3600 1.0`
- 保留原厂固件
- 不要使用 TR3000 镜像
- 不要把本项目的 `sysupgrade.bin` 当成原厂 factory image 使用
- 不要在没有确认 Intermediate 环境的情况下直接刷写

