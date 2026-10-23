export interface BoundingBox {
  x: number;
  y: number;
  width: number;
  height: number;
}

export interface ClockSafeAssessment {
  isClockOccluded: boolean;
  occlusionRatio: number;
  safeRecommendation: string;
  verticalOffsetSuggested: number;
}

export interface ImageAnalysisPayload {
  success: boolean;
  subjectType: string;
  confidence: number;
  boundingBox: [number, number, number, number];
  dominantColors: string[];
  clockSafeRegion: ClockSafeAssessment;
  depthEffectScore: number;
  compositionTips: string[];
}

export interface GenerateWallpaperRequestPayload {
  styleId: string;
  promptModifier: string;
  targetWidth: number;
  targetHeight: number;
  variationsCount: number;
  preserveSubjectData?: string;
  deviceProfileId: string;
}

export interface GeneratedVariationItem {
  id: string;
  imageBase64?: string;
  imageURL?: string;
  depthMaskBase64?: string;
  seed: number;
  width: number;
  height: number;
}

export interface GenerateWallpaperResponsePayload {
  success: boolean;
  provider: string;
  promptUsed: string;
  variations: GeneratedVariationItem[];
}
