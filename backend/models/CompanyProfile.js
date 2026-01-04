const mongoose = require('mongoose');

const companyProfileSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, unique: true },
  companyName: { type: String, required: true },
  registrationNumber: { type: String },
  address: { type: String },
  drivers: [{ type: mongoose.Schema.Types.ObjectId, ref: 'DriverProfile' }],
  vehicles: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Vehicle' }],
  rating: { type: Number, default: 0 },
}, { timestamps: true });

companyProfileSchema.index({ user: 1 });

module.exports = mongoose.model('CompanyProfile', companyProfileSchema);

