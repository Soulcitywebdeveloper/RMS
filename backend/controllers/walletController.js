const Wallet = require('../models/Wallet');
const Transaction = require('../models/Transaction');
const Joi = require('joi');

exports.topUp = async (req, res) => {
  const schema = Joi.object({
    amount: Joi.number().min(1).required()
  });
  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });
  try {
    let wallet = await Wallet.findOne({ user: req.user.id });
    if (!wallet) wallet = await Wallet.create({ user: req.user.id, balance: 0 });
    wallet.balance += req.body.amount;
    await wallet.save();
    await Transaction.create({ wallet: wallet._id, amount: req.body.amount, type: 'TOPUP', status: 'SUCCESS' });
    res.json({ balance: wallet.balance });
  } catch (err) {
    res.status(500).json({ error: 'Could not top up' });
  }
};

exports.getBalance = async (req, res) => {
  try {
    let wallet = await Wallet.findOne({ user: req.user.id });
    if (!wallet) wallet = await Wallet.create({ user: req.user.id, balance: 0 });
    res.json({ balance: wallet.balance });
  } catch (err) {
    res.status(500).json({ error: 'Could not fetch balance' });
  }
};

