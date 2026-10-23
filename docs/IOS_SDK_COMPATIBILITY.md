# iOS SDK Compatibility & API Availability Report

## 1. Executive Summary & Target Selection

- **Target OS:** iOS 17.0+ (with verified forward-compatibility for iOS 18.x)
- **Minimum Deployment Target:** `IPHONEOS_DEPLOYMENT_TARGET = 17.0`
- **Recommended Xcode:** Xcode 15.4 or Xcode 16.0+
- **Language Mode:** Swift 5.10 / Swift 6.0
- **Architectures:** `arm64` (Apple Silicon iPhone A15 Bionic, A16 Bionic, A17 Pro, A18, A18 Pro)

---

## 2. API Availability Matrix

| Framework / API | Required Availability | Purpose in AuraWall | Fallback Behavior |
| :--- | :--- | :--- | :--- |
| `SwiftUI` (NavigationStack, Observable) | iOS 16.0+ | Core declarative UI architecture, reactive data binding | Native |
| `VNGenerateForegroundInstanceMaskRequest` | **iOS 17.0+** | Subject extraction, foreground cutout layer for Lock Screen Depth Effect | Local saliency mask via `VNGenerateAttentionBasedSaliencyImageRequest` |
| `VNGenerateAttentionBasedSaliencyImageRequest` | iOS 13.0+ | Subject localization and bounding box calculation | Center crop heuristic |
| `VNClassifyImageRequest` | iOS 13.0+ | Subject classification (portrait, pet, vehicle, landscape) | Backend classification endpoint |
| `CoreImage.CIFilterBuiltins` | iOS 13.0+ | Color matrix adjustments, Gaussian blur, depth blending | CoreGraphics direct context drawing |
| `PhotosUI` (`PhotosPicker`) | iOS 16.0+ | Privacy-preserving modern photo import without full library access prompt | `UIImagePickerController` |
| `PHPhotoLibrary` | iOS 14.0+ | Lossless 4K PNG export into Camera Roll with `.addOnly` permission | Share sheet / UIActivityViewController |
| `StoreKit 2` (`Product`, `Transaction`) | iOS 15.0+ | In-app purchases, subscriptions, entitlement sync | Mock entitlement / debug unlock mode |

---

## 3. Privacy & Permission Keys (Info.plist)

The following usage descriptions are mandatory in `Info.plist` to prevent immediate App Store rejection:

1. **`NSPhotoLibraryAddUsageDescription`**
   - *Value:* `"AuraWall saves your generated 4K ultra-high resolution wallpapers directly to your camera roll."`
   - *Triggered:* Only when exporting the rendered wallpaper.
2. **`NSPhotoLibraryUsageDescription`**
   - *Value:* `"AuraWall accesses your photo library to import portraits, pets, and subjects to turn into customized lock screen wallpapers."`
   - *Triggered:* When selecting photos for analysis.
3. **`NSCameraUsageDescription`**
   - *Value:* `"AuraWall needs camera access to let you capture subjects directly for custom AI wallpaper synthesis."`
   - *Triggered:* Live camera capture mode.

---

## 4. Hardware & Display Considerations

- **Super Retina XDR (OLED):**
  AuraWall designs pure black (`#000000`) background presets. When displayed on iPhone OLED screens, pixels turn completely off, saving battery and offering true infinite contrast.
- **Dynamic Island & Clock Overlap:**
  Screen ratios on iPhone 15/16 series range from `19.5:9` (e.g. 1179x2556, 1290x2796, 1320x2868). The lock screen clock occupies normalized coordinates `CGRect(x: 0.10, y: 0.12, width: 0.80, height: 0.18)`.
  AuraWall calculates subject intersection against this rect. If intersection is between 5% and 25%, iOS allows the **Depth Effect** where the clock numerals slide behind the subject's silhouette. If overlap exceeds 30%, iOS automatically disables the depth effect. AuraWall actively suggests downward translation offsets to preserve depth eligibility!
