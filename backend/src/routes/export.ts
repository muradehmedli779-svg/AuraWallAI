import { Router, Request, Response } from 'express';
import { ImageProcessor } from '../services/imageProcessor';

export const exportRouter = Router();

exportRouter.post('/upscale', async (req: Request, res: Response) => {
  try {
    const { imageBase64, targetWidth, targetHeight } = req.body;
    if (!imageBase64) {
      return res.status(400).json({ error: 'imageBase64 is required.' });
    }

    const inputBuffer = Buffer.from(imageBase64, 'base64');
    const upscaled = await ImageProcessor.formatForDevice(
      inputBuffer,
      targetWidth || 1320,
      targetHeight || 2868
    );

    return res.json({
      success: true,
      upscaledBase64: upscaled.toString('base64'),
      width: targetWidth || 1320,
      height: targetHeight || 2868
    });
  } catch (error: any) {
    return res.status(500).json({ error: error.message });
  }
});
