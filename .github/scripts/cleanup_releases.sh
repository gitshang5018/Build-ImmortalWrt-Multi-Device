#!/bin/bash
set -e

# 保留的最新 Release 数量
KEEP=5

echo "获取 Release 列表..."
RELEASES=$(gh release list --limit 100 --json tagName -q '.[].tagName')

COUNT=0
for REL in $RELEASES; do
    COUNT=$((COUNT+1))
    if [ $COUNT -gt $KEEP ]; then
        echo "删除旧 Release: $REL"
        # 忽略 error，防止并行任务竞争导致 "release not found" 报错
        gh release delete "$REL" -y || true
    fi
done

echo "清理完成，保留最新 $KEEP 个 Release。"
