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
        case .monthly: return "Pro Aylık"
        case .yearly: return "Pro Yıllık (En İyi Değer)"
        case .lifetime: return "Ömür Boyu Erişim"
        }
    }
    
    public var priceDisplay: String {
        switch self {
        case .monthly: return "₺149,99 / ay"
        case .yearly: return "₺899,99 / yıl (₺75/ay)"
        case .lifetime: return "₺1.799,99 tek seferlik"
        }
    }
    
    public var trialDescription: String? {
        switch self {
        case .yearly: return "3 günlük ücretsiz deneme dahil"
        default: return nil
        }
    }
    
    public static let features: [SubscriptionFeature] = [
        SubscriptionFeature(
            icon: "sparkles",
            title: "Sınırsız 4K Yapay Zeka Üretimi",
            subtitle: "FLUX 1.1 Pro ve DALL-E 3 ultra çözünürlük ile desteklenir"
        ),
        SubscriptionFeature(
            icon: "clock.badge.checkmark",
            title: "Akıllı Kilit Ekranı Derinlik Matting",
            subtitle: "Otomatik saat örtüşme yönetimi ve ön plan katman ayrımı"
        ),
        SubscriptionFeature(
            icon: "paintpalette.fill",
            title: "Özel Pro Estetik Ön Ayarlar",
            subtitle: "Sıvı cam efekti, sinematik 35mm ve OLED saf siyah stiller"
        ),
        SubscriptionFeature(
            icon: "bolt.badge.automatic",
            title: "Ultra Hızlı GPU Öncelik Kuyruğu",
            subtitle: "Bekleme süresi olmadan 4 saniyenin altında varyasyon üret"
        ),
        SubscriptionFeature(
            icon: "arrow.down.to.line.compact",
            title: "Kayıpsız PNG ve Canlı Fotoğraf Dışa Aktarım",
            subtitle: "iPhone ekranınıza doğrudan eşlenmiş 1290x2796 çözünürlük"
        )
    ]
}
