const Delivery = require('../models/Delivery');
const DriverProfile = require('../models/DriverProfile');
const Joi = require('joi');

// Mock upload handler for proof of delivery (photo, signature)
exports.uploadProof = async (req, res) => {
  // In future, use multer or direct upload to Cloudinary/Firebase
  const schema = Joi.object({
    deliveryId: Joi.string().required(),
    photoUrl: Joi.string().optional(),
    signatureUrl: Joi.string().optional()
  });
  const { error } = schema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });
  try {
    const driverProfile = await DriverProfile.findOne({ user: req.user.id });
    const delivery = await Delivery.findById(req.body.deliveryId);
    if (!driverProfile || !delivery || !delivery.driver.equals(driverProfile._id))
      return res.status(403).json({ error: 'Unauthorized' });
    // Assume URLs are uploaded already if testing; store refs
    delivery.proofOfDelivery = {
      photoUrl: req.body.photoUrl,
      signatureUrl: req.body.signatureUrl
    };
    await delivery.save();
    res.json({ status: 'Proof attached' });
  } catch (err) {
    res.status(500).json({ error: 'Failed to upload proof' });
  }
};

