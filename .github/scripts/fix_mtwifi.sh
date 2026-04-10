#!/bin/bash
set -e

CONFIG_FILE="$1"
DEVICE="$2"

if [ "$DEVICE" != "mt7621" ]; then
    echo "非 MT7621 设备，跳过 mtwifi 修复"
    exit 0
fi

echo "→ 修复 MT7621 闭源 WiFi 开机不自动启用问题"

cat >> "$CONFIG_FILE" <<'EOF'
# 自定义启动脚本：自动加载闭源 WiFi 驱动并加入 LAN
CONFIG_PACKAGE_mtwifi-init=y
EOF
