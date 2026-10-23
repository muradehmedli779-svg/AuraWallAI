# AuraWall AI — Intelligent iPhone Lock Screen Wallpaper Studio

> **Bespoke 4K Wallpapers Engineered for Super Retina XDR & iOS Lock Screen Depth Effect.**

---

## 🌟 Overview

**AuraWall AI** is a complete, production-grade iOS app and AI diffusion pipeline designed specifically to solve the shortcomings of existing wallpaper apps:
1. **Clock-Safe Composition:** Automatically analyzes subject bounding boxes against the iOS Lock Screen clock safe region `(0.10, 0.12, 0.80, 0.18)` to eliminate unsightly clock occlusion.
2. **Depth Effect Matting:** Employs Apple Vision `VNGenerateForegroundInstanceMaskRequest` and alpha cutout layering so the iOS clock slides dynamically behind the subject's contour.
3. **True OLED Contrast:** Curated aesthetics (Cyber Neon, Minimalist OLED, Cinematic Golden Hour, Liquid Glassmorphism) with pure `#000000` blacks for battery savings and infinite contrast.
4. **4K Ultra-Res Native Scaling:** Maps directly to iPhone 14/15/16 resolutions (e.g., 1290×2796, 1320×2868) with zero pixel stretching.

---

## 📁 Repository Structure

```
AuraWallAI/
├── AuraWall/                      # Complete Native iOS Swift / SwiftUI Xcode Project
│   ├── AuraWall.xcodeproj/        # Validated Xcode 15/16 PBX project & schemes
│   │   ├── project.pbxproj
│   │   └── xcshareddata/xcschemes/AuraWall.xcscheme
│   └── AuraWall/
│       ├── App/                   # App entry, environment configuration
│       ├── Core/                  # Models, Network API client, Vision services, StoreKit 2
│       ├── Features/              # Onboarding, Home Gallery, Creation, Editor, Export
│       ├── Resources/             # Assets.xcassets, Info.plist, Entitlements
│       └── Tests/                 # Unit tests suite (AuraWallTests.swift)
├── backend/                       # Production Express / TypeScript AI Pipeline Microservice
│   ├── src/
│   │   ├── services/              # VisionAnalyzer, PromptEngine, AIImageProvider, ImageProcessor
│   │   ├── routes/                # Analyze, Generate, Export endpoints
│   │   ├── server.ts
│   │   ├── config.ts
│   │   └── types.ts
│   ├── package.json
│   ├── tsconfig.json
│   └── .env.example
├── preview-web/                   # Interactive Web Simulator & Lock Screen Studio
│   ├── index.html                 # Titanium iPhone 16 Pro mockup with live clock & depth layering
│   ├── style.css
│   └── app.js
├── .github/workflows/
│   └── build-ipa.yml              # macOS 14 runner automated xcodebuild & IPA packaging
└── docs/
    ├── ARCHITECTURE.md            # Detailed processing pipeline & depth mathematics
    ├── API_SPECIFICATION.md       # Complete REST API reference
    ├── IOS_SDK_COMPATIBILITY.md   # iOS 17/18 SDK verification & permissions audit
    └── XCODE_BUILD_SIGNING_GUIDE.md # Step-by-step Mac, Xcode, TestFlight & IPA instructions
```

---

## 🚀 Quick Start Guide

### 1. Interactive Simulator (Runs Directly in Current Environment)
You can launch and interact with the full iPhone 16 Pro studio immediately in any web browser:
1. Open `preview-web/index.html` in your browser.
2. Drag and drop any portrait, pet, or landscape photo.
3. Observe real-time subject analysis, clock safe calculation, and depth effect layering.
4. Switch styles, preview dynamic clock fonts, and export the 4K wallpaper.

### 2. Backend Diffusion Engine (Node.js / TypeScript)
```bash
cd backend
npm install
npm run dev
```
- Server boots on `http://localhost:8080/api/v1`
- Includes native support for **OpenAI DALL-E 3**, **Replicate FLUX.1.1 Pro**, **Stability AI SDXL**, and a high-fidelity **AuraEngine Procedural Mock** requiring zero API keys.

### 3. Native iOS App (Xcode on macOS)
```bash
cd AuraWall
open AuraWall.xcodeproj
```
1. Select target **AuraWall**.
2. Under **Signing & Capabilities**, select your Apple Developer Team.
3. Select an iPhone 15/16 Simulator or connected iPhone and press **Cmd + R**.

### 4. Automated Cloud IPA Build (GitHub Actions)
Push this repository to GitHub with your Apple Developer credentials set in repository secrets to trigger `.github/workflows/build-ipa.yml`. It will:
- Boot an Apple Silicon `macos-14` runner.
- Invoke `xcodebuild archive`.
- Package and upload a signed `.ipa` artifact ready for TestFlight or Ad-Hoc sideloading.

---

## 🔒 Security & Privacy Architecture
- **Permissions:** Full disclosure in `Info.plist` with `NSPhotoLibraryUsageDescription`, `NSPhotoLibraryAddUsageDescription`, and `NSCameraUsageDescription`.
- **Zero Raw Secrets:** Environment variables are strictly abstracted via `.env.example` and Xcode build settings.
- **StoreKit 2:** Implements cryptographic transaction verification (`checkVerified`) against App Store servers.
