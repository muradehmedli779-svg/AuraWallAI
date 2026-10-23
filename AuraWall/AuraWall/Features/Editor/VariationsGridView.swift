import SwiftUI

public struct VariationsGridView: View {
    @Binding var project: WallpaperProject
    let onSelectVariation: (WallpaperVariation) -> Void
    let onRegenerate: () -> Void
    
    @EnvironmentObject var storageManager: StorageManager
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Generated Variations (\(project.variations.count))")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Button(action: {
                    HapticManager.shared.medium()
                    onRegenerate()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.clockwise")
                        Text("Regenerate")
                    }
                    .font(.caption.weight(.bold))
                    .foregroundColor(Color.auraCyan)
                }
            }
            .padding(.horizontal, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(project.variations) { variation in
                        let isSelected = project.selectedVariationId == variation.id
                        
                        Button(action: {
                            HapticManager.shared.light()
                            project.selectedVariationId = variation.id
                            onSelectVariation(variation)
                        }) {
                            ZStack(alignment: .topTrailing) {
                                Group {
                                    if let local = variation.localFilename, let img = storageManager.loadImage(named: local) {
                                        Image(uiImage: img)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } else {
                                        Color.auraCardBg
                                            .overlay(ProgressView())
                                    }
                                }
                                .frame(width: 80, height: 160)
                                .clipped()
                                .cornerRadius(14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(isSelected ? Color.auraCyan : Color.white.opacity(0.1), lineWidth: isSelected ? 2.5 : 1)
                                )
                                
                                if isSelected {
                                    Circle()
                                        .fill(Color.auraCyan)
                                        .frame(width: 20, height: 20)
                                        .overlay(
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.black)
                                        )
                                        .padding(6)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}
