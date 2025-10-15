#!/bin/bash
cd /Users/johnshoulder/Desktop/wind_test/CascadeProjects/windsurf-project

echo "🧹 Cleaning Flutter project..."
flutter clean

echo "📦 Getting updated dependencies..."
flutter pub get

echo "🍎 Cleaning iOS cache..."
if [ -d "ios" ]; then
    cd ios
    rm -rf Pods
    rm -rf .symlinks
    rm -f Podfile.lock
    echo "📱 Reinstalling CocoaPods..."
    pod install
    cd ..
fi

echo "✅ Ready to run! Execute:"
echo "flutter run -d 'iPhone 14 Pro Max'"
