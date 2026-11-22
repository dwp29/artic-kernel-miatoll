#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
set -euo pipefail

cd "$(dirname "$0")/.."

get_lock() {
  awk -F" = " -v section="[$1]" -v key="$2" '
    $0 == section { inside=1; next }
    /^\[/ { inside=0 }
    inside && $1 == key { print $2; exit }
  ' versions.lock
}

URL=$(get_lock upstream url)
BRANCH=$(get_lock upstream branch)
COMMIT=$(get_lock upstream commit)

if [ -z "$URL" ] || [ -z "$BRANCH" ] || [ -z "$COMMIT" ]; then
  echo "versions.lock is missing upstream url/branch/commit" >&2
  exit 1
fi

if [ ! -d src/.git ]; then
  git clone --depth 1 --branch "$BRANCH" "$URL" src
fi

git -C src fetch --depth 1 origin "$COMMIT"
git -C src checkout --detach FETCH_HEAD

ACTUAL=$(git -C src rev-parse HEAD)
if [ "$ACTUAL" != "$COMMIT" ]; then
  echo "SHA mismatch: expected $COMMIT, got $ACTUAL" >&2
  exit 1
fi

echo "Source ready: $ACTUAL"
