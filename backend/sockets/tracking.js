const { Server } = require('socket.io');
const Delivery = require('../models/Delivery');
const DriverProfile = require('../models/DriverProfile');
const LocationHistory = require('../models/LocationHistory');
const jwt = require('jsonwebtoken');

function setupSocket(server) {
  const io = new Server(server, {
    cors: { origin: '*' }
  });
  const track = io.of('/track');

  // Authenticate every socket connection
  track.use(async (socket, next) => {
    try {
      const token = socket.handshake.auth.token;
      if (!token) return next(new Error('Missing token'));
      const user = jwt.verify(token, process.env.JWT_SECRET);
      socket.user = user;
      next();
    } catch (err) {
      next(new Error('Unauthorized'));
    }
  });

  // Join delivery room
  track.on('connection', (socket) => {
    // Join delivery channel (driver or customer for a given delivery ID)
    socket.on('join-delivery', ({ deliveryId }) => {
      socket.join(deliveryId);
    });

    // Driver updates location
    socket.on('location-update', async ({ deliveryId, lng, lat }) => {
      try {
        // Save location history in DB
        await LocationHistory.create({
          delivery: deliveryId,
          driver: socket.user.id,
          coordinates: { type: 'Point', coordinates: [lng, lat] },
        });
        // Send update to customers and logistics
        track.to(deliveryId).emit('location', { driver: socket.user.id, lng, lat, deliveryId });
      } catch (err) {
        // Silent fail
      }
    });
  });
}

module.exports = { setupSocket };
