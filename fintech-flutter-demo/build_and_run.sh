#!/bin/bash

# Flutter macOS build script for x86_64 (Rosetta) architecture
# This script handles the architecture compatibility issue on Rosetta

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== Flutter macOS Build Script ==="
echo ""

# Step 1: Install dependencies
echo "[1/4] Installing Flutter dependencies..."
flutter pub get

# Step 2: Prepare macOS platform files (generate ephemeral directory)
echo "[2/4] Preparing macOS platform files..."
flutter create . --platforms=macos 2>/dev/null || true
# Trigger ephemeral file generation (ignore failures due to arch issues)
flutter build macos --debug 2>/dev/null || true

# Step 3: Build with Xcode using correct destination
echo "[3/4] Building Flutter app for x86_64..."
cd macos
xcodebuild -project Runner.xcodeproj \
    -scheme Runner \
    -configuration Debug \
    -destination 'platform=macOS,arch=x86_64' \
    build

echo ""
echo "[4/4] Launching app..."

# Find and open the app
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "fintech_demo.app" -path "*/Debug/*" -type d 2>/dev/null | head -1)
if [ -n "$APP_PATH" ]; then
    open "$APP_PATH"
    echo "App launched: $APP_PATH"
    echo ""
    echo "=== Build completed successfully! ==="
else
    echo "Error: Could not find built app"
    exit 1
fi
