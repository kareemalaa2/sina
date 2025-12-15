#!/bin/sh

# Fail this script if any subcommand fails.
set -e

echo "📦 Starting ci_post_clone..."

# Change working directory to root of the repository.
cd "$CI_PRIMARY_REPOSITORY_PATH"

# Clone Flutter SDK to home directory
echo "🔧 Cloning Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable $HOME/flutter

# Export Flutter path
export PATH="$HOME/flutter/bin:$PATH"

# Optionally disable Flutter analytics
flutter config --no-analytics

# Doctor check (optional but good for logs)
flutter doctor

# Precache Flutter iOS artifacts
echo "📦 Pre-caching Flutter iOS artifacts..."
flutter precache --ios

# Install Flutter dependencies
echo "📥 Running flutter pub get..."
flutter pub get

# Install CocoaPods
echo "🍺 Installing CocoaPods..."
HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods

# Go to iOS directory and install pods
echo "📦 Installing iOS CocoaPods..."
cd ios
pod install
cd ..

echo "✅ ci_post_clone completed successfully."
exit 0
