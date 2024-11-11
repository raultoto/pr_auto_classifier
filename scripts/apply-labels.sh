#!/bin/bash

LABELS="[\"$SIZE_LABEL\", \"$VERSION_BUMP\""
for label in $TYPE_LABELS; do
  LABELS="$LABELS, \"$label\""
done
LABELS="$LABELS]"

curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$PR_NUMBER/labels" \
  -d "{\"labels\": $LABELS}"

COMMENT="## PR Classification Results

$VERSION_DESCRIPTION

### Details:
- 📏 Size: \`$SIZE_LABEL\`
- 🏷️ Type: \`$TYPE_LABELS\`
- 📦 Version: \`$VERSION_BUMP\`

> This classification is based on conventional commits analysis. Please verify it matches your intentions."

curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$PR_NUMBER/comments" \
  -d "{\"body\":$(echo "$COMMENT" | jq -R -s)}"