import SwiftUI

public struct StyleSelectionView: View {
    let sourceImage: UIImage
    let analysis: ImageAnalysisResult
    @State var targetDevice: DeviceProfile
    
    @EnvironmentObject var storeKitManager: StoreKitManager
    @State private var selectedStyle: GenerationStyle = GenerationStyle.styles[0]
    @State private var customPrompt: String = ""
    @State private var variationCount: Int = 3
    @State private var navigateToProgress = false
    @State private var showingPaywall = false
    
    public var body: some View {
        ZStack {
            Color.auraDarkBg.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    headerSection
                    deviceSelector
                    stylesGrid
                    promptCustomizer
                    generateCTA
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
        .navigationTitle("Aesthetic & Device")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToProgress) {
            GenerationProgressView(
                sourceImage: sourceImage,
                analysis: analysis,
                style: selectedStyle,
                device: targetDevice,
                customPrompt: customPrompt,
                variationCount: variationCount
            )
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Select Lock Screen Aesthetic")
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
            Text("Tuned for OLED contrast and high dynamic range displays.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
    }
    
    private var deviceSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Target iPhone Resolution")
                .font(.caption.weight(.bold))
                .foregroundColor(.white.opacity(0.7))
            
            Menu {
                ForEach(DeviceProfile.allDevices) { device in
                    Button(action: {
                        targetDevice = device
                    }) {
                        HStack {
                            Text(device.name)
                            if device.id == targetDevice.id {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "iphone")
                        .foregroundColor(Color.auraCyan)
                    Text(targetDevice.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(targetDevice.pixelWidth) × \(targetDevice.pixelHeight) px")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(14)
                .glassCard(cornerRadius: 14)
            }
        }
    }
    
    private var stylesGrid: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Curated Visual Styles")
                .font(.caption.weight(.bold))
                .foregroundColor(.white.opacity(0.7))
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                ForEach(GenerationStyle.styles) { style in
                    let isSelected = selectedStyle.id == style.id
                    
                    Button(action: {
                        HapticManager.shared.light()
                        if style.isPro && !storeKitManager.isProUser {
                            showingPaywall = true
                        } else {
                            selectedStyle = style
                        }
                    }) {
                        VStack(alignment: .leading, spacing: 10) {
                            ZStack(alignment: .topTrailing) {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: style.sampleGradientColors.compactMap { Color(hex: $0) },
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(height: 110)
                                    .overlay(
                                        Image(systemName: style.iconSystemName)
                                            .font(.system(size: 32))
                                            .foregroundColor(.white.opacity(0.85))
                                    )
                                
                                if style.isPro {
                                    Text("PRO")
                                        .font(.system(size: 9, weight: .heavy))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 3)
                                        .background(Color(hex: "#FFD700")!)
                                        .cornerRadius(6)
                                        .padding(8)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(style.name)
                                    .font(.subheadline.weight(.bold))
                                    .foregroundColor(.white)
                                Text(style.category)
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.auraCardBg)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(isSelected ? Color.auraCyan : Color.white.opacity(0.08), lineWidth: isSelected ? 2 : 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private var promptCustomizer: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Custom Details & Elements (Optional)")
                .font(.caption.weight(.bold))
                .foregroundColor(.white.opacity(0.7))
            
            HStack {
                Image(systemName: "pencil.and.outline")
                    .foregroundColor(Color.auraCyan)
                TextField("e.g. misty rainy night, iridescent smoke, gold particles...", text: $customPrompt)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .padding(14)
            .glassCard(cornerRadius: 14)
        }
    }
    
    private var generateCTA: some View {
        Button(action: {
            HapticManager.shared.heavy()
            navigateToProgress = true
        }) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                Text("Synthesize \(variationCount) Variations")
                    .font(.headline.weight(.bold))
            }
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
            .shadow(color: Color.auraAccent.opacity(0.4), radius: 14)
        }
        .padding(.top, 10)
    }
}
