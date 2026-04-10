#!/bin/bash
set -e

KEEP=10

echo "Fetching artifact list..."
ARTIFACTS=$(gh api repos/${GITHUB_REPOSITORY}/actions/artifacts --paginate --jq '.artifacts[].id')

COUNT=0
for ART in $ARTIFACTS; do
    COUNT=$((COUNT+1))
    if [ $COUNT -gt $KEEP ]; then
        echo "Deleting old artifact: $ART"
        gh api --method DELETE repos/${GITHUB_REPOSITORY}/actions/artifacts/$ART
    fi
done

echo "Cleanup complete. Kept latest $KEEP artifacts."
