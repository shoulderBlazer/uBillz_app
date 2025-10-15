#!/bin/bash

# Setup Flutter project for iOS and other platforms
echo "Setting up Flutter project for multiple platforms..."

# Generate platform files
flutter create . --platforms=ios,android,web,macos

# Install dependencies
flutter pub get

echo "Setup complete! You can now run:"
echo "flutter run -d 'iPhone 14 Pro Max'"
