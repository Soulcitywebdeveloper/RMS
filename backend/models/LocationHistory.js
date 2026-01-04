const mongoose = require('mongoose');

const locationHistorySchema = new mongoose.Schema({
  delivery: { type: mongoose.Schema.Types.ObjectId, ref: 'Delivery', required: true },
  driver: { type: mongoose.Schema.Types.ObjectId, ref: 'DriverProfile', required: true },
  coordinates: {
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: { type: [Number], required: true }
  },
  recordedAt: { type: Date, default: Date.now }
});

locationHistorySchema.index({ coordinates: '2dsphere' });
locationHistorySchema.index({ delivery: 1 });

module.exports = mongoose.model('LocationHistory', locationHistorySchema);

