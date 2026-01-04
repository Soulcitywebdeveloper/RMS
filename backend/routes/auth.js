const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

// Register (phone or email)
router.post('/register', authController.register);
// Login
router.post('/login', authController.login);
// Verify OTP
router.post('/verify-otp', authController.verifyOTP);

module.exports = router;

