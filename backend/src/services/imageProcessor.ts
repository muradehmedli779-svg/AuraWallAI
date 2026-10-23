import sharp from 'sharp';

export class ImageProcessor {
  /**
   * Resizes and crops canvas to exact target iPhone pixel dimensions with smart gravity
   */
  public static async formatForDevice(
    imageBuffer: Buffer,
    targetWidth: number = 1290,
    targetHeight: number = 2796
  ): Promise<Buffer> {
    return sharp(imageBuffer)
      .resize(targetWidth, targetHeight, {
        fit: 'cover',
        position: 'center'
      })
      .png({ quality: 100, compressionLevel: 8 })
      .toBuffer();
  }

  /**
   * Generates a high-contrast depth alpha mask for testing depth effect layering
   */
  public static async generateDepthMask(imageBuffer: Buffer): Promise<Buffer> {
    return sharp(imageBuffer)
      .grayscale()
      .linear(1.5, -30) // boost contrast
      .threshold(128)
      .png()
      .toBuffer();
  }

  /**
   * Generates an aesthetic high-resolution procedural canvas for offline / mock testing
   */
  public static async generateProceduralCanvas(
    width: number = 1290,
    height: number = 2796,
    palette: string[] = ['#090A0F', '#1C103A', '#00F5FF', '#9353FE'],
    seed: number = 42
  ): Promise<Buffer> {
    const c1 = palette[0] || '#090A0F';
    const c2 = palette[1] || '#1C103A';
    const c3 = palette[2] || '#00F5FF';
    const c4 = palette[3] || '#9353FE';

    const svg = `
      <svg width="${width}" height="${height}" viewBox="0 0 ${width} ${height}" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <linearGradient id="bgGrad" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stop-color="${c1}" />
            <stop offset="60%" stop-color="${c2}" />
            <stop offset="100%" stop-color="#000000" />
          </linearGradient>
          <radialGradient id="orbGrad1" cx="50%" cy="50%" r="50%">
            <stop offset="0%" stop-color="${c3}" stop-opacity="0.8" />
            <stop offset="100%" stop-color="${c3}" stop-opacity="0" />
          </radialGradient>
          <radialGradient id="orbGrad2" cx="50%" cy="50%" r="50%">
            <stop offset="0%" stop-color="${c4}" stop-opacity="0.6" />
            <stop offset="100%" stop-color="${c4}" stop-opacity="0" />
          </radialGradient>
        </defs>
        
        <rect width="${width}" height="${height}" fill="url(#bgGrad)" />
        
        <!-- Atmospheric glowing depth spheres -->
        <circle cx="${width * 0.4}" cy="${height * 0.48}" r="${width * 0.38}" fill="url(#orbGrad1)" />
        <circle cx="${width * 0.7}" cy="${height * 0.62}" r="${width * 0.42}" fill="url(#orbGrad2)" />
        
        <!-- OLED black bottom dock fader -->
        <rect y="${height * 0.78}" width="${width}" height="${height * 0.22}" fill="black" opacity="0.85" />
      </svg>
    `;

    return sharp(Buffer.from(svg))
      .png({ quality: 100 })
      .toBuffer();
  }
}
