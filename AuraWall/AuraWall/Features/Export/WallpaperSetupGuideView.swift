import SwiftUI

public struct WallpaperSetupGuideView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let steps = [
        GuideStep(
            number: "1",
            title: "Long-Press Lock Screen",
            description: "Wake your iPhone and long-press anywhere on your current Lock Screen until the wallpaper gallery selector appears.",
            icon: "hand.tap.fill"
        ),
        GuideStep(
            number: "2",
            title: "Tap the Blue Plus (+) Button",
            description: "Tap the '+' button in the bottom-right corner to create a new wallpaper configuration.",
            icon: "plus.circle.fill"
        ),
        GuideStep(
            number: "3",
            title: "Select 'Photos' & Choose AuraWall",
            description: "Tap the 'Photos' button at the top and select the 4K wallpaper you just exported from AuraWall.",
            icon: "photo.on.rectangle"
        ),
        GuideStep(
            number: "4",
            title: "Depth Effect Automatic Activation",
            description: "Because AuraWall engineered the composition and safe zones, iOS will automatically detect the subject and place the time behind it.",
            icon: "square.2.layers.3d.top.filled"
        ),
        GuideStep(
            number: "5",
            title: "Set as Wallpaper Pair",
            description: "Tap 'Add' in the top-right corner, then choose 'Set as Wallpaper Pair' or customize your Home Screen blur.",
            icon: "checkmark.circle.fill"
        )
    ]
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.auraDarkBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        headerSection
                        
                        ForEach(steps) { step in
                            stepCard(step)
                        }
                        
                        proTipCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("iOS Setup Instructions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Setting Your AI Wallpaper")
                .font(.title3.weight(.bold))
                .foregroundColor(.white)
            Text("Follow these official Apple iOS steps to activate the native Depth Effect.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
    }
    
    private func stepCard(_ step: GuideStep) -> some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.auraAccent.opacity(0.2))
                    .frame(width: 44, height: 44)
                Text(step.number)
                    .font(.headline.weight(.black))
                    .foregroundColor(Color.auraCyan)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(step.title)
                        .font(.subheadline.weight(.bold))
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: step.icon)
                        .font(.caption)
                        .foregroundColor(Color.auraCyan)
                }
                
                Text(step.description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.75))
                    .lineSpacing(3)
            }
        }
        .padding(16)
        .glassCard(cornerRadius: 16)
    }
    
    private var proTipCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("Pro Depth Effect Tip")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white)
            }
            
            Text("If iOS disables Depth Effect on the preview screen, tap the three dots (...) in the lower right of Apple's wallpaper editor and ensure 'Depth Effect' is checked. AuraWall keeps subject overlap under 25% to guarantee iOS compatibility.")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
                .lineSpacing(3)
        }
        .padding(16)
        .background(Color.yellow.opacity(0.08))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.yellow.opacity(0.2), lineWidth: 1)
        )
    }
}

struct GuideStep: Identifiable {
    let id = UUID()
    let number: String
    let title: String
    let description: String
    let icon: String
}
