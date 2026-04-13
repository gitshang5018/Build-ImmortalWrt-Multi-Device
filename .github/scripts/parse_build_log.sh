#!/bin/bash

LOG_FILE="$1"
OUT_FILE="$2"

echo "解析构建信息..."

# 1. 尝试从源文件提取版本信息 (最准确)
if [ -f "package/base-files/files/etc/openwrt_release" ]; then
  VERSION=$(grep "DISTRIB_RELEASE=" package/base-files/files/etc/openwrt_release | cut -d"'" -f2 || true)
fi

if [ -z "$VERSION" ] && [ -f "version.txt" ]; then
  VERSION=$(cat version.txt | tr -d '\r\n' || true)
fi

# 2. 尝试从 .config 提取信息
if [ -f ".config" ]; then
  [ -z "$VERSION" ] && VERSION=$(grep "CONFIG_VERSION_NUMBER=" .config | cut -d'=' -f2 | tr -d '"' || true)
  BOARD=$(grep "CONFIG_TARGET_BOARD=" .config | cut -d'=' -f2 | tr -d '"' || true)
  SUBTARGET=$(grep "CONFIG_TARGET_SUBTARGET=" .config | cut -d'=' -f2 | tr -d '"' || true)
  [ -n "$BOARD" ] && TARGET="${BOARD}/${SUBTARGET}"
  [ -z "$KERNEL" ] && KERNEL=$(grep "CONFIG_LINUX_VERSION=" .config | cut -d'=' -f2 | tr -d '"' || true)
fi

# 3. 从日志文件提取（作为备份或补充）
if [ -f "$LOG_FILE" ]; then
  # 固件版本：优化正则，匹配 "ImmortalWrt" 后接版本号的情况
  if [ -z "$VERSION" ] || [ "$VERSION" = "unknown" ] || [ "$VERSION" = "未知" ]; then
    VERSION=$(grep -m1 "ImmortalWrt [0-9]" "$LOG_FILE" | sed 's/.*ImmortalWrt //' || true)
  fi
  # 内核版本：如果 .config 没找到，尝试从日志找
  if [ -z "$KERNEL" ]; then
    KERNEL=$(grep -m1 "Kernel version" "$LOG_FILE" | awk '{print $3}' || true)
  fi
  # 目标平台：如果 .config 没找到，从日志找
  if [ -z "$TARGET" ]; then
    TARGET=$(grep -m1 "Target:" "$LOG_FILE" | sed 's/Target: //' || true)
  fi
fi

# 3. 最后的兜底逻辑：内核版本尝试从构建目录名提取
if [ -z "$KERNEL" ]; then
  KERNEL=$(ls build_dir/target-*/linux-*/linux-* -d 2>/dev/null | head -1 | sed 's/.*linux-//' || true)
fi

# 确保不为空
[ -z "$VERSION" ] && VERSION="未知"
[ -z "$KERNEL" ] && KERNEL="未知"
[ "$TARGET" = "/" ] || [ -z "$TARGET" ] && TARGET="未知"

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
