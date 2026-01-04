# Flutter App Deployment Guide

## Prerequisites
- Flutter SDK 3.0+ installed
- Android Studio / Xcode (for mobile builds)
- Google Maps API key
- Firebase project (for push notifications)

## Development Setup

1. Install dependencies:
```bash
flutter pub get
```

2. Configure API endpoint:
Edit `lib/core/constants/constants.dart`:
```dart
static const String apiBaseUrl = 'http://YOUR_BACKEND_IP:5000';
// For Android emulator: 'http://10.0.2.2:5000'
// For iOS simulator: 'http://localhost:5000'
```

3. Run in debug mode:
```bash
flutter run
```

## Android Build

### 1. Configure AndroidManifest.xml

Add Google Maps API key to `android/app/src/main/AndroidManifest.xml`:
```xml
<application>
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
</application>
```

### 2. Build APK
```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### 3. Build App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### 4. Sign APK (if needed)
```bash
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \
  -keystore your-keystore.jks \
  build/app/outputs/flutter-apk/app-release.apk \
  your-key-alias
```

## iOS Build

### 1. Configure Info.plist

Add to `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to track deliveries</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location for real-time tracking</string>
```

### 2. Configure Google Maps

Add to `ios/Runner/AppDelegate.swift`:
```swift
import GoogleMaps

GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
```

### 3. Build iOS
```bash
flutter build ios --release
```

### 4. Archive and Upload
- Open `ios/Runner.xcworkspace` in Xcode
- Product → Archive
- Distribute App → App Store Connect

## Web Build

```bash
flutter build web --release
```

Output: `build/web/`

Deploy to:
- Firebase Hosting
- Netlify
- Vercel
- Any static hosting

## Firebase Hosting (Web)

1. Install Firebase CLI:
```bash
npm install -g firebase-tools
```

2. Login:
```bash
firebase login
```

3. Initialize:
```bash
firebase init hosting
```

4. Build and deploy:
```bash
flutter build web
firebase deploy
```

## Google Play Store Deployment

1. Create app in [Google Play Console](https://play.google.com/console)
2. Upload AAB file
3. Fill in store listing details
4. Submit for review

## Apple App Store Deployment

1. Create app in [App Store Connect](https://appstoreconnect.apple.com)
2. Archive in Xcode
3. Upload via Xcode or Transporter
4. Submit for review

## Environment Configuration

### Development
```dart
// lib/core/constants/constants.dart
static const String apiBaseUrl = 'http://localhost:5000';
```

### Production
```dart
static const String apiBaseUrl = 'https://api.yourdomain.com';
```

Use flavors for different environments:
```bash
flutter run --flavor production
flutter build apk --flavor production
```

## Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/integration_test.dart
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

## Performance Optimization

### Build Size Optimization
```bash
# Analyze build size
flutter build apk --analyze-size

# Build with split per ABI
flutter build apk --split-per-abi
```

### Code Obfuscation
```bash
flutter build apk --release --obfuscate --split-debug-info=./debug-info
```

## Continuous Integration

See `.github/workflows/build.yml` for CI/CD pipeline.

## Troubleshooting

### Build Errors
```bash
# Clean build
flutter clean
flutter pub get
flutter build apk --release
```

### Google Maps Not Showing
- Verify API key is correct
- Check API key restrictions
- Enable Maps SDK in Google Cloud Console

### Socket.IO Connection Issues
- Verify backend URL
- Check CORS settings on backend
- Test with Postman/curl first

## Monitoring

### Crash Reporting
- Integrate Firebase Crashlytics
- Add Sentry for error tracking

### Analytics
- Firebase Analytics
- Google Analytics

