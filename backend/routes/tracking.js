const express = require('express');
const router = express.Router();
const trackingController = require('../controllers/trackingController');
const auth = require('../middlewares/auth');

// Update location via REST (fallback for poor networks)
router.post('/update-location', auth('DRIVER'), trackingController.updateLocation);
// Get live polyline for delivery
router.get('/live/:deliveryId', auth(['CUSTOMER', 'LOGISTICS_COMPANY', 'DRIVER']), trackingController.getLiveTracking);

module.exports = router;

