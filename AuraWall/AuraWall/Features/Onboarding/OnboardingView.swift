import SwiftUI

public struct OnboardingView: View {
    @Binding var isCompleted: Bool
    @State private var currentStep = 0
    
    private let slides = [
        OnboardingSlide(
            badge: "NEXT-GEN AI",
            title: "Wallpapers Engineered for iPhone",
            description: "Say goodbye to stretched, messy backgrounds. AuraWall creates bespoke 4K wallpapers tailored to your exact Super Retina display.",
            systemIcon: "iphone.gen3",
            gradient: ["#9353FE", "#00F5FF"]
        ),
        OnboardingSlide(
            badge: "INTELLIGENT VISION",
            title: "Clock-Safe Depth Matting",
            description: "Our Apple Neural Engine vision model identifies subjects and analyzes clock occlusion to ensure flawless depth effect layering behind the iOS time.",
            systemIcon: "clock.badge.checkmark.fill",
            gradient: ["#FF2A85", "#9353FE"]
        ),
        OnboardingSlide(
            badge: "STUDIO QUALITY",
            title: "OLED Pure Blacks & 4K Detail",
            description: "Curated cinematic, cyberpunk, and liquid glass styles tuned for maximum battery efficiency and eye-catching dynamic range.",
            systemIcon: "sparkles",
            gradient: ["#00F5FF", "#3B82F6"]
        )
    ]
    
    public var body: some View {
        ZStack {
            Color.auraDarkBg.ignoresSafeArea()
            
            // Atmospheric background ambient glow
            RadialGradient(
                colors: [Color.auraAccent.opacity(0.2), Color.clear],
                center: .topLeading,
                startRadius: 20,
                endRadius: 400
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Top Skip
                HStack {
                    Spacer()
                    Button("Skip") {
                        complete()
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white.opacity(0.6))
                    .padding()
                }
                
                TabView(selection: $currentStep) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        slideCard(slides[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                // Bottom Action Button
                VStack(spacing: 16) {
                    Button(action: {
                        if currentStep < slides.count - 1 {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                currentStep += 1
                            }
                            HapticManager.shared.light()
                        } else {
                            complete()
                        }
                    }) {
                        Text(currentStep == slides.count - 1 ? "Get Started" : "Continue")
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [Color.auraAccent, Color.auraCyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(18)
                            .shadow(color: Color.auraAccent.opacity(0.4), radius: 16, y: 6)
                    }
                    .padding(.horizontal, 28)
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    private func slideCard(_ slide: OnboardingSlide) -> some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: slide.gradient.compactMap { Color(hex: $0) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                    .blur(radius: 20)
                    .opacity(0.6)
                
                Image(systemName: slide.systemIcon)
                    .font(.system(size: 64, weight: .light))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 20)
            
            Text(slide.badge)
                .font(.caption.weight(.black))
                .tracking(2.0)
                .foregroundColor(Color.auraCyan)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.auraCyan.opacity(0.12))
                .cornerRadius(20)
            
            Text(slide.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Text(slide.description)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 36)
            
            Spacer()
        }
    }
    
    private func complete() {
        HapticManager.shared.success()
        withAnimation {
            isCompleted = true
        }
    }
}

struct OnboardingSlide {
    let badge: String
    let title: String
    let description: String
    let systemIcon: String
    let gradient: [String]
}
