import dotenv from 'dotenv';
dotenv.config();

export const config = {
  port: parseInt(process.env.PORT || '8080', 10),
  nodeEnv: process.env.NODE_ENV || 'development',
  aiProvider: process.env.AI_PROVIDER || 'mock',
  openaiApiKey: process.env.OPENAI_API_KEY || '',
  replicateApiToken: process.env.REPLICATE_API_TOKEN || '',
  stabilityApiKey: process.env.STABILITY_API_KEY || '',
  storage: {
    bucket: process.env.S3_BUCKET_NAME || '',
    region: process.env.S3_REGION || 'auto',
    accessKey: process.env.S3_ACCESS_KEY_ID || '',
    secretKey: process.env.S3_SECRET_ACCESS_KEY || '',
  }
};
