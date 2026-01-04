const User = require('../models/User');
const DriverProfile = require('../models/DriverProfile');
const CompanyProfile = require('../models/CompanyProfile');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const Joi = require('joi');
const { sendOTP, verifyOTP } = require('../services/otpService');

// Registration logic: phone/email and role
exports.register = async (req, res) => {
  const schema = Joi.object({
    phone: Joi.string().required(),
    email: Joi.string().email().optional(),
    password: Joi.string().min(6).optional(),
    role: Joi.string().valid('CUSTOMER', 'DRIVER', 'LOGISTICS_COMPANY').required(),
    name: Joi.string().required()
  });
  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });

  const { phone, email, password, role, name } = req.body;

  try {
    let user = await User.findOne({ phone });
    if (user) return res.status(409).json({ error: 'Phone already registered' });
    if (email && await User.findOne({ email }))
      return res.status(409).json({ error: 'Email already registered' });

    const hash = password ? await bcrypt.hash(password, 10) : undefined;
    user = new User({ phone, email, password: hash, role, name });
    await user.save();

    // OTP sending (simulate for now)
    await sendOTP(phone);
    res.status(201).json({ message: 'Registered. OTP sent.' });
  } catch (err) {
    res.status(500).json({ error: 'Server error' });
  }
};

// Login logic (phone+otp or email+password)
exports.login = async (req, res) => {
  const schema = Joi.object({
    phone: Joi.string(),
    email: Joi.string().email(),
    password: Joi.string(),
    otp: Joi.string()
  });

  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });

  const { phone, email, password, otp } = req.body;

  try {
    let user;
    if (phone && otp) {
      user = await User.findOne({ phone });
      if (!user) return res.status(404).json({ error: 'User not found' });
      const otpValid = await verifyOTP(phone, otp);
      if (!otpValid) return res.status(400).json({ error: 'Invalid OTP' });
      user.isVerified = true;
      await user.save();
    } else if (email && password) {
      user = await User.findOne({ email });
      if (!user) return res.status(404).json({ error: 'User not found' });
      const valid = await bcrypt.compare(password, user.password);
      if (!valid) return res.status(401).json({ error: 'Invalid credentials' });
    } else {
      return res.status(400).json({ error: 'Invalid login data' });
    }
    // Authenticated: issue JWT
    const payload = { id: user._id, role: user.role };
    const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '1h' });
    const refresh = jwt.sign(payload, process.env.JWT_REFRESH_SECRET, { expiresIn: '7d' });
    res.json({ token, refresh });
  } catch (err) {
    res.status(500).json({ error: 'Login failed' });
  }
};

// OTP Verification endpoint
exports.verifyOTP = async (req, res) => {
  const schema = Joi.object({
    phone: Joi.string().required(),
    otp: Joi.string().required()
  });
  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });

  const { phone, otp } = req.body;
  try {
    const valid = await verifyOTP(phone, otp);
    if (!valid) return res.status(400).json({ error: 'Invalid OTP' });
    // Mark as verified
    const user = await User.findOne({ phone });
    if (user) {
      user.isVerified = true;
      await user.save();
    }
    res.json({ message: 'OTP verified.' });
  } catch (err) {
    res.status(500).json({ error: 'OTP verification failed' });
  }
};

