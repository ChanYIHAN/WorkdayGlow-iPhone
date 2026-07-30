#!/bin/zsh
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "未找到 XcodeGen。请先运行：brew install xcodegen"
  exit 1
fi

xcodegen generate
open WorkdayGlow.xcodeproj
