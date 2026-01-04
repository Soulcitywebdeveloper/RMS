# RMS Logistics Marketplace

A full-stack logistics marketplace application connecting customers, drivers, and logistics companies for real-time delivery tracking and management.

## 🏗️ Architecture

### Backend (Node.js + Express + MongoDB)
- RESTful API with JWT authentication
- Real-time tracking via Socket.IO
- MongoDB with Mongoose for data persistence
- Role-based access control (Customer, Driver, Logistics Company)

### Frontend (Flutter)
- Clean Architecture (MVVM)
- Riverpod for state management
- Google Maps integration for location services
- Socket.IO client for real-time updates

## 📁 Project Structure

```
RMS/
├── backend/              # Node.js backend
│   ├── config/          # Database configuration
│   ├── controllers/     # Request handlers
│   ├── middlewares/     # Auth & validation
│   ├── models/          # Mongoose schemas
│   ├── routes/          # API routes
│   ├── services/        # Business logic
│   ├── sockets/         # Socket.IO handlers
│   └── utils/           # Helpers
│
└── flutter_app/         # Flutter mobile app
    └── lib/
        ├── core/        # Constants, services, utils
        ├── features/    # Feature modules
        │   ├── auth/
        │   ├── customer/
        │   ├── driver/
        │   ├── company/
        │   └── tracking/
        └── shared/      # Reusable widgets
```

## 🚀 Features

### Authentication & Roles
- ✅ Phone number + OTP login
- ✅ Email/password (optional)
- ✅ JWT access & refresh tokens
- ✅ Role-based access: CUSTOMER, DRIVER, LOGISTICS_COMPANY

### Customer Features
- ✅ Create delivery requests
- ✅ Select pickup/drop-off on map
- ✅ View delivery history
- ✅ Live tracking of active deliveries
- ✅ Price estimation

### Driver Features
- ✅ View available jobs
- ✅ Accept/reject delivery requests
- ✅ Start/complete trips
- ✅ Live GPS tracking with route polyline
- ✅ Real-time location updates

### Company Features
- ✅ Fleet management (add/view vehicles)
- ✅ Vehicle assignment to drivers
- ✅ Monitor fleet activity

### Real-Time Tracking
- ✅ Socket.IO for live location updates
- ✅ REST fallback for poor network conditions
- ✅ Google Maps integration
- ✅ Route polylines
- ✅ Delivery status updates

### Payments & Wallet
- ✅ Wallet system
- ✅ Top-up functionality
- ✅ Escrow payment on delivery
- ✅ Release payment on delivery confirmation

## 📦 Database Models

- **User**: Authentication and profile
- **DriverProfile**: Driver-specific data
- **CompanyProfile**: Logistics company data
- **Vehicle**: Fleet vehicles with capacity
- **Delivery**: Delivery requests and status
- **Wallet**: User wallet balance
- **Transaction**: Payment history
- **Rating**: User ratings and reviews
- **LocationHistory**: GPS tracking data

## 🔌 API Endpoints

### Auth
- `POST /auth/register` - Register new user
- `POST /auth/login` - Login (phone+OTP or email+password)
- `POST /auth/verify-otp` - Verify OTP

### Users
- `GET /users/me` - Get current user profile
- `PUT /users/update` - Update profile

### Vehicles
- `POST /vehicles` - Create vehicle (company only)
- `GET /vehicles` - List vehicles
- `PUT /vehicles/:id` - Update vehicle

### Deliveries
- `POST /deliveries` - Create delivery request (customer)
- `GET /deliveries/:id` - Get delivery details
- `PUT /deliveries/:id/status` - Update delivery status (driver)

### Tracking
- `POST /tracking/update-location` - Update location (REST fallback)
- `GET /tracking/live/:deliveryId` - Get live tracking polyline

### Wallet & Payments
- `POST /wallet/topup` - Top up wallet
- `GET /wallet/balance` - Get balance
- `POST /payments/charge` - Charge for delivery (escrow)
- `POST /payments/release` - Release escrow payment

### Proof of Delivery
- `POST /proof/upload` - Upload photo/signature

## 🛠️ Setup Instructions

### Backend Setup

1. Navigate to backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Create `.env` file (copy from `.env.example`):
```bash
cp .env.example .env
```

4. Configure environment variables:
```
PORT=5000
MONGO_URI=mongodb://localhost:27017/logistics_db
JWT_SECRET=your_jwt_secret
JWT_REFRESH_SECRET=your_refresh_secret
```

5. Start MongoDB (if not running):
```bash
# Windows
mongod

# Mac/Linux
sudo systemctl start mongod
```

6. Run the server:
```bash
npm run dev
```

### Flutter App Setup

1. Navigate to Flutter app directory:
```bash
cd flutter_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure API base URL in `lib/core/constants/constants.dart`:
```dart
static const String apiBaseUrl = 'http://YOUR_IP:5000';
// For Android emulator: use 'http://10.0.2.2:5000'
// For iOS simulator: use 'http://localhost:5000'
```

4. Run the app:
```bash
flutter run
```

## 🔐 Security Features

- JWT token authentication
- Role-based authorization middleware
- Input validation with Joi
- Password hashing with bcrypt
- Rate limiting on API endpoints
- Secure environment variables

## 📱 Flutter App Features

### Screens Implemented
- ✅ Startup/Role selection
- ✅ Phone login & OTP verification
- ✅ Customer dashboard
- ✅ Create delivery request
- ✅ Delivery history
- ✅ Customer live tracking
- ✅ Driver dashboard
- ✅ Driver job list
- ✅ Driver live tracking
- ✅ Company dashboard
- ✅ Fleet management

### State Management
- Riverpod for reactive state
- AsyncValue for loading/error states
- StateNotifier for business logic

## 🗺️ Google Maps Setup

1. Get Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
2. Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<application>
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_API_KEY"/>
</application>
```
3. Add to `ios/Runner/AppDelegate.swift` (for iOS)

## 🔔 Push Notifications (FCM)

Notification service is stubbed. To enable:
1. Add Firebase configuration files
2. Update `lib/core/services/notification_service.dart`
3. Configure FCM server key in backend `.env`

## 🧪 Testing

See [TESTING.md](TESTING.md) for comprehensive testing guide.

### Quick Test
```bash
# Backend tests
cd backend && npm test

# Flutter tests
cd flutter_app && flutter test
```

### Manual API Testing
Use Postman or curl to test endpoints:
```bash
# Register
curl -X POST http://localhost:5000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"phone":"+1234567890","role":"CUSTOMER","name":"Test User"}'

# Login
curl -X POST http://localhost:5000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"phone":"+1234567890","otp":"123456"}'
```

## 📝 Notes

- OTP service is currently mocked (logs to console)
- Image upload for proof of delivery accepts URLs (Cloudinary integration ready)
- Socket.IO tracking works with JWT token authentication
- All endpoints include proper error handling and validation

## 🚀 Quick Start

New to the project? Start here:
- [QUICK_START.md](QUICK_START.md) - Get running in 5 minutes
- [TESTING.md](TESTING.md) - Comprehensive testing guide
- [backend/DEPLOYMENT.md](backend/DEPLOYMENT.md) - Backend deployment guide
- [flutter_app/DEPLOYMENT.md](flutter_app/DEPLOYMENT.md) - Flutter app deployment

## 🚧 Future Enhancements

- [ ] Real SMS OTP integration
- [ ] Cloudinary image upload
- [ ] Firebase Cloud Messaging push notifications
- [ ] Advanced pricing algorithms
- [ ] Driver auto-assignment based on proximity
- [ ] Delivery rating system
- [ ] Analytics dashboard
- [ ] Multi-language support

## 📄 License

This project is built for educational/demonstration purposes.

## 👥 Support

For issues or questions, please refer to the codebase documentation or create an issue in the repository.

