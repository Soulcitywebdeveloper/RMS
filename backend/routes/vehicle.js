const express = require('express');
const router = express.Router();
const vehicleController = require('../controllers/vehicleController');
const auth = require('../middlewares/auth');

// Create a vehicle (company only)
router.post('/', auth('LOGISTICS_COMPANY'), vehicleController.createVehicle);
// List vehicles (company sees own fleet, driver sees assigned)
router.get('/', auth(['LOGISTICS_COMPANY', 'DRIVER']), vehicleController.listVehicles);
// Update vehicle (company)
router.put('/:id', auth('LOGISTICS_COMPANY'), vehicleController.updateVehicle);

module.exports = router;

