const http = require('http');
const app = require('./app');
const connectDB = require('./config/db');
const { setupSocket } = require('./sockets/tracking');

const PORT = process.env.PORT || 5000;

const server = http.createServer(app);
// Initialize Socket.IO
enableSockets(server);

// Database
connectDB();

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

// Helper to configure Socket.IO
function enableSockets(server) {
  setupSocket(server); // Will implement
}

