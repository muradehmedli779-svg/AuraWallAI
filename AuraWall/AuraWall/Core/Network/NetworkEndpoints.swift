import Foundation

public enum NetworkEndpoint {
    case analyzeImage
    case generateWallpaper
    case upscaleImage
    case healthCheck
    
    public var path: String {
        switch self {
        case .analyzeImage: return "/analyze"
        case .generateWallpaper: return "/generate"
        case .upscaleImage: return "/export/upscale"
        case .healthCheck: return "/health"
        }
    }
}

// Request and Response Codable Payloads
public struct AnalyzeImageResponse: Codable {
    public let success: Bool
    public let subjectType: String
    public let confidence: Float
    public let boundingBox: [Double] // [x, y, width, height]
    public let dominantColors: [String]
    public let clockSafeRegion: ClockSafePayload
    public let depthEffectScore: Float
    public let compositionTips: [String]
}

public struct ClockSafePayload: Codable {
    public let isClockOccluded: Bool
    public let occlusionRatio: Float
    public let safeRecommendation: String
    public let verticalOffsetSuggested: Double
}

public struct GenerateWallpaperRequest: Codable {
    public let styleId: String
    public let promptModifier: String
    public let targetWidth: Int
    public let targetHeight: Int
    public let variationsCount: Int
    public let preserveSubjectData: String? // base64 encoded thumbnail if subject guided
    public let deviceProfileId: String
}

public struct GenerateWallpaperResponse: Codable {
    public let success: Bool
    public let provider: String
    public let promptUsed: String
    public let variations: [GeneratedVariationPayload]
}

public struct GeneratedVariationPayload: Codable {
    public let id: String
    public let imageBase64: String?
    public let imageURL: String?
    public let depthMaskBase64: String?
    public let seed: Int
    public let width: Int
    public let height: Int
}
