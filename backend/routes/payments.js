const express = require('express');
const router = express.Router();
const paymentController = require('../controllers/paymentController');
const auth = require('../middlewares/auth');

router.post('/charge', auth('CUSTOMER'), paymentController.chargeForDelivery);
router.post('/release', auth('CUSTOMER'), paymentController.releaseEscrow);

module.exports = router;

