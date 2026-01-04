const mongoose = require('mongoose');

const driverProfileSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, unique: true },
  vehicles: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Vehicle' }],
  licenceNumber: { type: String },
  documents: [{ url: String, type: String }],
  isAvailable: { type: Boolean, default: false },
  onlineStatus: { type: Boolean, default: false },
  rating: { type: Number, default: 0 },
}, { timestamps: true });

driverProfileSchema.index({ user: 1 });

module.exports = mongoose.model('DriverProfile', driverProfileSchema);

