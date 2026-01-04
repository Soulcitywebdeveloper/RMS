const express = require('express');
const router = express.Router();
const deliveryController = require('../controllers/deliveryController');
const auth = require('../middlewares/auth');

// Customer creates delivery request
router.post('/', auth('CUSTOMER'), deliveryController.createDelivery);
// Get delivery by id (customer can view own, driver can view assigned)
router.get('/:id', auth(['CUSTOMER', 'DRIVER', 'LOGISTICS_COMPANY']), deliveryController.getDelivery);
// Update delivery status (driver only)
router.put('/:id/status', auth('DRIVER'), deliveryController.updateDeliveryStatus);

module.exports = router;

