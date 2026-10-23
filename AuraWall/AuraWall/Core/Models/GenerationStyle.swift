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
            name: "Siber Neon",
            category: "Fütüristik",
            description: "Derin gerçek OLED siyahları, elektrik mavi ve macenta ışık haleleri, kilit ekranı için mükemmel neon estetiği.",
            iconSystemName: "bolt.fill",
            sampleGradientColors: ["#0B0D1B", "#1C103A", "#00F5FF"],
            promptSuffix: "cyberpunk aesthetic, crisp vivid neon rim lighting, bioluminescent cyan and purple accents, deep OLED pure black background, dramatic cinematic studio lighting, 8k wallpaper, unreal engine 5 render, raytraced reflections, sharp focus on subject, perfectly framed for smartphone lock screen",
            negativePrompt: "bright background, blown out highlights, messy noise, watermark, distorted hands, blurry eyes",
            contrastBoost: 1.25,
            isPro: false
        ),
        GenerationStyle(
            id: "minimalist-dark",
            name: "Minimalist OLED",
            category: "Minimal",
            description: "Pil tasarrufu sağlayan %98 saf siyah pikseller ve saat netliğini koruyan ultra sade silüet.",
            iconSystemName: "circle.lefthalf.filled",
            sampleGradientColors: ["#000000", "#141414", "#303030"],
            promptSuffix: "minimalist aesthetic, solid OLED pure pitch black background (#000000), elegant soft studio edge lighting, smooth contour silhouette, Apple design language, ultra clean composition, negative space reserved for clock at top",
            negativePrompt: "complex clutter, detailed background, noise, gradient banding, artifacts",
            contrastBoost: 1.35,
            isPro: false
        ),
        GenerationStyle(
            id: "cinematic-golden",
            name: "Altın Saat Sinematik",
            category: "Foto Gerçekçi",
            description: "35mm anamorfik sıcak gün batımı ışığı, ipeksi arka plan bulanıklığı ve zengin organik derinlik.",
            iconSystemName: "sun.max.fill",
            sampleGradientColors: ["#1F1206", "#4A2508", "#E69C24"],
            promptSuffix: "cinematic 35mm film photography, golden hour sunset backlight, dreamy creamy bokeh, Kodak Portra 400 tones, atmospheric dust motes, subject positioned below upper third, vertical portrait 9:19.5 aspect ratio",
            negativePrompt: "digital look, oversaturated plastic textures, bad anatomy, text, lowres",
            contrastBoost: 1.1,
            isPro: false
        ),
        GenerationStyle(
            id: "abstract-glass",
            name: "Akışkan Cam",
            category: "Soyut",
            description: "Yarı saydam buzlu cam, prizmatik renk kırılmaları ve modern iOS tasarım dilinden ilham alan akışkan dalgalar.",
            iconSystemName: "drop.fill",
            sampleGradientColors: ["#0A192F", "#1D3557", "#457B9D"],
            promptSuffix: "abstract frosted glass ribbon sculpture, liquid crystal refraction, chromatic aberration, caustics, iOS 18 glassmorphic visual language, smooth gradient background, premium wallpaper",
            negativePrompt: "muddy colors, harsh pixelation, low resolution, flat texture",
            contrastBoost: 1.15,
            isPro: false
        ),
        GenerationStyle(
            id: "anime-studio",
            name: "Anime Başyapıtı",
            category: "Sanat & Anime",
            description: "Makoto Shinkai tarzı parıldayan alacakaranlık gökyüzü, yıldızlı bulutlar ve büyüleyici el çizimi detaylar.",
            iconSystemName: "paintbrush.pointed.fill",
            sampleGradientColors: ["#1A102F", "#3B185F", "#A12568"],
            promptSuffix: "Makoto Shinkai style anime key visual, starry twilight sky, cumulus painted clouds, emotive atmospheric lighting, masterwork anime background art, vibrant yet soft colors, vertical lock screen orientation",
            negativePrompt: "chibi, low quality drawing, rough sketch, scribbles, text",
            contrastBoost: 1.2,
            isPro: false
        ),
        GenerationStyle(
            id: "noir-monochrome",
            name: "Mimari Siyah-Beyaz",
            category: "Monokrom",
            description: "Yüksek kontrastlı ışık-gölge dengesi, keskin mimari çizgiler ve dramatik film noir etkisi.",
            iconSystemName: "shadow",
            sampleGradientColors: ["#050505", "#181818", "#FFFFFF"],
            promptSuffix: "dramatic film noir black and white photography, chiaroscuro lighting, deep rich blacks, high dynamic range, sharp architectural shadows, Leica Monochrom look, vertical framing",
            negativePrompt: "color, sepia, blurry, low contrast, washed out gray",
            contrastBoost: 1.4,
            isPro: false
        )
    ]
}
