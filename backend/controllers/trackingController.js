const LocationHistory = require('../models/LocationHistory');
const Delivery = require('../models/Delivery');
const DriverProfile = require('../models/DriverProfile');
const Joi = require('joi');

// Update location (REST fallback)
exports.updateLocation = async (req, res) => {
  const schema = Joi.object({
    deliveryId: Joi.string().required(),
    lng: Joi.number().required(),
    lat: Joi.number().required()
  });
  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });
  try {
    const driverProfile = await DriverProfile.findOne({ user: req.user.id });
    if (!driverProfile) return res.status(403).json({ error: 'Not a driver' });
    await LocationHistory.create({
      delivery: req.body.deliveryId,
      driver: driverProfile._id,
      coordinates: { type: 'Point', coordinates: [req.body.lng, req.body.lat] },
    });
    res.json({ status: 'Location updated' });
  } catch (err) {
    res.status(500).json({ error: 'Failed to update location' });
  }
};

// Get live tracking polyline for delivery
exports.getLiveTracking = async (req, res) => {
  try {
    const points = await LocationHistory.find({ delivery: req.params.deliveryId })
      .sort('recordedAt');
    res.json(points.map(pt => ({ lng: pt.coordinates.coordinates[0], lat: pt.coordinates.coordinates[1], t: pt.recordedAt })));
  } catch (err) {
    res.status(500).json({ error: 'Could not fetch tracking path' });
  }
};

