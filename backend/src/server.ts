import express from 'express';
import cors from 'cors';
import { config } from './config';
import { analyzeRouter } from './routes/analyze';
import { generateRouter } from './routes/generate';
import { exportRouter } from './routes/export';

const app = express();

app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// Health Check
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    version: '1.0.0',
    service: 'AuraWall AI Engine',
    provider: config.aiProvider,
    timestamp: new Date().toISOString()
  });
});

app.get('/api/v1/health', (req, res) => {
  res.json({
    status: 'ok',
    version: '1.0.0',
    service: 'AuraWall AI Engine',
    provider: config.aiProvider,
    timestamp: new Date().toISOString()
  });
});

// Routes
app.use('/api/v1/analyze', analyzeRouter);
app.use('/api/v1/generate', generateRouter);
app.use('/api/v1/export', exportRouter);

if (process.env.NODE_ENV !== 'test') {
  app.listen(config.port, () => {
    console.log(`[AuraWall Engine] Server active on port ${config.port}`);
    console.log(`[AuraWall Engine] Selected AI Provider: ${config.aiProvider}`);
    console.log(`[AuraWall Engine] Endpoint: http://localhost:${config.port}/api/v1`);
  });
}

export default app;
