#!/bin/sh

# Fail the script if any command fails.
set -e

echo "⚙️ Starting ci_pre_xcodebuild..."

# Change to the root of the repo
cd "$CI_PRIMARY_REPOSITORY_PATH"

# Add Flutter to PATH
export PATH="$HOME/flutter/bin:$PATH"

# Run Flutter doctor (optional)
flutter doctor

# Get Flutter dependencies (just in case)
flutter pub get

# Build Flutter iOS artifacts (without codesigning)
echo "📦 Building Flutter iOS project..."
flutter build ios --release --no-codesign

# CocoaPods may be needed again depending on plugin structure
echo "📦 Running pod install..."
cd ios
pod install
cd ..

echo "✅ ci_pre_xcodebuild completed successfully."
exit 0
