#!/bin/bash

# Minimal PONG - Build and Run Script
# This script builds and runs the Swift app on macOS and iOS

set -e

echo "🎮 Minimal PONG - Build Script"
echo "=============================="

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed or xcodebuild is not in PATH"
    exit 1
fi

# Navigate to project directory
cd MinimalPong

echo "📱 Building for iOS Simulator..."
xcodebuild -project MinimalPong.xcodeproj \
    -scheme MinimalPong \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 15' \
    build

echo "💻 Building for macOS..."
xcodebuild -project MinimalPong.xcodeproj \
    -scheme MinimalPong \
    -sdk macosx \
    build

echo "✅ Build completed successfully!"
echo ""
echo "To run the app:"
echo "1. Open MinimalPong/MinimalPong.xcodeproj in Xcode"
echo "2. Select your target device (iPhone simulator or Mac)"
echo "3. Press Cmd+R to run"
echo ""
echo "Or use these commands:"
echo "# Run on iOS Simulator"
echo "xcodebuild -project MinimalPong.xcodeproj -scheme MinimalPong -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 15' run"
echo ""
echo "# Run on macOS"
echo "xcodebuild -project MinimalPong.xcodeproj -scheme MinimalPong -sdk macosx run"