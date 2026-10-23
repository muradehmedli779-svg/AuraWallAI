import UIKit

public final class WallpaperGenerationService {
    public static let shared = WallpaperGenerationService()
    
    private init() {}
    
    /// Generates wallpaper variations with subject-aware prompt engineering
    public func generateVariations(
        sourceImage: UIImage?,
        analysis: ImageAnalysisResult?,
        style: GenerationStyle,
        device: DeviceProfile = .currentDevice,
        customPrompt: String = "",
        variationCount: Int = 3
    ) async throws -> [WallpaperVariation] {
        // Construct the AI Generation instruction prioritizing subject identity + composition
        var promptComponents: [String] = []
        
        if let analysis = analysis {
            promptComponents.append("cinematic masterpiece wallpaper featuring \(analysis.subjectType.lowercased())")
            if analysis.clockSafeRegion.isClockOccluded {
                promptComponents.append("subject positioned in bottom two thirds of canvas, clean dark negative space at top for lockscreen clock, rim light silhouette")
            } else {
                promptComponents.append("clean spacious upper third negative space reserved for lock screen clock, subject centered lower middle")
            }
        } else {
            promptComponents.append("ultra luxury cinematic smartphone lockscreen wallpaper")
        }
        
        if !customPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            promptComponents.append(customPrompt)
        }
        
        promptComponents.append(style.promptSuffix)
        let finalPrompt = promptComponents.joined(separator: ", ")
        
        // 1. Direct OpenAI DALL-E 3 Mode (If user provided their key in Settings)
        if !Configuration.openAIKey.isEmpty {
            do {
                if let directResult = try await generateDirectOpenAI(prompt: finalPrompt, device: device) {
                    return [directResult]
                }
            } catch {
                print("OpenAI call failed, falling back to free cloud AI: \(error.localizedDescription)")
            }
        }
        
        // 2. Real Cloud AI Engine (Pollinations FLUX - 100% Free, Real AI, Zero Server Required!)
        var realAIVariations: [WallpaperVariation] = []
        let targetCount = max(1, min(variationCount, 3))
        
        for i in 0..<targetCount {
            let seed = Int.random(in: 100000...999999)
            if let variation = try? await generateViaPollinations(prompt: finalPrompt, device: device, seed: seed) {
                realAIVariations.append(variation)
            }
        }
        
        if !realAIVariations.isEmpty {
            return realAIVariations
        }
        
        // 3. Fallback: High Quality Local Synthesis if offline / no internet
        return try await generateLocalProceduralVariations(
            sourceImage: sourceImage,
            style: style,
            prompt: finalPrompt,
            device: device,
            count: variationCount
        )
    }
    
    /// Real AI Generation via Cloud Neural Models (FLUX / SDXL) - Completely Free & Instant
    private func generateViaPollinations(
        prompt: String,
        device: DeviceProfile,
        seed: Int
    ) async throws -> WallpaperVariation? {
        guard let encodedPrompt = prompt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        let urlString = "https://image.pollinations.ai/prompt/\(encodedPrompt)?width=1024&height=1792&model=flux&seed=\(seed)&nologo=true"
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 25.0
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode),
              let uiImage = UIImage(data: data) else {
            return nil
        }
        
        let local = try StorageManager.shared.saveImage(uiImage, prefix: "ai_flux_\(seed)")
        
        // Extract Depth Cutout for Clock Layering
        var depthFile: String? = nil
        if let cutout = try? await LockScreenCompositor.shared.generateSubjectCutout(from: uiImage) {
            depthFile = try? StorageManager.shared.saveImage(cutout, prefix: "cutout_\(seed)")
        }
        
        return WallpaperVariation(
            localFilename: local,
            depthMaskFilename: depthFile,
            promptUsed: prompt,
            providerName: "FLUX 1.1 Pro (Gerçek Yapay Zeka)",
            seed: seed,
            width: device.pixelWidth,
            height: device.pixelHeight
        )
    }
    
    /// Calls OpenAI DALL-E 3 directly from iPhone via HTTPS
    private func generateDirectOpenAI(prompt: String, device: DeviceProfile) async throws -> WallpaperVariation? {
        guard let url = URL(string: "https://api.openai.com/v1/images/generations") else { return nil }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("Bearer \(Configuration.openAIKey)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = [
            "model": "dall-e-3",
            "prompt": prompt,
            "n": 1,
            "size": "1024x1792",
            "quality": "hd",
            "response_format": "b64_json"
        ]
        
        req.httpBody = try JSONSerialization.data(withJSONObject: payload)
        let (data, res) = try await URLSession.shared.data(for: req)
        
        guard let http = res as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            return nil
        }
        
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let dataArr = json["data"] as? [[String: Any]],
           let first = dataArr.first,
           let b64 = first["b64_json"] as? String,
           let imgData = Data(base64Encoded: b64),
           let uiImage = UIImage(data: imgData) {
            
            let local = try StorageManager.shared.saveImage(uiImage, prefix: "dalle_direct")
            return WallpaperVariation(
                localFilename: local,
                promptUsed: prompt,
                providerName: "OpenAI DALL-E 3 (HD)",
                width: device.pixelWidth,
                height: device.pixelHeight
            )
        }
        return nil
    }
    
    /// High quality on-device rendering engine for offline usage
    private func generateLocalProceduralVariations(
        sourceImage: UIImage?,
        style: GenerationStyle,
        prompt: String,
        device: DeviceProfile,
        count: Int
    ) async throws -> [WallpaperVariation] {
        var variations: [WallpaperVariation] = []
        let width = device.pixelWidth
        let height = device.pixelHeight
        
        for i in 0..<count {
            let seed = Int.random(in: 100000...999999)
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
            
            let renderedImage = renderer.image { ctx in
                let cgCtx = ctx.cgContext
                
                let colors = style.sampleGradientColors.compactMap { UIColor(hex: $0)?.cgColor }
                let cfColors = (colors.count >= 2 ? colors : [UIColor.black.cgColor, UIColor.systemIndigo.cgColor]) as CFArray
                let colorSpace = CGColorSpaceCreateDeviceRGB()
                if let gradient = CGGradient(colorsSpace: colorSpace, colors: cfColors, locations: [0.0, 0.4, 1.0]) {
                    cgCtx.drawLinearGradient(
                        gradient,
                        start: CGPoint(x: CGFloat(width) * 0.5, y: 0),
                        end: CGPoint(x: CGFloat(width) * (0.3 + CGFloat(i) * 0.2), y: CGFloat(height)),
                        options: []
                    )
                }
                
                cgCtx.saveGState()
                cgCtx.setBlendMode(.screen)
                let orbColors = [
                    UIColor.systemCyan.withAlphaComponent(0.35).cgColor,
                    UIColor.systemPurple.withAlphaComponent(0.25).cgColor,
                    UIColor.systemPink.withAlphaComponent(0.2).cgColor
                ]
                for (idx, orbColor) in orbColors.enumerated() {
                    let cx = CGFloat(width) * (0.2 + CGFloat(idx) * 0.3)
                    let cy = CGFloat(height) * (0.4 + CGFloat(i) * 0.15)
                    let radius: CGFloat = CGFloat(width) * (0.35 + CGFloat(idx) * 0.1)
                    cgCtx.setFillColor(orbColor)
                    cgCtx.fillEllipse(in: CGRect(x: cx - radius, y: cy - radius, width: radius * 2, height: radius * 2))
                }
                cgCtx.restoreGState()
                
                if let src = sourceImage {
                    let aspect = src.size.width / src.size.height
                    let targetW = CGFloat(width) * 0.85
                    let targetH = targetW / aspect
                    let targetX = (CGFloat(width) - targetW) / 2.0
                    let targetY = CGFloat(height) * 0.38
                    
                    cgCtx.saveGState()
                    cgCtx.setShadow(offset: .zero, blur: 40.0, color: UIColor.systemPurple.withAlphaComponent(0.5).cgColor)
                    src.draw(in: CGRect(x: targetX, y: targetY, width: targetW, height: targetH))
                    cgCtx.restoreGState()
                }
                
                let dockGradientColors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.85).cgColor] as CFArray
                if let dockGrad = CGGradient(colorsSpace: colorSpace, colors: dockGradientColors, locations: [0.0, 1.0]) {
                    cgCtx.drawLinearGradient(
                        dockGrad,
                        start: CGPoint(x: 0, y: CGFloat(height) * 0.75),
                        end: CGPoint(x: 0, y: CGFloat(height)),
                        options: []
                    )
                }
            }
            
            let localFile = try StorageManager.shared.saveImage(renderedImage, prefix: "offline_var_\(i)")
            
            let variation = WallpaperVariation(
                imageURLString: nil,
                localFilename: localFile,
                depthMaskFilename: nil,
                promptUsed: prompt,
                providerName: "AuraEngine (Çevrimdışı Mod)",
                seed: seed,
                width: width,
                height: height
            )
            variations.append(variation)
        }
        
        return variations
    }
}
