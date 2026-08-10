#!/bin/zsh
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$PROJECT_DIR/build"
PAYLOAD_DIR="$PROJECT_DIR/Payload"
IPA_PATH="$PROJECT_DIR/EkhartWidgets-unsigned.ipa"

cd "$PROJECT_DIR"

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "未找到 XcodeGen。请先运行：brew install xcodegen"
  exit 1
fi

xcodegen generate

xcodebuild \
  -project WorkdayGlow.xcodeproj \
  -scheme WorkdayGlow \
  -configuration Release \
  -sdk iphoneos \
  -destination "generic/platform=iOS" \
  -derivedDataPath "$BUILD_DIR" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  build

APP_PATH="$BUILD_DIR/Build/Products/Release-iphoneos/WorkdayGlow.app"
test -d "$APP_PATH"

rm -rf "$PAYLOAD_DIR"
mkdir "$PAYLOAD_DIR"
cp -R "$APP_PATH" "$PAYLOAD_DIR/"
ditto -c -k --sequesterRsrc --keepParent "$PAYLOAD_DIR" "$IPA_PATH"

echo "已生成：$IPA_PATH"
