#!/bin/bash
set -e  # Exit on any error

# Download and install a pinned Flutter version using git.
# Netlify's latest stable can move ahead of package compatibility.
echo "Installing Flutter..."
FLUTTER_VERSION="3.29.3"
git clone https://github.com/flutter/flutter.git -b "$FLUTTER_VERSION" --depth 1

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
