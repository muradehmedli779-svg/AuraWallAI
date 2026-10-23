import { Router, Request, Response } from 'express';
import multer from 'multer';
import { VisionAnalyzer } from '../services/visionAnalyzer';

const upload = multer({
  limits: { fileSize: 25 * 1024 * 1024 } // 25MB max upload
});

export const analyzeRouter = Router();

analyzeRouter.post('/', upload.single('image'), async (req: Request, res: Response) => {
  try {
    if (!req.file || !req.file.buffer) {
      return res.status(400).json({ error: 'No image uploaded.' });
    }

    const analysis = await VisionAnalyzer.analyze(req.file.buffer);
    return res.json(analysis);
  } catch (error: any) {
    console.error('Vision analysis error:', error);
    return res.status(500).json({ error: error.message || 'Image analysis failed.' });
  }
});
