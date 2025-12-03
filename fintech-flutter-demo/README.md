# fintech_demo

A Flutter fintech demo project.

## Prerequisites

- Flutter SDK (>=2.17.0 <3.0.0)
- Xcode (for macOS development)
- macOS system (for running the macOS app)

## Getting Started

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Run the Project

#### Option A: Using Flutter Command (Recommended)

```bash
# Run on macOS
flutter run -d macos

# Or run in debug mode
flutter run -d macos --debug

# Or run in release mode
flutter run -d macos --release
```

#### Option B: Using Build Script

For x86_64 architecture (Rosetta) build:

```bash
chmod +x build_and_run.sh
./build_and_run.sh
```

This script will:
- Build the app using Xcode for x86_64 architecture
- Automatically launch the app after successful build

### 3. Development

```bash
# Check for issues
flutter analyze

# Run tests
flutter test

# Clean build files
flutter clean
```

## Project Structure

- `lib/` - Main application code
- `macos/` - macOS platform-specific code
- `test/` - Unit and widget tests

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Dart API Reference](https://api.dart.dev/)
