const express = require('express');
const router = express.Router();
const proofController = require('../controllers/proofController');
const auth = require('../middlewares/auth');

// Photo and signature upload for proof of delivery
router.post('/upload', auth('DRIVER'), proofController.uploadProof);

module.exports = router;

