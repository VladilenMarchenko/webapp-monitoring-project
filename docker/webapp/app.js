const express = require('express');
const prometheus = require('prom-client');
const fs = require('fs').promises;
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// Prometheus metrics
const register = new prometheus.Registry();
prometheus.collectDefaultMetrics({ register });

const httpRequestDuration = new prometheus.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code'],
  registers: [register]
});

const httpRequestTotal = new prometheus.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
  registers: [register]
});

// Middleware
app.use(express.json());

// Request tracking middleware
app.use((req, res, next) => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = Date.now() - start;
    httpRequestDuration
      .labels(req.method, req.route?.path || req.path, res.statusCode)
      .observe(duration / 1000);
    
    httpRequestTotal
      .labels(req.method, req.route?.path || req.path, res.statusCode)
      .inc();
  });
  
  next();
});

// Routes
app.get('/', async (req, res) => {
  const hostname = require('os').hostname();
  const uptime = process.uptime();
  
  res.json({
    message: 'Welcome to Node.js Web Application',
    hostname,
    uptime: `${Math.floor(uptime)} seconds`,
    version: '1.0.0'
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

// Data endpoint
app.post('/data', async (req, res) => {
  try {
    const data = req.body;
    const filename = `data-${Date.now()}.json`;
    await fs.writeFile(
      path.join('/app/data', filename),
      JSON.stringify(data, null, 2)
    );
    res.json({ message: 'Data saved', filename });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/data', async (req, res) => {
  try {
    const files = await fs.readdir('/app/data');
    const jsonFiles = files.filter(f => f.endsWith('.json'));
    res.json({ files: jsonFiles });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Start server
app.listen(port, '0.0.0.0', () => {
  console.log(`Application running on port ${port}`);
});
