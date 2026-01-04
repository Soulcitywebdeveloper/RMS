#!/bin/bash

# Build script for Flutter app

echo "Building RMS Logistics App..."

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build APK for Android
echo "Building Android APK..."
flutter build apk --release

# Build iOS (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Building iOS app..."
    flutter build ios --release
fi

# Build Web (optional)
echo "Building Web app..."
flutter build web --release

echo "Build complete!"
echo "APK location: build/app/outputs/flutter-apk/app-release.apk"

