import SwiftUI

/// Preset styles optimized specifically for iOS OLED / Super Retina XDR displays
public struct GenerationStyle: Identifiable, Hashable, Codable {
    public let id: String
    public let name: String
    public let category: String
    public let description: String
    public let iconSystemName: String
    public let sampleGradientColors: [String]
    public let promptSuffix: String
    public let negativePrompt: String
    public let contrastBoost: Double
    public let isPro: Bool
    
    public static let styles: [GenerationStyle] = [
        GenerationStyle(
            id: "cyber-neon",
            name: "Cyber Neon",
            category: "Futuristic",
            description: "Deep true OLED blacks with electric bioluminescent cyan, magenta rim lighting, and subtle volumetric fog.",
            iconSystemName: "bolt.fill",
            sampleGradientColors: ["#0B0D1B", "#1C103A", "#00F5FF"],
            promptSuffix: "cyberpunk aesthetic, crisp neon rim light, deep pure black background (#000000), dramatic studio lighting, 8k wallpaper, unreal engine 5 render, raytraced reflections, sharp focus on subject, perfectly framed for smartphone lock screen",
            negativePrompt: "bright background, blown out highlights, messy noise, watermark, distorted hands, blurry eyes",
            contrastBoost: 1.25,
            isPro: false
        ),
        GenerationStyle(
            id: "minimalist-dark",
            name: "Minimalist OLED",
            category: "Minimal",
            description: "Ultra-clean matte subject silhouette with 95% true black pixels, optimized for battery saving & lock screen clock clarity.",
            iconSystemName: "circle.lefthalf.filled",
            sampleGradientColors: ["#000000", "#141414", "#303030"],
            promptSuffix: "minimalist aesthetic, solid OLED pure black background, elegant soft studio edge lighting, smooth contour silhouette, Apple design language, ultra clean composition, negative space reserved for clock at top",
            negativePrompt: "complex clutter, detailed background, noise, gradient banding, artifacts",
            contrastBoost: 1.35,
            isPro: false
        ),
        GenerationStyle(
            id: "cinematic-golden",
            name: "Golden Hour Cinema",
            category: "Photorealistic",
            description: "35mm anamorphic warm sunlight, soft bokeh background, natural skin tones, and rich organic depth.",
            iconSystemName: "sun.max.fill",
            sampleGradientColors: ["#1F1206", "#4A2508", "#E69C24"],
            promptSuffix: "cinematic 35mm film photography, golden hour sunset backlight, dreamy creamy bokeh, Kodak Portra 400 tones, atmospheric dust motes, subject positioned below upper third, vertical portrait 9:19.5 aspect ratio",
            negativePrompt: "digital look, oversaturated plastic textures, bad anatomy, text, lowres",
            contrastBoost: 1.1,
            isPro: true
        ),
        GenerationStyle(
            id: "abstract-glass",
            name: "Liquid Glassmorphism",
            category: "Abstract",
            description: "Translucent frosted refractive glass, iridescence, and smooth fluid ribbon dynamics inspired by iOS design.",
            iconSystemName: "drop.fill",
            sampleGradientColors: ["#0A192F", "#1D3557", "#457B9D"],
            promptSuffix: "abstract frosted glass ribbon sculpture, liquid crystal refraction, chromatic aberration, caustics, iOS 18 glassmorphic visual language, smooth gradient background, premium wallpaper",
            negativePrompt: "muddy colors, harsh pixelation, low resolution, flat texture",
            contrastBoost: 1.15,
            isPro: true
        ),
        GenerationStyle(
            id: "anime-studio",
            name: "Makoto Shinkai Dream",
            category: "Anime & Art",
            description: "Luminous twilight skies, painted clouds, vibrant color saturation, and expressive hand-painted aesthetics.",
            iconSystemName: "paintbrush.pointed.fill",
            sampleGradientColors: ["#1A102F", "#3B185F", "#A12568"],
            promptSuffix: "Makoto Shinkai style anime key visual, starry twilight sky, cumulus painted clouds, emotive atmospheric lighting, masterwork anime background art, vibrant yet soft colors, vertical lock screen orientation",
            negativePrompt: "chibi, low quality drawing, rough sketch, scribbles, text",
            contrastBoost: 1.2,
            isPro: false
        ),
        GenerationStyle(
            id: "noir-monochrome",
            name: "Architectural Noir",
            category: "Monochrome",
            description: "High-contrast chiaroscuro black & white, razor-sharp architectural lines, and bold shadows.",
            iconSystemName: "shadow",
            sampleGradientColors: ["#050505", "#181818", "#FFFFFF"],
            promptSuffix: "dramatic film noir black and white photography, chiaroscuro lighting, deep rich blacks, high dynamic range, sharp architectural shadows, Leica Monochrom look, vertical framing",
            negativePrompt: "color, sepia, blurry, low contrast, washed out gray",
            contrastBoost: 1.4,
            isPro: true
        )
    ]
}
