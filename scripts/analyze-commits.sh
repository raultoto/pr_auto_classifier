#!/bin/bash

git fetch origin $BASE_REF
COMMITS=$(git log origin/$BASE_REF..HEAD --pretty=format:"%s")

CLASSIFICATION="patch"

has_breaking_change() {
  local commit="$1"
  if echo "$commit" | grep -q -E "^[a-zA-Z]+!:" || echo "$commit" | grep -q "BREAKING CHANGE"; then
    return 0
  fi
  return 1
}

has_feature() {
  local commit="$1"
  if echo "$commit" | grep -q -E "^feat(\([^)]+\))?:"; then
    return 0
  fi
  return 1
}

while IFS= read -r commit; do
  if [ ! -z "$commit" ]; then
    if has_breaking_change "$commit"; then
      CLASSIFICATION="major"
      break
    elif has_feature "$commit" && [ "$CLASSIFICATION" = "patch" ]; then
      CLASSIFICATION="minor"
    fi
  fi
done <<< "$COMMITS"

echo "classification=$CLASSIFICATION" >> $GITHUB_OUTPUT

DESCRIPTION=""
case $CLASSIFICATION in
  "major")
    DESCRIPTION="🚨 Breaking Changes detected - Major version bump required"
    ;;
  "minor")
    DESCRIPTION="✨ New features added - Minor version bump required"
    ;;
  "patch")
    DESCRIPTION="🐛 Bug fixes or minor changes - Patch version bump required"
    ;;
esac

echo "description=$DESCRIPTION" >> $GITHUB_OUTPUT