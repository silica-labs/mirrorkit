#!/bin/bash
set -e

VERSION="$1"
if [ -z "$VERSION" ]; then
  echo "Usage: ./scripts/release.sh v1.0.0"
  exit 1
fi

echo "=== Building $VERSION ==="
xcodebuild archive \
  -scheme mirrorkit \
  -configuration Release \
  -archivePath ./build/mirrorkit.xcarchive

xcodebuild -exportArchive \
  -archivePath ./build/mirrorkit.xcarchive \
  -exportPath ./build/export \
  -exportOptionsPlist export.plist

create-dmg \
  --volname "MirrorKit" \
  --window-pos 200 120 \
  --window-size 600 400 \
  --icon-size 100 \
  --icon "MirrorKit.app" 175 190 \
  --hide-extension "MirrorKit.app" \
  --app-drop-link 425 190 \
  "build/MirrorKit-$VERSION.dmg" \
  "./build/export/MirrorKit.app"

gh release create "$VERSION" \
  "build/MirrorKit-$VERSION.dmg" \
  --title "MirrorKit $VERSION" \
  --notes ""
