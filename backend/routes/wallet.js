const express = require('express');
const router = express.Router();
const walletController = require('../controllers/walletController');
const auth = require('../middlewares/auth');

router.post('/topup', auth(), walletController.topUp);
router.get('/balance', auth(), walletController.getBalance);

module.exports = router;

