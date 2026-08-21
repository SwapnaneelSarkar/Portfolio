#!/bin/bash
set -e  # Exit on any error

# Download and install a pinned Flutter version using git.
# Netlify's latest stable can move ahead of package compatibility.
FLUTTER_VERSION="3.29.3"

# Netlify can restore a cached ./flutter from a previous build — reuse it
# when it matches the pinned version, otherwise wipe and re-clone.
if [ -d "flutter" ]; then
  INSTALLED=$(git -C flutter describe --tags 2>/dev/null || echo "unknown")
  if [ "$INSTALLED" = "$FLUTTER_VERSION" ]; then
    echo "Reusing cached Flutter $INSTALLED"
  else
    echo "Cached Flutter is '$INSTALLED', want $FLUTTER_VERSION — removing..."
    rm -rf flutter
  fi
fi

if [ ! -d "flutter" ]; then
  echo "Installing Flutter $FLUTTER_VERSION..."
  git clone https://github.com/flutter/flutter.git -b "$FLUTTER_VERSION" --depth 1
fi

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
