const mongoose = require('mongoose');

const vehicleSchema = new mongoose.Schema({
  company: { type: mongoose.Schema.Types.ObjectId, ref: 'CompanyProfile' },
  driver: { type: mongoose.Schema.Types.ObjectId, ref: 'DriverProfile' },
  type: {
    type: String,
    enum: ['BIKE', 'MOTORCYCLE', 'CAR', 'VAN', 'BUS', 'TRUCK', 'CONTAINER'],
    required: true
  },
  plateNumber: { type: String, required: true, unique: true },
  capacityKg: { type: Number, required: true },
  isAvailable: { type: Boolean, default: true },
}, { timestamps: true });

vehicleSchema.index({ type: 1 });

module.exports = mongoose.model('Vehicle', vehicleSchema);

