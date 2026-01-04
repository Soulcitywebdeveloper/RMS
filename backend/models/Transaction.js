const mongoose = require('mongoose');

const transactionSchema = new mongoose.Schema({
  wallet: { type: mongoose.Schema.Types.ObjectId, ref: 'Wallet', required: true },
  amount: { type: Number, required: true },
  type: { type: String, enum: ['TOPUP', 'CHARGE', 'RELEASE'], required: true },
  status: { type: String, enum: ['PENDING', 'SUCCESS', 'FAILED'], required: true },
  details: { type: String },
}, { timestamps: true });

transactionSchema.index({ wallet: 1 });

module.exports = mongoose.model('Transaction', transactionSchema);

