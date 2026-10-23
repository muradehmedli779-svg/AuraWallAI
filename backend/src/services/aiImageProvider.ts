import axios from 'axios';
import { config } from '../config';
import { GeneratedVariationItem } from '../types';
import { ImageProcessor } from './imageProcessor';

export interface GenerationParams {
  prompt: string;
  negativePrompt: string;
  width: number;
  height: number;
  count: number;
  preserveSubjectBase64?: string;
  palette?: string[];
}

export class AIImageProvider {
  /**
   * Dispatches generation request to the configured AI provider
   */
  public static async generate(params: GenerationParams): Promise<{ provider: string; variations: GeneratedVariationItem[] }> {
    const selectedProvider = config.aiProvider.toLowerCase();

    if (selectedProvider === 'openai' && config.openaiApiKey) {
      return this.generateWithOpenAI(params);
    } else if (selectedProvider === 'replicate' && config.replicateApiToken) {
      return this.generateWithReplicate(params);
    } else if (selectedProvider === 'stability' && config.stabilityApiKey) {
      return this.generateWithStability(params);
    }

    // Default to Mock / High-fidelity procedural provider
    return this.generateWithMockProvider(params);
  }

  /**
   * OpenAI DALL-E 3 integration
   */
  private static async generateWithOpenAI(params: GenerationParams): Promise<{ provider: string; variations: GeneratedVariationItem[] }> {
    const variations: GeneratedVariationItem[] = [];

    // DALL-E 3 vertical format: 1024x1792
    const response = await axios.post(
      'https://api.openai.com/v1/images/generations',
      {
        model: 'dall-e-3',
        prompt: params.prompt,
        n: 1,
        size: '1024x1792',
        quality: 'hd',
        response_format: 'b64_json'
      },
      {
        headers: {
          'Authorization': `Bearer ${config.openaiApiKey}`,
          'Content-Type': 'application/json'
        }
      }
    );

    const data = response.data?.data?.[0];
    if (data?.b64_json) {
      const buffer = Buffer.from(data.b64_json, 'base64');
      const scaled = await ImageProcessor.formatForDevice(buffer, params.width, params.height);
      const mask = await ImageProcessor.generateDepthMask(scaled);

      variations.push({
        id: `openai-${Date.now()}`,
        imageBase64: scaled.toString('base64'),
        depthMaskBase64: mask.toString('base64'),
        seed: Math.floor(Math.random() * 1000000),
        width: params.width,
        height: params.height
      });
    }

    return {
      provider: 'OpenAI DALL-E 3 HD',
      variations
    };
  }

  /**
   * Replicate Flux.1-pro integration
   */
  private static async generateWithReplicate(params: GenerationParams): Promise<{ provider: string; variations: GeneratedVariationItem[] }> {
    const response = await axios.post(
      'https://api.replicate.com/v1/predictions',
      {
        version: 'black-forest-labs/flux-1.1-pro',
        input: {
          prompt: params.prompt,
          aspect_ratio: '9:16',
          output_format: 'png',
          safety_tolerance: 2
        }
      },
      {
        headers: {
          'Authorization': `Token ${config.replicateApiToken}`,
          'Content-Type': 'application/json'
        }
      }
    );

    const predictionId = response.data.id;
    // Poll for completion
    let outputUrl = '';
    for (let i = 0; i < 30; i++) {
      await new Promise(r => setTimeout(r, 2000));
      const pollRes = await axios.get(`https://api.replicate.com/v1/predictions/${predictionId}`, {
        headers: { 'Authorization': `Token ${config.replicateApiToken}` }
      });
      if (pollRes.data.status === 'succeeded') {
        outputUrl = pollRes.data.output;
        break;
      }
      if (pollRes.data.status === 'failed') break;
    }

    const variations: GeneratedVariationItem[] = [];
    if (outputUrl) {
      const imgRes = await axios.get(outputUrl, { responseType: 'arraybuffer' });
      const scaled = await ImageProcessor.formatForDevice(Buffer.from(imgRes.data), params.width, params.height);
      const mask = await ImageProcessor.generateDepthMask(scaled);

      variations.push({
        id: `replicate-${predictionId}`,
        imageURL: outputUrl,
        imageBase64: scaled.toString('base64'),
        depthMaskBase64: mask.toString('base64'),
        seed: Math.floor(Math.random() * 1000000),
        width: params.width,
        height: params.height
      });
    }

    return {
      provider: 'Replicate FLUX.1.1 Pro',
      variations
    };
  }

  /**
   * Stability AI SDXL / SD3.5 integration
   */
  private static async generateWithStability(params: GenerationParams): Promise<{ provider: string; variations: GeneratedVariationItem[] }> {
    const response = await axios.post(
      'https://api.stability.ai/v1/generation/stable-diffusion-xl-1024-v1-0/text-to-image',
      {
        text_prompts: [
          { text: params.prompt, weight: 1.0 },
          { text: params.negativePrompt, weight: -1.0 }
        ],
        cfg_scale: 7,
        height: 1344,
        width: 768,
        samples: params.count || 2,
        steps: 30
      },
      {
        headers: {
          'Authorization': `Bearer ${config.stabilityApiKey}`,
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      }
    );

    const variations: GeneratedVariationItem[] = [];
    for (const artifact of response.data?.artifacts || []) {
      const buffer = Buffer.from(artifact.base64, 'base64');
      const scaled = await ImageProcessor.formatForDevice(buffer, params.width, params.height);
      const mask = await ImageProcessor.generateDepthMask(scaled);

      variations.push({
        id: `stability-${artifact.seed}`,
        imageBase64: scaled.toString('base64'),
        depthMaskBase64: mask.toString('base64'),
        seed: artifact.seed,
        width: params.width,
        height: params.height
      });
    }

    return {
      provider: 'Stability AI SDXL',
      variations
    };
  }

  /**
   * High-Fidelity Mock Provider (Runs locally with 0 API keys required)
   */
  private static async generateWithMockProvider(params: GenerationParams): Promise<{ provider: string; variations: GeneratedVariationItem[] }> {
    const variations: GeneratedVariationItem[] = [];
    const count = Math.min(Math.max(params.count, 1), 4);

    const palettes = [
      ['#090A0F', '#1C103A', '#00F5FF', '#9353FE'],
      ['#050508', '#200D2B', '#FF2A85', '#7A00FF'],
      ['#020B14', '#06283D', '#2563EB', '#38BDF8'],
      ['#0D0D0D', '#1A1A1A', '#FFB800', '#FF3E00']
    ];

    for (let i = 0; i < count; i++) {
      const seed = Math.floor(Math.random() * 900000) + 100000;
      const palette = palettes[i % palettes.length];
      const buffer = await ImageProcessor.generateProceduralCanvas(params.width, params.height, palette, seed);
      const mask = await ImageProcessor.generateDepthMask(buffer);

      variations.push({
        id: `aura-mock-${seed}`,
        imageBase64: buffer.toString('base64'),
        depthMaskBase64: mask.toString('base64'),
        seed,
        width: params.width,
        height: params.height
      });
    }

    return {
      provider: 'AuraEngine (Procedural 4K Neural Canvas)',
      variations
    };
  }
}
