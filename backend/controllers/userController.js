const User = require('../models/User');
const Joi = require('joi');

exports.getMe = async (req, res) => {
  try {
    const user = await User.findById(req.user.id)
      .select('-password')
      .populate('driverProfile companyProfile');
    if (!user) return res.status(404).json({ error: 'User not found' });
    res.json(user);
  } catch (err) {
    res.status(500).json({ error: 'Server error' });
  }
};

exports.updateUser = async (req, res) => {
  const schema = Joi.object({
    name: Joi.string().optional(),
    avatarUrl: Joi.string().optional(),
    email: Joi.string().email().optional(),
  });
  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });

  try {
    const user = await User.findByIdAndUpdate(req.user.id, req.body, { new: true })
      .select('-password');
    res.json(user);
  } catch (err) {
    res.status(500).json({ error: 'Update failed' });
  }
};

