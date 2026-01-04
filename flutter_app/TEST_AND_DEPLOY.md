# Testing and Deployment Guide

## Testing Status

✅ **Code Quality:**
- ✅ Linting: All files pass Flutter linting checks
- ✅ Code Structure: Footer widget added successfully
- ✅ No compilation errors detected

## Pre-Deployment Checklist

### 1. Testing Commands

Run these commands in PowerShell from the `flutter_app` directory:

```powershell
# Add Flutter to PATH (if not already added)
$env:Path += ";C:\Users\salzm\OneDrive\Desktop\flutter\bin"

# Run unit and widget tests
flutter test

# Run integration tests (requires device/emulator)
flutter test test/integration_test.dart

# Analyze code
flutter analyze
```

### 2. Manual Testing Checklist

- [ ] Startup screen displays correctly with footer
- [ ] Customer login flow works
- [ ] Driver login flow works
- [ ] Company login flow works
- [ ] Footer appears on all dashboards
- [ ] Navigation between screens works
- [ ] API endpoints are configured correctly

## Deployment Steps

### For Android APK

1. **Configure API Endpoint** (if needed):
   Edit `lib/core/constants/constants.dart`:
   ```dart
   static const String apiBaseUrl = 'https://your-production-api.com';
   ```

2. **Build Release APK**:
   ```powershell
   cd flutter_app
   $env:Path += ";C:\Users\salzm\OneDrive\Desktop\flutter\bin"
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

3. **Output Location**:
   - APK: `build/app/outputs/flutter-apk/app-release.apk`

### For Android App Bundle (Google Play Store)

```powershell
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### For Web Deployment

```powershell
flutter build web --release
```

Output: `build/web/` (deploy to any static hosting)

### Using the Build Script

You can use the PowerShell build script:

```powershell
cd flutter_app
.\build.ps1
```

## Deployment Options

### 1. Google Play Store
1. Create app in [Google Play Console](https://play.google.com/console)
2. Upload the `.aab` file from `build/app/outputs/bundle/release/`
3. Fill in store listing details
4. Submit for review

### 2. Direct APK Distribution
- Share the APK file directly
- Users can install by enabling "Install from unknown sources"
- APK location: `build/app/outputs/flutter-apk/app-release.apk`

### 3. Web Deployment
- Deploy `build/web/` folder to:
  - Firebase Hosting
  - Netlify
  - Vercel
  - Any static hosting service

### 4. Firebase Hosting (Web)

```powershell
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize (if not already done)
firebase init hosting

# Build and deploy
flutter build web --release
firebase deploy
```

## Important Notes

1. **Google Maps API Key**: If using Google Maps, ensure API key is configured in:
   - `android/app/src/main/AndroidManifest.xml` (for Android)
   - `ios/Runner/AppDelegate.swift` (for iOS)

2. **Backend API**: Update the API endpoint in `lib/core/constants/constants.dart` for production

3. **Firebase**: Ensure Firebase is configured if using push notifications

4. **Signing**: For Play Store, you'll need a signing key. See DEPLOYMENT.md for details

## Quick Build Commands

```powershell
# Clean build
flutter clean && flutter pub get && flutter build apk --release

# Build with size analysis
flutter build apk --release --analyze-size

# Build split APKs (smaller size per architecture)
flutter build apk --release --split-per-abi
```

## Troubleshooting

If build fails:
1. Run `flutter doctor` to check Flutter setup
2. Ensure Android SDK is installed
3. Check `pubspec.yaml` dependencies are resolved
4. Try `flutter clean` then rebuild

## Footer Implementation

✅ Footer "All copyright reserved to SoulcityTech" has been added to:
- Startup View
- Customer Dashboard
- Company Dashboard
- Driver Dashboard

Footer widget location: `lib/shared/footer_widget.dart`

