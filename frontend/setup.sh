#!/bin/bash

# FitAI Flutter Setup Script

echo "🚀 Setting up FitAI Flutter App..."
echo "=================================="

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "   Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter detected: $(flutter --version | head -n 1)"

# Check Flutter version
FLUTTER_VERSION=$(flutter --version | grep "Flutter" | awk '{print $2}')
REQUIRED_VERSION="3.7.0"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$FLUTTER_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    echo "⚠️  Flutter version $FLUTTER_VERSION detected. Version $REQUIRED_VERSION or higher is recommended."
fi

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to get dependencies"
    exit 1
fi

# Check for Flutter doctor issues
echo "🔍 Running Flutter doctor..."
flutter doctor

# Create assets directories
echo "📁 Creating assets directories..."
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/animations
mkdir -p assets/fonts

# Create placeholder files
echo "📝 Creating placeholder files..."
touch assets/images/.gitkeep
touch assets/icons/.gitkeep
touch assets/animations/.gitkeep
touch assets/fonts/.gitkeep

# Check if Firebase is configured
if [ ! -f "android/app/google-services.json" ] && [ ! -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo "⚠️  Firebase configuration files not found."
    echo "   Please add your Firebase configuration files:"
    echo "   - android/app/google-services.json"
    echo "   - ios/Runner/GoogleService-Info.plist"
fi

# Check if API configuration exists
if ! grep -q "YOUR_GEMINI_API_KEY" lib/core/constants/app_constants.dart; then
    echo "✅ API constants appear to be configured"
else
    echo "⚠️  Please update API keys in lib/core/constants/app_constants.dart"
fi

echo ""
echo "🎉 Flutter setup completed!"
echo ""
echo "Next steps:"
echo "1. Configure Firebase (if not already done)"
echo "2. Update API keys in lib/core/constants/app_constants.dart"
echo "3. Run the app:"
echo "   flutter run"
echo ""
echo "For more information, see README.md"
