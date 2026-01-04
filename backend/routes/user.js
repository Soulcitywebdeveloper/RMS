const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const auth = require('../middlewares/auth');

// Get logged-in user profile
router.get('/me', auth(), userController.getMe);
// Update user
router.put('/update', auth(), userController.updateUser);

module.exports = router;

