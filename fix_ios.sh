#!/bin/bash

echo "🔧 Fixing iOS build issues..."

# Clean everything first
flutter clean

# Get updated dependencies
flutter pub get

# Clean iOS build cache
cd ios
rm -rf Pods
rm -rf .symlinks
rm Podfile.lock
cd ..

# Reinstall pods
cd ios && pod install && cd ..

echo "✅ iOS setup complete! Now try:"
echo "flutter run -d 'iPhone 14 Pro Max'"
