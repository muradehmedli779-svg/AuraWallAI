import SwiftUI

public struct GenerationProgressView: View {
    let sourceImage: UIImage
    let analysis: ImageAnalysisResult
    let style: GenerationStyle
    let device: DeviceProfile
    let customPrompt: String
    let variationCount: Int
    
    @EnvironmentObject var storageManager: StorageManager
    @State private var currentStepText = "Sinir ağı kompozisyonu hazırlanıyor..."
    @State private var progressFraction: Double = 0.15
    @State private var completedProject: WallpaperProject?
    @State private var navigateToEditor = false
    @State private var errorMessage: String?
    
    public var body: some View {
        ZStack {
            Color.auraDarkBg.ignoresSafeArea()
            
            VStack(spacing: 36) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 8)
                        .frame(width: 140, height: 140)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(progressFraction))
                        .stroke(
                            LinearGradient(
                                colors: [Color.auraAccent, Color.auraCyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.4), value: progressFraction)
                    
                    VStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 32))
                            .foregroundColor(Color.auraCyan)
                        Text("%\(Int(progressFraction * 100))")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.white)
                    }
                }
                
                VStack(spacing: 12) {
                    Text("Duvar Kağıtları Oluşturuluyor")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.white)
                    
                    Text(currentStepText)
                        .font(.subheadline)
                        .foregroundColor(Color.auraCyan)
                        .multilineTextAlignment(.center)
                    
                    Text("Hedef: \(device.name) (\(device.pixelWidth)×\(device.pixelHeight))")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
                
                Spacer()
                
                if let error = errorMessage {
                    VStack(spacing: 8) {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                        Button("Tekrar Dene") {
                            Task { await runPipeline() }
                        }
                        .font(.subheadline.weight(.bold))
                        .foregroundColor(.white)
                    }
                }
            }
            .padding(32)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToEditor) {
            if let project = completedProject {
                WallpaperEditorView(project: project)
            }
        }
        .task {
            await runPipeline()
        }
    }
    
    private func runPipeline() async {
        errorMessage = nil
        
        // Adım 1: Konu sabitleme ve istem hazırlama
        withAnimation {
            progressFraction = 0.25
            currentStepText = "Konu kimliği ve saat uyumluluk kısıtları kodlanıyor..."
        }
        try? await Task.sleep(nanoseconds: 600_000_000)
        
        // Adım 2: Yapay Zeka Üretim Motoru
        withAnimation {
            progressFraction = 0.55
            currentStepText = "\(style.name) stiliyle 4K OLED katmanları işleniyor..."
        }
        
        do {
            let variations = try await WallpaperGenerationService.shared.generateVariations(
                sourceImage: sourceImage,
                analysis: analysis,
                style: style,
                device: device,
                customPrompt: customPrompt,
                variationCount: variationCount
            )
            
            // Adım 3: Derinlik katmanı çıkarma
            withAnimation {
                progressFraction = 0.85
                currentStepText = "Kilit ekranı derinlik katmanları çıkarılıyor..."
            }
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            // Kaynak görseli diske kaydet
            let originalFilename = try? StorageManager.shared.saveImage(sourceImage, prefix: "source")
            
            var project = WallpaperProject(
                title: "\(style.name) Duvar Kağıdı",
                originalImageFilename: originalFilename,
                analysisResult: analysis,
                selectedStyleId: style.id,
                customPromptModifier: customPrompt,
                targetDeviceProfileId: device.id,
                variations: variations,
                selectedVariationId: variations.first?.id
            )
            
            withAnimation {
                progressFraction = 1.0
                currentStepText = "Duvar kağıtları hazır!"
            }
            try? await Task.sleep(nanoseconds: 300_000_000)
            
            storageManager.saveProject(project)
            self.completedProject = project
            self.navigateToEditor = true
            HapticManager.shared.success()
        } catch {
            self.errorMessage = "Oluşturma başarısız: \(error.localizedDescription)"
            HapticManager.shared.error()
        }
    }
}
