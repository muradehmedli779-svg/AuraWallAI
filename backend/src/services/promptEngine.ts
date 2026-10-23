export interface PromptCompositionOptions {
  styleId: string;
  userPromptModifier?: string;
  subjectDescription?: string;
  targetWidth: number;
  targetHeight: number;
  isClockOccluded?: boolean;
}

export class PromptEngine {
  private static stylePresets: Record<string, { prompt: string; negative: string }> = {
    'cyber-neon': {
      prompt: 'cyberpunk aesthetic, vibrant neon cyan and hot magenta edge lighting, volumetric bioluminescence, true OLED pitch black background, 8k raytraced, clean composition framed for smartphone lock screen',
      negative: 'bright washed background, white haze, blur, watermark, distorted faces, ugly artifacts'
    },
    'minimalist-dark': {
      prompt: 'minimalist dark aesthetic, pure pitch black OLED background (#000000), subtle soft rim light highlighting subject contours, elegant negative space for clock, high-end Apple design wallpaper',
      negative: 'busy background, clutter, noisy texture, banding, overexposed lights'
    },
    'cinematic-golden': {
      prompt: 'cinematic 35mm film photography, golden hour warm sunset backlighting, creamy lens bokeh, Kodak Portra 400 tones, atmospheric light dust particles, vertical portrait composition',
      negative: 'digital oversaturation, cartoon, plastic skin, low detail, bad anatomy'
    },
    'abstract-glass': {
      prompt: 'fluid iridescent glassmorphism ribbon sculpture, frosted translucent glass refraction, caustics, soft pastel highlights over deep midnight blue backdrop, iOS 18 glass visual language',
      negative: 'muddy colors, pixelation, flat textures, jagged lines'
    },
    'anime-studio': {
      prompt: 'Makoto Shinkai anime aesthetic, majestic twilight sky with painted cumulus clouds, twinkling stars, soft glowing horizon, emotional anime masterwork background art',
      negative: 'sketch, lowres, deformed characters, text, watermark'
    },
    'noir-monochrome': {
      prompt: 'dramatic black and white chiaroscuro photography, high contrast deep blacks, razor sharp studio key light, Leica Monochrom aesthetic, elegant architectural framing',
      negative: 'color, sepia, washed out gray, low contrast, blur'
    }
  };

  public static assemblePrompt(options: PromptCompositionOptions): { prompt: string; negativePrompt: string } {
    const preset = this.stylePresets[options.styleId] || this.stylePresets['cyber-neon'];
    const parts: string[] = [];

    if (options.subjectDescription) {
      parts.push(`Detailed artwork centered on ${options.subjectDescription}`);
    } else {
      parts.push('Artistic smartphone lock screen wallpaper');
    }

    if (options.userPromptModifier && options.userPromptModifier.trim().length > 0) {
      parts.push(options.userPromptModifier.trim());
    }

    parts.push(preset.prompt);

    if (options.isClockOccluded) {
      parts.push('subject thoughtfully centered in lower 65% with clean silhouette overlapping the upper region for iOS lock screen depth effect');
    } else {
      parts.push('top 30% reserved with clean negative space for lock screen clock');
    }

    return {
      prompt: parts.join(', '),
      negativePrompt: preset.negative
    };
  }
}
