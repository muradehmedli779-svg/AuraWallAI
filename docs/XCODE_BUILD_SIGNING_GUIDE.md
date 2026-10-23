# Xcode Build, Code Signing, and IPA Packaging Guide

This guide details the exact steps to compile, sign, package, and distribute **AuraWall AI** as an iOS Application Archive (`.xcarchive`) and iOS App Store / Ad-Hoc Package (`.ipa`).

---

## 1. Environment Requirements & Prerequisites

### Machine Setup
- **Operating System:** macOS Sonoma (14.0+) or macOS Sequoia (15.0+)
- **Xcode Version:** Xcode 15.4 or Xcode 16.0+
- **Command Line Tools:** `xcode-select --install`
- **CocoaPods / SPM:** Pure Swift Package Manager (SPM) architecture — zero legacy pods required!

> **Environment Note:** Since native iOS SDK compilation requires Apple's proprietary clang toolchain and Darwin kernel headers available exclusively on macOS, compiling on Windows directly is not natively supported. We provide:
> 1. The complete, validated Xcode project (`AuraWall.xcodeproj`) and source code ready to open in Xcode on any Mac.
> 2. An automated GitHub Actions CI/CD pipeline (`.github/workflows/build-ipa.yml`) that boots a macOS 14 runner, runs `xcodebuild`, and generates the real `.ipa` binary artifact automatically!
> 3. An interactive web companion (`preview-web/`) that runs locally in your current environment immediately.

---

## 2. Apple Developer Account Capabilities & Signing Prerequisites

To sign and distribute AuraWall, ensure the following are configured in your [Apple Developer Portal](https://developer.apple.com/account):

### App ID Configuration
- **Bundle Identifier:** `com.aurawall.app` (or your reverse-domain identifier)
- **Capabilities Required:**
  - `In-App Purchase` (StoreKit 2 auto-renewable subscriptions)
  - `Push Notifications` (Optional for background generation alerts)

### Certificates & Profiles
1. **Apple Development Certificate:** For running on local registered test iPhones.
2. **Apple Distribution Certificate:** For TestFlight and App Store packaging.
3. **Provisioning Profile:**
   - *Ad-Hoc / TestFlight:* App ID `com.aurawall.app` matching distribution certificate.
   - *Automatic Signing:* Handled seamlessly inside Xcode using your Apple ID team.

---

## 3. Building the IPA via Command Line (`xcodebuild`)

### Step 1: Clone and Enter Project Directory
```bash
git clone <repo-url>
cd AuraWallAI/AuraWall
```

### Step 2: Clean and Create Archive
Run the following command to generate the release archive:
```bash
xcodebuild archive \
  -project AuraWall.xcodeproj \
  -scheme AuraWall \
  -configuration Release \
  -archivePath ./build/AuraWall.xcarchive \
  -destination "generic/platform=iOS" \
  DEVELOPMENT_TEAM="YOUR_TEAM_ID"
```

### Step 3: Configure `ExportOptions.plist`
Create an `ExportOptions.plist` file in the build directory:

**For TestFlight / App Store Distribution:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>signingStyle</key>
    <string>manual</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>com.aurawall.app</key>
        <string>AuraWall_AppStore_Profile</string>
    </dict>
    <key>stripSwiftSymbols</key>
    <true/>
</dict>
</plist>
```

**For Ad-Hoc / Sideloading (AltStore / Sideloadly):**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>ad-hoc</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>compileBitcode</key>
    <false/>
</dict>
</plist>
```

### Step 4: Export the `.ipa`
```bash
xcodebuild -exportArchive \
  -archivePath ./build/AuraWall.xcarchive \
  -exportPath ./build/IPA \
  -exportOptionsPlist ./ExportOptions.plist
```
The resulting `AuraWall.ipa` will be generated in `./build/IPA/AuraWall.ipa`.

---

## 4. Building via Xcode GUI

1. Open `AuraWall/AuraWall.xcodeproj` in Xcode 15 or 16.
2. Select the `AuraWall` target -> **Signing & Capabilities**.
3. Check **Automatically manage signing** and choose your Apple Developer Team.
4. Select **Any iOS Device (arm64)** as the target run destination.
5. In the menu bar, choose **Product** > **Archive**.
6. Once the Organizer window opens:
   - Click **Distribute App**.
   - Choose **TestFlight & App Store** or **Ad Hoc / Development**.
   - Follow prompts to export the IPA or upload directly to App Store Connect.

---

## 5. TestFlight Distribution

1. In App Store Connect, go to **Apps** > **AuraWall**.
2. Go to the **TestFlight** tab.
3. Once the build finishes processing (5–15 minutes):
   - Add Internal Testers (immediate access).
   - Add External Groups (requires brief Apple Beta Review).
4. Testers receive an invite via the TestFlight app to install the build over-the-air.
