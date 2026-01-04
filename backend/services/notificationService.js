// Notification Sender (Firebase Cloud Messaging) - stub
// In production: integrate with FCM/fcm-node or firebase-admin
exports.sendNotification = async (token, title, body, data = {}) => {
  // DEMO: Print out instead of real send
  console.log(`[Mock FCM] To: ${token}`);
  console.log(`Title: ${title}`);
  console.log(`Body: ${body}`);
  console.log(`Data:`, data);
  return true;
};

