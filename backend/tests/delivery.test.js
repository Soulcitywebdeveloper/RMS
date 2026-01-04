const request = require('supertest');
const app = require('../app');
const mongoose = require('mongoose');
const User = require('../models/User');
const Delivery = require('../models/Delivery');
const jwt = require('jsonwebtoken');

describe('Delivery Endpoints', () => {
  let customerToken;
  let customerId;

  beforeAll(async () => {
    await mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/logistics_test');
    // Create test customer
    const customer = await User.create({
      phone: '+1234567890',
      role: 'CUSTOMER',
      name: 'Test Customer'
    });
    customerId = customer._id;
    customerToken = jwt.sign({ id: customerId, role: 'CUSTOMER' }, process.env.JWT_SECRET || 'test_secret');
  });

  afterAll(async () => {
    await mongoose.connection.dropDatabase();
    await mongoose.connection.close();
  });

  beforeEach(async () => {
    await Delivery.deleteMany({});
  });

  describe('POST /deliveries', () => {
    it('should create delivery request', async () => {
      const res = await request(app)
        .post('/deliveries')
        .set('Authorization', `Bearer ${customerToken}`)
        .send({
          pickupLocation: { coordinates: [3.3792, 6.5244] },
          dropoffLocation: { coordinates: [3.3793, 6.5245] },
          itemType: 'Package',
          itemWeight: 5,
          urgency: 'NORMAL',
          vehicleType: 'CAR',
          price: 2000
        });
      expect(res.statusCode).toBe(201);
      expect(res.body.status).toBe('REQUESTED');
    });

    it('should require authentication', async () => {
      const res = await request(app).post('/deliveries').send({});
      expect(res.statusCode).toBe(401);
    });
  });

  describe('GET /deliveries/:id', () => {
    it('should get delivery by id', async () => {
      const delivery = await Delivery.create({
        customer: customerId,
        pickupLocation: { type: 'Point', coordinates: [3.3792, 6.5244] },
        dropoffLocation: { type: 'Point', coordinates: [3.3793, 6.5245] },
        itemType: 'Package',
        itemWeight: 5,
        price: 2000,
        status: 'REQUESTED'
      });
      const res = await request(app)
        .get(`/deliveries/${delivery._id}`)
        .set('Authorization', `Bearer ${customerToken}`);
      expect(res.statusCode).toBe(200);
      expect(res.body._id).toBe(delivery._id.toString());
    });
  });
});

