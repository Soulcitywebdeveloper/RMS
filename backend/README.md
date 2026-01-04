# Logistics Marketplace Backend

## Setup

1. Copy `.env.example` to `.env` and fill in secrets:
   ```bash
   cp .env.example .env
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start local development server:
   ```bash
   npm run dev
   ```
4. Connect MongoDB (see `.env`)

## Features
- JWT authentication with roles (Customer, Driver, Logistics_Company)
- OTP and Email/Password login support
- REST API (Express.js)
- Live tracking: Socket.IO
- MongoDB schemas for Users, Deliveries, Vehicles, etc.

## Project Structure
```
/config      # Configuration (DB, etc)
/controllers
/middlewares
/models      # Mongoose schemas
/routes
/services    # Business logic
/sockets     # Realtime logic
/utils       # Helpers
app.js       # Express app setup
server.js    # Entry
```

