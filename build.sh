#!/bin/bash

# Download and install Flutter
echo "Installing Flutter..."
FLUTTER_VERSION="3.24.5"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"

curl -o flutter.tar.xz "$FLUTTER_URL"
tar xf flutter.tar.xz
export PATH="$PATH:$PWD/flutter/bin"

# Verify Flutter installation
flutter --version
flutter doctor -v

# Get dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# Build for web
echo "Building Flutter web app..."
flutter build web --release

echo "Build completed successfully!"
