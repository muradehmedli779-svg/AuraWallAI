# AuraWall AI — System Architecture & Pipeline Specification

## 1. System Overview

AuraWall is an end-to-end iOS application and backend diffusion engine engineered specifically to solve the core design flaw of modern mobile AI wallpaper apps: **wallpaper stretching and clock occlusion**.

Unlike generic image generators that produce 1:1 square or arbitrary 16:9 images, AuraWall:
1. Targets the exact OLED aspect ratio and pixel grid of modern iPhones (e.g., 1290×2796 for iPhone 15/16 Pro Max).
2. Uses Apple Vision and Saliency analysis to detect subject contours and depth layers.
3. Automatically evaluates clock collision with the iOS Lock Screen clock safe area `(0.10, 0.12, 0.80, 0.18)`.
4. Leverages iOS 16/17/18 **Lock Screen Depth Effect**, generating alpha cutout layers so the iPhone clock dynamically slides behind the subject.

---

## 2. Processing Pipeline Specification (Phases A through H)

```
[ User Photo Upload ]
         │
         ▼
[ A. Validation & Format Normalization ]
         │
         ▼
[ B. Vision & Depth Analysis ]
   ├── Saliency Object Detection
   ├── Subject Classification (Portrait, Pet, Architecture)
   ├── Dominant OLED Palette Extraction
   └── Clock Collision & Occlusion Ratio Calculation
         │
         ▼
[ C. Composition Recommendations ]
   ├── Dynamic Offset Shift (downward translation if clock occluded)
   └── Aspect Ratio Adaptation to Target DeviceProfile
         │
         ▼
[ D. Neural Prompt Engineering ]
   ├── Subject Identity Anchoring
   ├── OLED Pure Black (#000000) Negative Prompts
   └── Visual Style Directives (Cyber Neon, Minimalist, Glassmorphism)
         │
         ▼
[ E. AI Provider Execution ]
   ├── OpenAI DALL-E 3 (HD Vertical)
   ├── Replicate FLUX.1.1 Pro (9:16 / 9:19.5 aspect ratio)
   ├── Stability AI SDXL
   └── High-Fidelity On-Device / Mock Fallback Engine
         │
         ▼
[ F. Validation & Quality Filtering ]
   ├── 4K Pixel Dimensions Check
   └── Contrast & Depth Edge Verification
         │
         ▼
[ G. Interactive Lock Screen Editor ]
   ├── Real-Time iOS 17/18 Preview (Time, Date, Widgets, Dynamic Island)
   ├── Live Depth Effect Layer Toggle
   └── Variation Selection & Comparison
         │
         ▼
[ H. 4K Lossless Export & Native iOS Setup Guide ]
   ├── Photos Library Direct Save (PHPhotoLibrary addOnly)
   └── Step-by-Step Native Lock Screen Wallpapers Guide
```

---

## 3. Depth Effect & Clock-Safe Occlusion Mathematics

In iOS lock screens, the clock is rendered in a fixed geometric box:
$$\text{ClockArea} = [x: 0.10, y: 0.12, w: 0.80, h: 0.18]$$

Given a detected subject bounding box $B = [x_s, y_s, w_s, h_s]$:
$$\text{Intersection} = B \cap \text{ClockArea}$$
$$\text{OcclusionRatio} = \frac{\text{Area}(\text{Intersection})}{\text{Area}(\text{ClockArea})}$$

- **Case 1: $\text{OcclusionRatio} = 0.0$ (Safe Zone)**
  The subject sits completely below the clock. No overlap exists. Full visibility is guaranteed.
- **Case 2: $0.05 \le \text{OcclusionRatio} \le 0.25$ (Optimal Depth Zone)**
  The subject's head or contour subtly overlaps the bottom portion of the clock numerals. The iOS Lock Screen compositor enables the native 3D Depth Effect, rendering the subject above the numbers while keeping the wallpaper background behind.
- **Case 3: $\text{OcclusionRatio} > 0.30$ (Disabled Depth Zone)**
  iOS lock screen disables depth effect if the clock is too obscured. When this is detected, AuraWall automatically injects a vertical downward translation into the AI generation prompt to keep overlap within $\le 20\%$.

---

## 4. Component Independence & Testability

Each component in the architecture is strictly modularized:
- **`ImageAnalysisService`**: Isolated from networking and rendering. Can be tested with static test images.
- **`PromptEngine`**: Pure function converting structured inputs into deterministic prompt strings.
- **`AIImageProvider`**: Interface-driven provider pattern (`OpenAI`, `Replicate`, `Stability`, `Mock`).
- **`LockScreenCompositor`**: Pure CoreImage / Metal rendering pipeline for deterministic pixel outputs.
- **`StoreKitManager`**: Decoupled StoreKit 2 manager with full mock/sandbox support.
