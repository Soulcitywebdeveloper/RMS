# Build script for Flutter app (PowerShell)

Write-Host "Building RMS Logistics App..." -ForegroundColor Green

# Add Flutter to PATH
$env:Path += ";C:\Users\salzm\OneDrive\Desktop\flutter\bin"

# Clean previous builds
Write-Host "Cleaning previous builds..." -ForegroundColor Yellow
flutter clean

# Get dependencies
Write-Host "Getting dependencies..." -ForegroundColor Yellow
flutter pub get

# Run tests
Write-Host "Running tests..." -ForegroundColor Yellow
flutter test

# Build APK for Android
Write-Host "Building Android APK..." -ForegroundColor Yellow
flutter build apk --release

# Build Web (optional)
Write-Host "Building Web app..." -ForegroundColor Yellow
flutter build web --release

Write-Host "Build complete!" -ForegroundColor Green
Write-Host "APK location: build/app/outputs/flutter-apk/app-release.apk" -ForegroundColor Cyan
Write-Host "Web build location: build/web/" -ForegroundColor Cyan

