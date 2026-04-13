#!/bin/bash
set -e

CONFIG_FILE="$1"
DEVICE="$2"

echo "自动适配网络加速 for $DEVICE"

case "$DEVICE" in

  mt7621)
    echo "→ MT7621: 启用 HW NAT (mtk-hnat) + FlowOffload"
    cat >> "$CONFIG_FILE" <<EOF
CONFIG_PACKAGE_kmod-mtk-hnat=y
CONFIG_PACKAGE_luci-app-turboacc=y
CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_OFFLOAD=y
CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_HW_OFFLOAD=y
CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_FULLCONENAT=y
EOF
    ;;

  r619ac)
    echo "→ IPQ40xx: 启用 FullCone（FlowOffload 可选）"
    cat >> "$CONFIG_FILE" <<EOF
CONFIG_PACKAGE_luci-app-turboacc=y
CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_FULLCONENAT=y
EOF
    ;;

  ax6600|jdc_ax1800)
    echo "→ IPQ60xx: FullCone 内核已启用，无需额外配置"
    # 不添加任何 TurboACC 选项
    ;;

  n5105|wyse3040)
    echo "→ x86_64: 可启用 Shortcut-FE（可选）"
    cat >> "$CONFIG_FILE" <<EOF
# Shortcut-FE（可选）
# CONFIG_PACKAGE_kmod-fast-classifier=y
# CONFIG_PACKAGE_kmod-shortcut-fe=y
EOF
    ;;

  ax9000|ipq807x)
    echo "→ IPQ807x: 启用 NSS 加速"
    cat >> "$CONFIG_FILE" <<EOF
CONFIG_PACKAGE_kmod-qca-nss-drv=y
CONFIG_PACKAGE_kmod-qca-nss-drv-pppoe=y
CONFIG_PACKAGE_kmod-qca-nss-drv-vlan=y
CONFIG_PACKAGE_kmod-qca-nss-drv-bridge-mgr=y
CONFIG_PACKAGE_kmod-qca-nss-drv-tun6rd=y
CONFIG_PACKAGE_kmod-qca-nss-drv-tunipip6=y
CONFIG_PACKAGE_kmod-qca-nss-drv-l2tpv2=y
CONFIG_PACKAGE_kmod-qca-nss-drv-pptp=y
CONFIG_PACKAGE_kmod-qca-nss-drv-gre=y
CONFIG_PACKAGE_kmod-qca-nss-drv-map-t=y
CONFIG_PACKAGE_kmod-qca-nss-drv-ipsecmgr=y
EOF
    ;;

  *)
    echo "→ 未知设备，不启用网络加速"
    ;;
esac
