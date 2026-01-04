const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  phone: { type: String, required: true, unique: true, index: true },
  email: { type: String, unique: true, sparse: true },
  password: { type: String }, // Optional if using OTP
  role: { 
    type: String, 
    enum: ['CUSTOMER', 'DRIVER', 'LOGISTICS_COMPANY'],
    required: true
  },
  name: { type: String },
  isVerified: { type: Boolean, default: false },
  avatarUrl: { type: String },
  rating: { type: Number, default: 0 },
  // Relations
  driverProfile: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'DriverProfile'
  },
  companyProfile: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'CompanyProfile'
  },
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);

