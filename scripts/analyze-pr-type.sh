#!/bin/bash

declare -A EXTENSIONS=(
  ["js"]="javascript:F7DF1E"
  ["jsx"]="react:61DAFB"
  ["ts"]="typescript:3178C6"
  ["tsx"]="react:61DAFB"
  ["py"]="python:3776AB"
  ["rb"]="ruby:CC342D"
  ["php"]="php:777BB4"
  ["java"]="java:007396"
  ["kt"]="kotlin:7F52FF"
  ["swift"]="swift:FA7343"
  ["go"]="golang:00ADD8"
  ["rs"]="rust:000000"
  ["cpp"]="c++:00599C"
  ["c"]="c:A8B9CC"
  ["cs"]="c#:239120"
  ["html"]="html:E34F26"
  ["css"]="css:1572B6"
  ["scss"]="scss:CC6699"
  ["vue"]="vue.js:4FC08D"
  ["sql"]="sql:4479A1"
  ["md"]="markdown:000000"
  ["json"]="json:000000"
  ["yaml"]="yaml:CB171E"
  ["tf"]="terraform:7B42BC"
  ["docker"]="docker:2496ED"
  ["dart"]="dart:0175C2"
  ["sh"]="shell:89E051"
  ["bat"]="batch:4EAA25"
)

TYPES=""

for ext in "${!EXTENSIONS[@]}"; do
  IFS=':' read -r label color <<< "${EXTENSIONS[$ext]}"
  if git diff --name-only origin/$BASE_REF | grep -q "\.$ext$"; then
    if [ -z "$TYPES" ]; then
      TYPES="$label"
    else
      TYPES="$TYPES $label"
    fi
    
    curl -s -X POST \
      -H "Authorization: token $GITHUB_TOKEN" \
      -H "Accept: application/vnd.github.v3+json" \
      "https://api.github.com/repos/$GITHUB_REPOSITORY/labels" \
      -d "{\"name\":\"$label\",\"color\":\"$color\",\"description\":\"Files containing .$ext\"}" || true
  fi
done

if [ -z "$TYPES" ]; then
  TYPES="other"
  curl -s -X POST \
    -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/$GITHUB_REPOSITORY/labels" \
    -d "{\"name\":\"other\",\"color\":\"CCCCCC\",\"description\":\"Other file types\"}" || true
fi

echo "types=$TYPES" >> $GITHUB_OUTPUT

# scripts/create-labels.sh
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
