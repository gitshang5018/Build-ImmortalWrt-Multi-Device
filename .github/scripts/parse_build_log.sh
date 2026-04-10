#!/bin/bash
set -e

LOG_FILE="$1"
OUT_FILE="$2"

echo "解析构建日志: $LOG_FILE"

VERSION=$(grep -m1 "ImmortalWrt" "$LOG_FILE" | sed 's/.*ImmortalWrt //')
KERNEL=$(grep -m1 "Kernel version" "$LOG_FILE" | awk '{print $3}')
TARGET=$(grep -m1 "Target:" "$LOG_FILE" | sed 's/Target: //')
DATE=$(date +"%Y-%m-%d %H:%M:%S")

{
  echo "构建信息"
  echo "======================"
  echo "固件版本: $VERSION"
  echo "内核版本: $KERNEL"
  echo "目标平台: $TARGET"
  echo "构建时间: $DATE"
} > "$OUT_FILE"

echo "解析完成: $OUT_FILE"
