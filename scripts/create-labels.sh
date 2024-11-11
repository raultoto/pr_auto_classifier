#!/bin/bash

declare -A SIZE_LABELS=(
  ["size/minimal"]="0E8A16:PR with less than 10 lines"
  ["size/small"]="87CEEB:PR with 10-49 lines"
  ["size/medium"]="FBCA04:PR with 50-199 lines"
  ["size/large"]="FFA500:PR with 200-499 lines"
  ["size/very-large"]="FF4500:PR with 500-999 lines"
  ["size/extensive"]="B60205:PR with 1000+ lines"
)

for label in "${!SIZE_LABELS[@]}"; do
  IFS=':' read -r color description <<< "${SIZE_LABELS[$label]}"
  curl -s -X POST \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/$GITHUB_REPOSITORY/labels" \
    -d "{\"name\":\"$label\",\"color\":\"$color\",\"description\":\"$description\"}" || true
done

# Version labels
curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/labels" \
  -d "{\"name\":\"major\",\"color\":\"FF0000\",\"description\":\"Breaking changes - Major version bump\"}" || true

curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/labels" \
  -d "{\"name\":\"minor\",\"color\":\"FFFF00\",\"description\":\"New features - Minor version bump\"}" || true

curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/labels" \
  -d "{\"name\":\"patch\",\"color\":\"00FF00\",\"description\":\"Bug fixes - Patch version bump\"}" || true
