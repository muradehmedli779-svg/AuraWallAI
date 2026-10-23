# AuraWall AI — Backend API Specification

Base URL: `http://localhost:8080/api/v1` (or `https://api.aurawall.app/api/v1`)

---

## 1. Health Check
- **Endpoint:** `GET /health` or `GET /api/v1/health`
- **Response:**
```json
{
  "status": "ok",
  "version": "1.0.0",
  "service": "AuraWall AI Engine",
  "provider": "openai",
  "timestamp": "2026-10-24T00:00:00.000Z"
}
```

---

## 2. Image Analysis
- **Endpoint:** `POST /api/v1/analyze`
- **Content-Type:** `multipart/form-data`
- **Body:**
  - `image`: File (JPEG / PNG / HEIC)
- **Response:**
```json
{
  "success": true,
  "subjectType": "Person / Portrait Subject",
  "confidence": 0.91,
  "boundingBox": [0.22, 0.32, 0.56, 0.52],
  "dominantColors": ["#0F0C20", "#1C153A", "#00F5FF", "#FF007F"],
  "clockSafeRegion": {
    "isClockOccluded": true,
    "occlusionRatio": 0.18,
    "safeRecommendation": "Subject touches lock screen clock area. Depth effect will layer the clock between subject and background.",
    "verticalOffsetSuggested": 0.08
  },
  "depthEffectScore": 0.92,
  "compositionTips": [
    "Optimal lock screen 19.5:9 portrait ratio detected.",
    "High dynamic range headroom identified for Super Retina XDR.",
    "Subject is framed for natural iOS lock screen depth effect."
  ]
}
```

---

## 3. Generate Wallpaper Variations
- **Endpoint:** `POST /api/v1/generate`
- **Content-Type:** `application/json`
- **Body:**
```json
{
  "styleId": "cyber-neon",
  "promptModifier": "bioluminescent rain, reflections",
  "targetWidth": 1290,
  "targetHeight": 2796,
  "variationsCount": 3,
  "preserveSubjectData": "<base64_encoded_jpeg_optional>",
  "deviceProfileId": "iphone-16-pro"
}
```
- **Response:**
```json
{
  "success": true,
  "provider": "OpenAI DALL-E 3 HD",
  "promptUsed": "Detailed artwork centered on Person / Portrait Subject, bioluminescent rain, reflections, cyberpunk aesthetic, vibrant neon cyan and hot magenta edge lighting...",
  "variations": [
    {
      "id": "openai-1729728000000",
      "imageBase64": "<base64_png>",
      "depthMaskBase64": "<base64_depth_mask_png>",
      "seed": 847291,
      "width": 1290,
      "height": 2796
    }
  ]
}
```

---

## 4. Upscale / Lossless Export
- **Endpoint:** `POST /api/v1/export/upscale`
- **Content-Type:** `application/json`
- **Body:**
```json
{
  "imageBase64": "<base64_png>",
  "targetWidth": 1320,
  "targetHeight": 2868
}
```
- **Response:**
```json
{
  "success": true,
  "upscaledBase64": "<base64_png>",
  "width": 1320,
  "height": 2868
}
```
