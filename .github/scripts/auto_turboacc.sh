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
EOF
    ;;

  r619ac)
    echo "→ IPQ40xx: 启用 SFE 加速 + FullCone NAT"
    cat >> "$CONFIG_FILE" <<EOF
# Shortcut-FE 加速驱动
CONFIG_PACKAGE_kmod-fast-classifier=y
CONFIG_PACKAGE_kmod-shortcut-fe=y
# FullCone NAT 支持
CONFIG_PACKAGE_kmod-ipt-fullconenat=y
EOF
    ;;

  ax6600|jdc_ax1800)
    echo "→ IPQ60xx: 启用 NSS 加速 + FullCone"
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
# 原生支持 FullCone NAT
CONFIG_PACKAGE_kmod-ipt-fullconenat=y
EOF
    ;;

  n5105|wyse3040)
    echo "→ x86_64: 启用 Shortcut-FE (SFE) 加速"
    cat >> "$CONFIG_FILE" <<EOF
# Shortcut-FE
CONFIG_PACKAGE_kmod-fast-classifier=y
CONFIG_PACKAGE_kmod-shortcut-fe=y
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
