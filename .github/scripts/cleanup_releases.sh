#!/bin/bash
set -e

# 保留的最新 Release 数量
KEEP=5

echo "Fetching release list..."
RELEASES=$(gh release list --limit 100 | awk '{print $1}')

COUNT=0
for REL in $RELEASES; do
    COUNT=$((COUNT+1))
    if [ $COUNT -gt $KEEP ]; then
        echo "Deleting old release: $REL"
        gh release delete "$REL" -y
    fi
done

echo "Cleanup complete. Kept latest $KEEP releases."
