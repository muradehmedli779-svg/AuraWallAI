import SwiftUI

public struct LockScreenPreviewView: View {
    let baseImage: UIImage
    let subjectCutout: UIImage?
    let enableDepthEffect: Bool
    let overlayDimming: Double
    let clockFontName: ClockFontStyle
    
    public enum ClockFontStyle: String, CaseIterable, Identifiable {
        case standard = "Standart"
        case rounded = "Yuvarlak"
        case serif = "Serif"
        case stencil = "Şablon"
        
        public var id: String { rawValue }
    }
    
    private var currentTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter.string(from: Date())
    }
    
    private var currentDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: Date()).uppercased()
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                // 1. Arka Plan Duvar Kağıdı
                Image(uiImage: baseImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                
                // 2. Okunabilirlik için karartma katmanı
                if overlayDimming > 0.05 {
                    Color.black.opacity(overlayDimming)
                }
                
                // 3. Kilit Ekranı Arayüz Katmanı (Saat ve Widget'lar)
                VStack(spacing: 0) {
                    // Üst Durum Çubuğu ve Dynamic Island
                    HStack {
                        Text("9:41")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        // Dynamic Island kapsülü
                        Capsule()
                            .fill(Color.black)
                            .frame(width: 110, height: 28)
                        Spacer()
                        HStack(spacing: 5) {
                            Image(systemName: "cellularbars")
                            Image(systemName: "wifi")
                            Image(systemName: "battery.100")
                        }
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 14)
                    
                    // Tarih
                    Text(currentDateString)
                        .font(.system(size: 13, weight: .semibold))
                        .tracking(1.2)
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.top, 24)
                    
                    // Büyük Saat
                    Text(currentTimeString)
                        .font(clockFont)
                        .foregroundColor(.white.opacity(0.95))
                        .shadow(color: Color.black.opacity(0.35), radius: 10, y: 4)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    // Kilit Ekranı Widget Satırı
                    HStack(spacing: 16) {
                        widgetCard(icon: "heart.fill", label: "72 NBD", color: .red)
                        widgetCard(icon: "bolt.fill", label: "%94", color: .green)
                        widgetCard(icon: "sun.max.fill", label: "26°C", color: .yellow)
                    }
                    .padding(.top, 4)
                    
                    Spacer()
                    
                    // Alt Hızlı Eylem Butonları
                    HStack {
                        quickActionButton(icon: "flashlight.off.fill")
                        Spacer()
                        quickActionButton(icon: "camera.fill")
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 16)
                    
                    // Ana Sayfa Göstergesi
                    Capsule()
                        .fill(Color.white)
                        .frame(width: 134, height: 5)
                        .padding(.bottom, 8)
                }
                
                // 4. Ön Plan Konu Kesimi (Derinlik Efekti)
                // Etkinleştirildiğinde konunun başı/konturu saatin ÜSTÜNE gelir!
                if enableDepthEffect, let cutout = subjectCutout {
                    Image(uiImage: cutout)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .allowsHitTesting(false)
                }
            }
        }
    }
    
    private var clockFont: Font {
        switch clockFontName {
        case .standard:
            return .system(size: 86, weight: .bold, design: .default)
        case .rounded:
            return .system(size: 86, weight: .heavy, design: .rounded)
        case .serif:
            return .system(size: 86, weight: .bold, design: .serif)
        case .stencil:
            return .system(size: 86, weight: .black, design: .monospaced)
        }
    }
    
    private func widgetCard(icon: String, label: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.black.opacity(0.35))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
        )
    }
    
    private func quickActionButton(icon: String) -> some View {
        Circle()
            .fill(Color.black.opacity(0.4))
            .frame(width: 50, height: 50)
            .overlay(
                Circle().stroke(Color.white.opacity(0.15), lineWidth: 0.5)
            )
            .overlay(
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            )
    }
}
