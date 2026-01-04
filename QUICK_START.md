# Quick Start Guide

Get your RMS Logistics Marketplace up and running in 5 minutes!

## Prerequisites Check

- [ ] Node.js 18+ installed (`node --version`)
- [ ] MongoDB installed and running (`mongosh`)
- [ ] Flutter 3.0+ installed (`flutter --version`)
- [ ] Git installed

## Backend Setup (2 minutes)

```bash
# 1. Navigate to backend
cd backend

# 2. Install dependencies
npm install

# 3. Create environment file
cp .env.example .env

# 4. Edit .env (minimal config)
# MONGO_URI=mongodb://localhost:27017/logistics_db
# JWT_SECRET=your_secret_key_here
# JWT_REFRESH_SECRET=your_refresh_secret

# 5. Start MongoDB (if not running)
# Windows: mongod
# Mac/Linux: sudo systemctl start mongod

# 6. Start backend server
npm run dev
```

✅ Backend should be running on `http://localhost:5000`

## Flutter App Setup (2 minutes)

```bash
# 1. Navigate to Flutter app
cd flutter_app

# 2. Install dependencies
flutter pub get

# 3. Update API URL (if needed)
# Edit lib/core/constants/constants.dart
# For Android emulator: http://10.0.2.2:5000
# For iOS simulator: http://localhost:5000

# 4. Run app
flutter run
```

✅ App should launch on your device/emulator

## Quick Test

### Test Backend API

```bash
# Test health endpoint
curl http://localhost:5000/

# Register a test user
curl -X POST http://localhost:5000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"phone":"+1234567890","role":"CUSTOMER","name":"Test User"}'
```

### Test Flutter App

1. Open app
2. Tap "Customer Login"
3. Enter phone number
4. Enter OTP (check console for mock OTP)
5. Should navigate to Customer Dashboard

## Running Tests

### Backend Tests
```bash
cd backend
npm test
```

### Flutter Tests
```bash
cd flutter_app
flutter test
```

## Common Issues

### MongoDB Connection Error
- Ensure MongoDB is running: `mongosh`
- Check `MONGO_URI` in `.env`

### Port Already in Use
```bash
# Find process using port 5000
lsof -i :5000  # Mac/Linux
netstat -ano | findstr :5000  # Windows

# Kill process
kill -9 <PID>  # Mac/Linux
taskkill /PID <PID> /F  # Windows
```

### Flutter Build Errors
```bash
flutter clean
flutter pub get
flutter run
```

## Next Steps

- Read [TESTING.md](TESTING.md) for detailed testing guide
- Read [backend/DEPLOYMENT.md](backend/DEPLOYMENT.md) for production deployment
- Read [flutter_app/DEPLOYMENT.md](flutter_app/DEPLOYMENT.md) for app store deployment

## Need Help?

- Check [README.md](README.md) for full documentation
- Review error logs in console
- Check MongoDB connection: `mongosh logistics_db`

