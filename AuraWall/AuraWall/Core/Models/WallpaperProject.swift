import SwiftUI

/// Project containing user source image, analysis results, generated variations, and editor state
public struct WallpaperProject: Identifiable, Codable, Hashable {
    public let id: UUID
    public var title: String
    public let createdAt: Date
    public var updatedAt: Date
    
    // Original photo references
    public var originalImageFilename: String?
    public var analysisResult: ImageAnalysisResult?
    
    // Generation configuration
    public var selectedStyleId: String
    public var customPromptModifier: String
    public var targetDeviceProfileId: String
    
    // Results
    public var variations: [WallpaperVariation]
    public var selectedVariationId: UUID?
    
    // Editor Transform state
    public var scale: CGFloat
    public var offset: CGSize
    public var blurBackground: Double // 0.0 to 20.0
    public var overlayDimming: Double // 0.0 to 0.7
    public var enableDepthEffect: Bool
    
    public init(
        id: UUID = UUID(),
        title: String = "Untitled Wallpaper",
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        originalImageFilename: String? = nil,
        analysisResult: ImageAnalysisResult? = nil,
        selectedStyleId: String = "cyber-neon",
        customPromptModifier: String = "",
        targetDeviceProfileId: String = DeviceProfile.currentDevice.id,
        variations: [WallpaperVariation] = [],
        selectedVariationId: UUID? = nil,
        scale: CGFloat = 1.0,
        offset: CGSize = .zero,
        blurBackground: Double = 0.0,
        overlayDimming: Double = 0.0,
        enableDepthEffect: Bool = true
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.originalImageFilename = originalImageFilename
        self.analysisResult = analysisResult
        self.selectedStyleId = selectedStyleId
        self.customPromptModifier = customPromptModifier
        self.targetDeviceProfileId = targetDeviceProfileId
        self.variations = variations
        self.selectedVariationId = selectedVariationId
        self.scale = scale
        self.offset = offset
        self.blurBackground = blurBackground
        self.overlayDimming = overlayDimming
        self.enableDepthEffect = enableDepthEffect
    }
}

public struct WallpaperVariation: Identifiable, Codable, Hashable {
    public let id: UUID
    public let generatedAt: Date
    public let imageURLString: String?
    public let localFilename: String?
    public let depthMaskFilename: String?
    public let promptUsed: String
    public let providerName: String // "DALL-E 3", "Flux 1.1 Pro", "SDXL", "AuraEngine"
    public let seed: Int
    public let width: Int
    public let height: Int
    public var isFavorite: Bool
    
    public init(
        id: UUID = UUID(),
        generatedAt: Date = Date(),
        imageURLString: String? = nil,
        localFilename: String? = nil,
        depthMaskFilename: String? = nil,
        promptUsed: String = "",
        providerName: String = "AuraEngine",
        seed: Int = Int.random(in: 100000...999999),
        width: Int = 1290,
        height: Int = 2796,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.generatedAt = generatedAt
        self.imageURLString = imageURLString
        self.localFilename = localFilename
        self.depthMaskFilename = depthMaskFilename
        self.promptUsed = promptUsed
        self.providerName = providerName
        self.seed = seed
        self.width = width
        self.height = height
        self.isFavorite = isFavorite
    }
}
