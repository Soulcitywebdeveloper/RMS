const mongoose = require('mongoose');

const ratingSchema = new mongoose.Schema({
  from: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  to: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  rating: { type: Number, min: 1, max: 5, required: true },
  review: { type: String },
}, { timestamps: true });

ratingSchema.index({ to: 1 });

module.exports = mongoose.model('Rating', ratingSchema);

