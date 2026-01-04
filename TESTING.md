# Testing Guide

## Backend Testing

### Setup
```bash
cd backend
npm install
```

### Run Tests
```bash
# Run all tests
npm test

# Run with coverage
npm test -- --coverage

# Watch mode
npm run test:watch
```

### Test Structure
- `tests/auth.test.js` - Authentication endpoints
- `tests/delivery.test.js` - Delivery CRUD operations

### Manual API Testing

#### Using cURL

**Register User:**
```bash
curl -X POST http://localhost:5000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "phone": "+1234567890",
    "role": "CUSTOMER",
    "name": "Test User"
  }'
```

**Login:**
```bash
curl -X POST http://localhost:5000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "phone": "+1234567890",
    "otp": "123456"
  }'
```

**Create Delivery (with token):**
```bash
curl -X POST http://localhost:5000/deliveries \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "pickupLocation": {"coordinates": [3.3792, 6.5244]},
    "dropoffLocation": {"coordinates": [3.3793, 6.5245]},
    "itemType": "Package",
    "itemWeight": 5,
    "urgency": "NORMAL",
    "vehicleType": "CAR",
    "price": 2000
  }'
```

#### Using Postman

1. Import collection (create from above examples)
2. Set environment variables:
   - `base_url`: http://localhost:5000
   - `token`: (set after login)

### Test Database
Tests use separate database: `logistics_test`
- Automatically cleaned after tests
- No impact on development data

## Flutter Testing

### Unit Tests
```bash
cd flutter_app
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter test integration_test/integration_test.dart
```

### Manual Testing Checklist

#### Authentication Flow
- [ ] Startup screen shows all role options
- [ ] Phone login screen accepts phone number
- [ ] OTP screen accepts OTP code
- [ ] Successful login navigates to correct dashboard

#### Customer Flow
- [ ] Can create new delivery request
- [ ] Map picker works for pickup/dropoff
- [ ] Delivery appears in history
- [ ] Live tracking shows driver location

#### Driver Flow
- [ ] Can view available jobs
- [ ] Can accept/reject jobs
- [ ] Can start trip
- [ ] Live tracking updates location

#### Company Flow
- [ ] Can view fleet
- [ ] Can add new vehicle
- [ ] Vehicle appears in list

### Test Devices
- Android Emulator (API 30+)
- iOS Simulator (iOS 14+)
- Physical devices (recommended for GPS testing)

## End-to-End Testing

### Scenario 1: Complete Delivery Flow

1. **Customer creates delivery:**
   - Register as customer
   - Create delivery request
   - Verify delivery appears in history

2. **Driver accepts and completes:**
   - Register as driver
   - View available jobs
   - Accept delivery
   - Start trip
   - Complete trip

3. **Customer tracks delivery:**
   - View delivery in history
   - Open live tracking
   - Verify location updates

### Scenario 2: Payment Flow

1. Customer tops up wallet
2. Customer creates delivery (payment charged)
3. Delivery completed
4. Payment released

## Performance Testing

### Backend Load Testing
Use Apache Bench or Artillery:
```bash
# Install Artillery
npm install -g artillery

# Run load test
artillery quick --count 100 --num 10 http://localhost:5000/
```

### Flutter Performance
```bash
# Profile app
flutter run --profile

# Analyze performance
flutter build apk --profile
```

## Security Testing

### Authentication
- [ ] JWT tokens expire correctly
- [ ] Invalid tokens are rejected
- [ ] Role-based access works

### Input Validation
- [ ] SQL injection attempts fail
- [ ] XSS attempts are sanitized
- [ ] Invalid data is rejected

## API Testing Tools

### Recommended Tools
1. **Postman** - GUI for API testing
2. **Insomnia** - Alternative to Postman
3. **Thunder Client** - VS Code extension
4. **curl** - Command line testing

### Postman Collection
Create collection with:
- Environment variables
- Pre-request scripts (auto-login)
- Test assertions
- Collection runner for E2E tests

## Continuous Testing

### GitHub Actions
Tests run automatically on:
- Push to main/develop
- Pull requests

See `.github/workflows/` for configuration.

## Debugging

### Backend
```bash
# Enable debug logging
DEBUG=* npm run dev

# Check MongoDB
mongosh
use logistics_db
db.deliveries.find()
```

### Flutter
```bash
# Run with verbose logging
flutter run --verbose

# Check logs
flutter logs
```

## Test Coverage Goals

- Backend: 70%+ coverage
- Critical paths: 90%+ coverage
- Flutter: 60%+ coverage

## Reporting Issues

When reporting test failures:
1. Include test output/logs
2. Specify environment (OS, Node/Flutter version)
3. Include steps to reproduce
4. Attach relevant screenshots/logs

