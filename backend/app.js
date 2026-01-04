require('dotenv').config();
const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const rateLimit = require('express-rate-limit');

const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/user');
const vehicleRoutes = require('./routes/vehicle');
const deliveryRoutes = require('./routes/delivery');
const trackingRoutes = require('./routes/tracking');
const walletRoutes = require('./routes/wallet');
const paymentRoutes = require('./routes/payments');
const proofRoutes = require('./routes/proof');

const app = express();

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(morgan('dev'));

// Rate Limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
});
app.use(limiter);

// Routes
app.use('/auth', authRoutes);
app.use('/users', userRoutes);
app.use('/vehicles', vehicleRoutes);
app.use('/deliveries', deliveryRoutes);
app.use('/tracking', trackingRoutes);
app.use('/wallet', walletRoutes);
app.use('/payments', paymentRoutes);
app.use('/proof', proofRoutes);

app.get('/', (req, res) => res.json({ status: 'API Running' }));

module.exports = app;

