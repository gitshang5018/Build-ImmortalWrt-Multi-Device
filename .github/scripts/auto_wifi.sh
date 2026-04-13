#!/bin/bash
set -e

CONFIG_FILE="$1"
DEVICE="$2"

echo "自动适配 WiFi 驱动 for $DEVICE"

case "$DEVICE" in

  mt7621)
    echo "→ MT7621: 启用闭源 WiFi 驱动 mtwifi（mt7603e + mt76x2e）"
    cat >> "$CONFIG_FILE" <<EOF
# 闭源 WiFi 驱动
CONFIG_PACKAGE_kmod-mt7603e=y
CONFIG_PACKAGE_kmod-mt76x2e=y
CONFIG_PACKAGE_luci-app-mtwifi=y

# 禁用开源 mt76
# CONFIG_PACKAGE_kmod-mt76 is not set
# CONFIG_PACKAGE_kmod-mt76-core is not set
# CONFIG_PACKAGE_kmod-mt76-connac is not set
# CONFIG_PACKAGE_kmod-mt7603 is not set
# CONFIG_PACKAGE_kmod-mt76x2 is not set
EOF
    ;;

  r619ac)
    echo "→ IPQ40xx: 启用 ath10k-ct 驱动"
    cat >> "$CONFIG_FILE" <<EOF
CONFIG_PACKAGE_kmod-ath10k-ct=y
CONFIG_PACKAGE_ath10k-firmware-qca4019-ct=y
EOF
    ;;

  ax6600|jdc_ax1800)
    echo "→ IPQ60xx: 启用 ath11k 运行环境与固件"
    cat >> "$CONFIG_FILE" <<EOF
CONFIG_PACKAGE_kmod-ath11k=y
CONFIG_PACKAGE_kmod-ath11k-ahb=y
CONFIG_PACKAGE_kmod-ath11k-pci=y
CONFIG_PACKAGE_ath11k-firmware-ipq6018=y
CONFIG_PACKAGE_kmod-qrtr=y
CONFIG_PACKAGE_kmod-qrtr-mhi=y
CONFIG_PACKAGE_kmod-qrtr-tun=y
EOF
    if [ "$DEVICE" == "jdc_ax1800" ]; then
      echo "CONFIG_PACKAGE_ipq-wifi-jdc_ax1800=y" >> "$CONFIG_FILE"
    else
      echo "CONFIG_PACKAGE_ipq-wifi-jdcloud_ax6600=y" >> "$CONFIG_FILE"
    fi
    ;;

  n5105|wyse3040)
    echo "→ x86_64: 无 WiFi，不启用任何驱动"
    ;;

  *)
    echo "→ 未知设备，不启用 WiFi 驱动"
    ;;
esac
