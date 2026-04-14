#!/bin/bash
set -e

CONFIG_FILE="$1"
DEVICE="$2"

echo "自动适配 WiFi 驱动 for $DEVICE"

case "$DEVICE" in

  mt7621)
    echo "→ MT7621: 启用开源 WiFi 驱动 mt76 (mt7603 + mt76x2)"
    cat >> "$CONFIG_FILE" <<EOF
# 启用开源 mt76 驱动
CONFIG_PACKAGE_kmod-mt76=y
CONFIG_PACKAGE_kmod-mt76-core=y
CONFIG_PACKAGE_kmod-mt7603=y
CONFIG_PACKAGE_kmod-mt76x2=y
CONFIG_PACKAGE_wpad-openssl=y
# 确保无线工具被安装
CONFIG_PACKAGE_wireless-tools=y
CONFIG_PACKAGE_iwinfo=y

# 移除旧的闭源驱动配置（ImmortalWrt 已不支持）
# CONFIG_PACKAGE_kmod-mt7603e is not set
# CONFIG_PACKAGE_kmod-mt76x2e is not set
# CONFIG_PACKAGE_luci-app-mtwifi is not set
EOF
    ;;

  r619ac)
    echo "→ IPQ40xx: 启用 ath10k-ct 驱动"
    cat >> "$CONFIG_FILE" <<EOF
CONFIG_PACKAGE_kmod-ath10k-ct=y
CONFIG_PACKAGE_ath10k-firmware-qca4019-ct=y
EOF
    ;;

  ax6600)
    echo "→ IPQ60xx 三频 (AX6600): 启用 ath11k + AHB + PCI 驱动"
    cat >> "$CONFIG_FILE" <<EOF
# ath11k 核心 + AHB 总线驱动（内置 2.4G/5G 射频）
CONFIG_PACKAGE_kmod-ath11k=y
CONFIG_PACKAGE_kmod-ath11k-ahb=y
CONFIG_PACKAGE_ath11k-firmware-ipq6018=y

# PCIe 第三射频（QCN9074 5G Gaming 频段）
CONFIG_PACKAGE_kmod-ath11k-pci=y
CONFIG_PACKAGE_ath11k-firmware-qcn9074=y
EOF
    ;;

  jdc_ax1800)
    echo "→ IPQ60xx 双频 (AX1800): 启用 ath11k + AHB 驱动"
    cat >> "$CONFIG_FILE" <<EOF
# ath11k 核心 + AHB 总线驱动（内置 2.4G/5G 射频）
CONFIG_PACKAGE_kmod-ath11k=y
CONFIG_PACKAGE_kmod-ath11k-ahb=y
CONFIG_PACKAGE_ath11k-firmware-ipq6018=y
EOF
    ;;

  n5105|wyse3040)
    echo "→ x86_64: 无 WiFi，不启用任何驱动"
    ;;

  *)
    echo "→ 未知设备，不启用 WiFi 驱动"
    ;;
esac
