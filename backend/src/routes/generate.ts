import { Router, Request, Response } from 'express';
import { PromptEngine } from '../services/promptEngine';
import { AIImageProvider } from '../services/aiImageProvider';
import { GenerateWallpaperRequestPayload, GenerateWallpaperResponsePayload } from '../types';

export const generateRouter = Router();

generateRouter.post('/', async (req: Request, res: Response) => {
  try {
    const body: GenerateWallpaperRequestPayload = req.body;
    
    if (!body.styleId) {
      return res.status(400).json({ error: 'styleId is required.' });
    }

    const targetWidth = body.targetWidth || 1290;
    const targetHeight = body.targetHeight || 2796;
    const count = body.variationsCount || 3;

    // 1. Compose tailored prompt with subject & lock screen constraints
    const { prompt, negativePrompt } = PromptEngine.assemblePrompt({
      styleId: body.styleId,
      userPromptModifier: body.promptModifier,
      targetWidth,
      targetHeight
    });

    // 2. Dispatch to provider
    const { provider, variations } = await AIImageProvider.generate({
      prompt,
      negativePrompt,
      width: targetWidth,
      height: targetHeight,
      count,
      preserveSubjectBase64: body.preserveSubjectData
    });

    const response: GenerateWallpaperResponsePayload = {
      success: true,
      provider,
      promptUsed: prompt,
      variations
    };

    return res.json(response);
  } catch (error: any) {
    console.error('Generation error:', error);
    return res.status(500).json({ error: error.message || 'Wallpaper generation failed.' });
  }
});
