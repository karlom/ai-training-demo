#!/bin/bash

# Flutter macOS build script for x86_64 (Rosetta) architecture

echo "Building Flutter app for x86_64..."
cd "$(dirname "$0")/macos"

# Build with Xcode
xcodebuild -project Runner.xcodeproj \
    -scheme Runner \
    -configuration Debug \
    -arch x86_64 \
    build

if [ $? -eq 0 ]; then
    echo "Build succeeded!"
    echo "Launching app..."
    # Find and open the app
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "fintech_demo.app" -path "*/Debug/*" | head -1)
    if [ -n "$APP_PATH" ]; then
        open "$APP_PATH"
        echo "App launched: $APP_PATH"
    else
        echo "Could not find built app"
    fi
else
    echo "Build failed!"
    exit 1
fi
