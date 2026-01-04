const Wallet = require('../models/Wallet');
const Transaction = require('../models/Transaction');
const Delivery = require('../models/Delivery');
const Joi = require('joi');

// Charge and hold funds (escrow)
exports.chargeForDelivery = async (req, res) => {
  const schema = Joi.object({
    deliveryId: Joi.string().required(),
    amount: Joi.number().min(1).required()
  });
  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });
  try {
    const wallet = await Wallet.findOne({ user: req.user.id });
    if (!wallet || wallet.balance < req.body.amount) return res.status(400).json({ error: 'Insufficient balance' });
    let delivery = await Delivery.findById(req.body.deliveryId);
    if (!delivery || delivery.customer.toString() !== req.user.id) return res.status(403).json({ error: 'Not your delivery' });
    wallet.balance -= req.body.amount;
    await wallet.save();
    await Transaction.create({ wallet: wallet._id, amount: req.body.amount, type: 'CHARGE', status: 'SUCCESS' });
    delivery.paymentReleased = false;
    await delivery.save();
    res.json({ balance: wallet.balance });
  } catch (err) {
    res.status(500).json({ error: 'Could not charge for delivery' });
  }
};

// Release escrow on delivery confirmation
exports.releaseEscrow = async (req, res) => {
  const schema = Joi.object({ deliveryId: Joi.string().required() });
  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });
  try {
    let delivery = await Delivery.findById(req.body.deliveryId);
    if (!delivery || delivery.customer.toString() !== req.user.id)
      return res.status(403).json({ error: 'Not your delivery' });
    if (delivery.status !== 'DELIVERED')
      return res.status(400).json({ error: 'Delivery not completed' });
    if (delivery.paymentReleased)
      return res.status(400).json({ error: 'Escrow already released' });
    // For demo: simulate pay to driver/owner if desired
    delivery.paymentReleased = true;
    await delivery.save();
    await Transaction.create({ wallet: null, amount: 0, type: 'RELEASE', status: 'SUCCESS', details: `Delivery ${delivery._id}` });
    res.json({ status: 'Payment released' });
  } catch (err) {
    res.status(500).json({ error: 'Could not release payment' });
  }
};

