import Foundation

public struct SubscriptionFeature: Identifiable, Hashable {
    public let id = UUID()
    public let icon: String
    public let title: String
    public let subtitle: String
}

public enum SubscriptionPlanType: String, CaseIterable, Identifiable {
    case monthly = "com.aurawall.app.pro.monthly"
    case yearly = "com.aurawall.app.pro.yearly"
    case lifetime = "com.aurawall.app.pro.lifetime"
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .monthly: return "Pro Monthly"
        case .yearly: return "Pro Yearly (Best Value)"
        case .lifetime: return "Lifetime Access"
        }
    }
    
    public var priceDisplay: String {
        switch self {
        case .monthly: return "$4.99 / mo"
        case .yearly: return "$29.99 / yr ($2.50/mo)"
        case .lifetime: return "$59.99 once"
        }
    }
    
    public var trialDescription: String? {
        switch self {
        case .yearly: return "Includes 3-day free trial"
        default: return nil
        }
    }
    
    public static let features: [SubscriptionFeature] = [
        SubscriptionFeature(
            icon: "sparkles",
            title: "Unlimited 4K AI Generations",
            subtitle: "Powered by FLUX 1.1 Pro and DALL-E 3 ultra resolution"
        ),
        SubscriptionFeature(
            icon: "clock.badge.checkmark",
            title: "Smart Lock Screen Depth Matting",
            subtitle: "Automatic clock occlusion handling and foreground layer separation"
        ),
        SubscriptionFeature(
            icon: "paintpalette.fill",
            title: "Exclusive Pro Aesthetic Presets",
            subtitle: "Liquid glassmorphism, cinematic 35mm, and OLED pure black styles"
        ),
        SubscriptionFeature(
            icon: "bolt.badge.automatic",
            title: "Ultra-Fast GPU Priority Queue",
            subtitle: "Generate variations in under 4 seconds without rate limits"
        ),
        SubscriptionFeature(
            icon: "arrow.down.to.line.compact",
            title: "Lossless PNG & Live Photo Export",
            subtitle: "Native 1290x2796 resolution mapped directly to your iPhone display"
        )
    ]
}
