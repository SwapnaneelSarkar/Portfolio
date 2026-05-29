#!/bin/bash
set -e  # Exit on any error

# Download and install Flutter using git
echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1

echo "Setting up Flutter path..."
export PATH="$PATH:$PWD/flutter/bin"

# Verify Flutter installation
echo "Flutter version:"
flutter --version

# Enable web support
echo "Enabling Flutter web support..."
flutter config --enable-web

# Get dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# Build for web
echo "Building Flutter web app..."
flutter build web --release

echo "Build completed successfully!"
ls -la build/web
