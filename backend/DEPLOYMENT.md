# Deployment Guide

## Prerequisites
- Node.js 18+ installed
- MongoDB installed and running
- PM2 installed globally (`npm install -g pm2`)
- Docker (optional, for containerized deployment)

## Local Development

1. Install dependencies:
```bash
npm install
```

2. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your values
```

3. Start MongoDB:
```bash
# Windows
mongod

# Mac/Linux
sudo systemctl start mongod
```

4. Run in development mode:
```bash
npm run dev
```

## Production Deployment

### Option 1: PM2 (Recommended for VPS)

1. Install PM2:
```bash
npm install -g pm2
```

2. Start application:
```bash
pm2 start ecosystem.config.js --env production
```

3. Save PM2 configuration:
```bash
pm2 save
pm2 startup
```

4. Monitor:
```bash
pm2 status
pm2 logs rms-backend
```

### Option 2: Docker

1. Build and run with Docker Compose:
```bash
docker-compose up -d
```

2. View logs:
```bash
docker-compose logs -f backend
```

3. Stop services:
```bash
docker-compose down
```

### Option 3: Manual Node.js

1. Set production environment:
```bash
export NODE_ENV=production
```

2. Start application:
```bash
node server.js
```

Or use a process manager like `forever` or `systemd`.

## Environment Variables (Production)

Required variables in `.env`:
```
NODE_ENV=production
PORT=5000
MONGO_URI=mongodb://your-mongodb-host:27017/logistics_db
JWT_SECRET=your_strong_secret_key_here
JWT_REFRESH_SECRET=your_refresh_secret_here
OTP_SECRET=your_otp_secret
```

## MongoDB Setup

### Local MongoDB
```bash
# Create database
mongo
use logistics_db
```

### MongoDB Atlas (Cloud)
1. Create cluster at [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Get connection string
3. Update `MONGO_URI` in `.env`

## Nginx Reverse Proxy (Optional)

Example Nginx configuration:
```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

## SSL/HTTPS Setup

1. Install Certbot:
```bash
sudo apt-get install certbot python3-certbot-nginx
```

2. Obtain certificate:
```bash
sudo certbot --nginx -d your-domain.com
```

## Monitoring

### PM2 Monitoring
```bash
pm2 monit
```

### Health Check Endpoint
```bash
curl http://localhost:5000/
```

## Backup Strategy

### MongoDB Backup
```bash
# Backup
mongodump --uri="mongodb://localhost:27017/logistics_db" --out=/backup/$(date +%Y%m%d)

# Restore
mongorestore --uri="mongodb://localhost:27017/logistics_db" /backup/20240101
```

## Troubleshooting

### Port Already in Use
```bash
# Find process
lsof -i :5000
# Kill process
kill -9 <PID>
```

### MongoDB Connection Issues
- Check MongoDB is running: `mongosh`
- Verify connection string in `.env`
- Check firewall rules

### PM2 Issues
```bash
# Restart app
pm2 restart rms-backend

# Delete and recreate
pm2 delete rms-backend
pm2 start ecosystem.config.js --env production
```

## Scaling

### Horizontal Scaling
- Use PM2 cluster mode (already configured)
- Use load balancer (Nginx, HAProxy)
- Deploy multiple instances behind load balancer

### Database Scaling
- Use MongoDB replica sets
- Consider sharding for large datasets

