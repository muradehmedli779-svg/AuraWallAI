import SwiftUI

/// Structured analysis result produced either on-device via Vision.framework or via backend analysis
public struct ImageAnalysisResult: Codable, Hashable {
    public let subjectType: String // "person", "pet", "vehicle", "architecture", "landscape", "object"
    public let subjectConfidence: Float
    public let boundingBox: CGRect // Normalized (0...1, 0...1) in iOS UIKit coordinate system
    public let dominantColorsHex: [String]
    public let clockSafeRegion: ClockSafeRegionAssessment
    public let depthEffectScore: Float // 0.0 to 1.0 likelihood of iOS Lock Screen depth effect working cleanly
    public let compositionTips: [String]
    public let recommendedFocalPoint: CGPoint // Normalized (0...1)
    public let estimatedBackgroundComplexity: Float // 0.0 clean to 1.0 busy
    
    public init(
        subjectType: String,
        subjectConfidence: Float,
        boundingBox: CGRect,
        dominantColorsHex: [String],
        clockSafeRegion: ClockSafeRegionAssessment,
        depthEffectScore: Float,
        compositionTips: [String],
        recommendedFocalPoint: CGPoint,
        estimatedBackgroundComplexity: Float = 0.3
    ) {
        self.subjectType = subjectType
        self.subjectConfidence = subjectConfidence
        self.boundingBox = boundingBox
        self.dominantColorsHex = dominantColorsHex
        self.clockSafeRegion = clockSafeRegion
        self.depthEffectScore = depthEffectScore
        self.compositionTips = compositionTips
        self.recommendedFocalPoint = recommendedFocalPoint
        self.estimatedBackgroundComplexity = estimatedBackgroundComplexity
    }
}

public struct ClockSafeRegionAssessment: Codable, Hashable {
    public let isClockOccluded: Bool
    public let occlusionRatio: Float // 0.0 (totally clear) to 1.0 (fully covered)
    public let safeRecommendation: String
    public let verticalOffsetSuggested: CGFloat // recommended shift for composition
    
    public init(
        isClockOccluded: Bool,
        occlusionRatio: Float,
        safeRecommendation: String,
        verticalOffsetSuggested: CGFloat
    ) {
        self.isClockOccluded = isClockOccluded
        self.occlusionRatio = occlusionRatio
        self.safeRecommendation = safeRecommendation
        self.verticalOffsetSuggested = verticalOffsetSuggested
    }
}
