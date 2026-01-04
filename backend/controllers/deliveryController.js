const Delivery = require('../models/Delivery');
const User = require('../models/User');
const DriverProfile = require('../models/DriverProfile');
const Vehicle = require('../models/Vehicle');
const Joi = require('joi');

// Create delivery request (Customer)
exports.createDelivery = async (req, res) => {
  const schema = Joi.object({
    pickupLocation: Joi.object({
      coordinates: Joi.array().items(Joi.number()).length(2).required(),
    }).required(),
    dropoffLocation: Joi.object({
      coordinates: Joi.array().items(Joi.number()).length(2).required(),
    }).required(),
    itemType: Joi.string().required(),
    itemWeight: Joi.number().required(),
    urgency: Joi.string().valid('NORMAL', 'URGENT').default('NORMAL'),
    vehicleType: Joi.string().valid('BIKE', 'MOTORCYCLE', 'CAR', 'VAN', 'BUS', 'TRUCK', 'CONTAINER').required(),
    price: Joi.number().required()
  });
  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });
  try {
    // Simple price/vehicle check in real app you'd check for vehicle/driver matching
    const delivery = new Delivery({
      customer: req.user.id,
      pickupLocation: { type: 'Point', coordinates: req.body.pickupLocation.coordinates },
      dropoffLocation: { type: 'Point', coordinates: req.body.dropoffLocation.coordinates },
      itemType: req.body.itemType,
      itemWeight: req.body.itemWeight,
      urgency: req.body.urgency,
      price: req.body.price,
      status: 'REQUESTED'
    });
    await delivery.save();
    res.status(201).json(delivery);
  } catch (err) {
    res.status(500).json({ error: 'Could not create delivery' });
  }
};

// Get delivery by id (Customer: own || Driver: assigned)
exports.getDelivery = async (req, res) => {
  try {
    const delivery = await Delivery.findById(req.params.id)
      .populate('customer driver vehicle');
    if (!delivery) return res.status(404).json({ error: 'Not found' });
    // Authorization: customer owns or driver assigned or company owns vehicle
    if (req.user.role === 'CUSTOMER' && delivery.customer.toString() !== req.user.id)
      return res.status(403).json({ error: 'Forbidden' });
    if (req.user.role === 'DRIVER') {
      if (!delivery.driver || delivery.driver.toString() !== req.user.id)
        return res.status(403).json({ error: 'Forbidden' });
    }
    res.json(delivery);
  } catch (err) {
    res.status(500).json({ error: 'Could not fetch delivery' });
  }
};

// Update delivery status (Driver)
exports.updateDeliveryStatus = async (req, res) => {
  const schema = Joi.object({ status: Joi.string().valid('ACCEPTED','PICKED_UP','IN_TRANSIT','DELIVERED').required() });
  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });
  try {
    // Only allow assigned driver to update
    const driverProfile = await DriverProfile.findOne({ user: req.user.id });
    let delivery = await Delivery.findById(req.params.id);
    if (!delivery || !driverProfile || !delivery.driver.equals(driverProfile._id)) {
      return res.status(403).json({ error: 'Not your delivery' });
    }
    delivery.status = req.body.status;
    await delivery.save();
    res.json(delivery);
  } catch (err) {
    res.status(500).json({ error: 'Could not update status' });
  }
};

