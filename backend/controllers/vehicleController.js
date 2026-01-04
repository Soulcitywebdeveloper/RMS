const Vehicle = require('../models/Vehicle');
const CompanyProfile = require('../models/CompanyProfile');
const DriverProfile = require('../models/DriverProfile');
const Joi = require('joi');

// Company creates vehicle
exports.createVehicle = async (req, res) => {
  const schema = Joi.object({
    type: Joi.string().valid('BIKE', 'MOTORCYCLE', 'CAR', 'VAN', 'BUS', 'TRUCK', 'CONTAINER').required(),
    plateNumber: Joi.string().required(),
    capacityKg: Joi.number().required()
  });
  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });
  try {
    // Find company profile
    const companyProfile = await CompanyProfile.findOne({ user: req.user.id });
    if (!companyProfile) return res.status(403).json({ error: 'Not a company user' });
    const vehicle = new Vehicle({ ...req.body, company: companyProfile._id });
    await vehicle.save();
    companyProfile.vehicles.push(vehicle._id);
    await companyProfile.save();
    res.status(201).json(vehicle);
  } catch (err) {
    res.status(500).json({ error: 'Could not create vehicle' });
  }
};

// List vehicles
exports.listVehicles = async (req, res) => {
  try {
    if (req.user.role === 'LOGISTICS_COMPANY') {
      const companyProfile = await CompanyProfile.findOne({ user: req.user.id });
      if (!companyProfile) return res.status(403).json({ error: 'No company profile' });
      const vehicles = await Vehicle.find({ company: companyProfile._id });
      return res.json(vehicles);
    }
    if (req.user.role === 'DRIVER') {
      const driverProfile = await DriverProfile.findOne({ user: req.user.id });
      if (!driverProfile) return res.status(403).json({ error: 'No driver profile' });
      const vehicles = await Vehicle.find({ driver: driverProfile._id });
      return res.json(vehicles);
    }
    res.status(403).json({ error: 'Unauthorized' });
  } catch (err) {
    res.status(500).json({ error: 'Could not fetch vehicles' });
  }
};

// Company updates vehicle
exports.updateVehicle = async (req, res) => {
  const updates = (({ type, plateNumber, capacityKg, isAvailable, driver }) => ({ type, plateNumber, capacityKg, isAvailable, driver }))(req.body);
  try {
    const companyProfile = await CompanyProfile.findOne({ user: req.user.id });
    if (!companyProfile) return res.status(403).json({ error: 'Unauthorized' });
    let vehicle = await Vehicle.findOne({ _id: req.params.id, company: companyProfile._id });
    if (!vehicle) return res.status(404).json({ error: 'Vehicle not found' });
    // Optionally assign to driver
    if (updates.driver) {
      const driverProfile = await DriverProfile.findById(updates.driver);
      if (!driverProfile) return res.status(400).json({ error: 'Driver not found' });
      vehicle.driver = driverProfile._id;
      // Add vehicle to driver's profile if not already
      if (!driverProfile.vehicles.includes(vehicle._id)) {
        driverProfile.vehicles.push(vehicle._id);
        await driverProfile.save();
      }
    }
    Object.assign(vehicle, updates);
    await vehicle.save();
    res.json(vehicle);
  } catch (err) {
    res.status(500).json({ error: 'Could not update vehicle' });
  }
};

