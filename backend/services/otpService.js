// Simulate OTP functions (replace with real SMS provider in prod)
const sentOtps = {};

exports.sendOTP = async (phone) => {
  const otp = (Math.floor(100000 + Math.random() * 900000)).toString();
  sentOtps[phone] = otp;
  // In production, integrate with real SMS provider/API
  console.log(`OTP for ${phone}: ${otp}`);
  return otp;
};

exports.verifyOTP = async (phone, otp) => {
  return sentOtps[phone] === otp;
};

