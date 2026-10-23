import SwiftUI

public struct LockScreenPreviewView: View {
    let baseImage: UIImage
    let subjectCutout: UIImage?
    let enableDepthEffect: Bool
    let overlayDimming: Double
    let clockFontName: ClockFontStyle
    
    public enum ClockFontStyle: String, CaseIterable, Identifiable {
        case standard = "Standard"
        case rounded = "Rounded"
        case serif = "Serif"
        case stencil = "Stencil"
        
        public var id: String { rawValue }
    }
    
    private var currentTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter.string(from: Date())
    }
    
    private var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date()).uppercased()
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                // 1. Base Wallpaper
                Image(uiImage: baseImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                
                // 2. Dimming overlay for readability
                if overlayDimming > 0.05 {
                    Color.black.opacity(overlayDimming)
                }
                
                // 3. Lock Screen UI Layer (Clock & Widgets)
                VStack(spacing: 0) {
                    // Top Status Bar & Dynamic Island
                    HStack {
                        Text("9:41")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        // Dynamic Island capsule
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
                    
                    // Date
                    Text(currentDateString)
                        .font(.system(size: 13, weight: .semibold))
                        .tracking(1.2)
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.top, 24)
                    
                    // Massive Clock
                    Text(currentTimeString)
                        .font(clockFont)
                        .foregroundColor(.white.opacity(0.95))
                        .shadow(color: Color.black.opacity(0.35), radius: 10, y: 4)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    // Lock Screen Widgets Row
                    HStack(spacing: 16) {
                        widgetCard(icon: "heart.fill", label: "72 BPM", color: .red)
                        widgetCard(icon: "bolt.fill", label: "94%", color: .green)
                        widgetCard(icon: "sun.max.fill", label: "78°", color: .yellow)
                    }
                    .padding(.top, 4)
                    
                    Spacer()
                    
                    // Bottom Quick Action Buttons
                    HStack {
                        quickActionButton(icon: "flashlight.off.fill")
                        Spacer()
                        quickActionButton(icon: "camera.fill")
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 16)
                    
                    // Home Indicator
                    Capsule()
                        .fill(Color.white)
                        .frame(width: 134, height: 5)
                        .padding(.bottom, 8)
                }
                
                // 4. Foreground Subject Cutout (Depth Effect)
                // When enabled, the subject's head/contour layers OVER the clock!
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
