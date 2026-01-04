const mongoose = require('mongoose');

const deliverySchema = new mongoose.Schema({
  customer: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  driver: { type: mongoose.Schema.Types.ObjectId, ref: 'DriverProfile' },
  vehicle: { type: mongoose.Schema.Types.ObjectId, ref: 'Vehicle' },
  pickupLocation: {
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: { type: [Number], required: true } // [lng, lat]
  },
  dropoffLocation: {
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: { type: [Number], required: true }
  },
  itemType: { type: String, required: true },
  itemWeight: { type: Number, required: true },
  urgency: { type: String, enum: ['NORMAL', 'URGENT'], default: 'NORMAL' },
  price: { type: Number, required: true },
  status: {
    type: String,
    enum: ['REQUESTED', 'ACCEPTED', 'PICKED_UP', 'IN_TRANSIT', 'DELIVERED'],
    default: 'REQUESTED'
  },
  proofOfDelivery: {
    photoUrl: String,
    signatureUrl: String
  },
  paymentReleased: { type: Boolean, default: false },
}, { timestamps: true });

deliverySchema.index({ pickupLocation: '2dsphere' });
deliverySchema.index({ dropoffLocation: '2dsphere' });

module.exports = mongoose.model('Delivery', deliverySchema);

