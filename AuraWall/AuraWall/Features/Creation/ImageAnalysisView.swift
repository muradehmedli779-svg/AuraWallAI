import SwiftUI

public struct ImageAnalysisView: View {
    let sourceImage: UIImage
    
    @State private var isAnalyzing = true
    @State private var analysisResult: ImageAnalysisResult?
    @State private var selectedDevice: DeviceProfile = .currentDevice
    @State private var navigateToStyle = false
    
    public var body: some View {
        ZStack {
            Color.auraDarkBg.ignoresSafeArea()
            
            if isAnalyzing {
                loadingAnalysisView
            } else if let analysis = analysisResult {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        analysisPreviewCanvas(analysis)
                        metricsSummaryCard(analysis)
                        clockSafeAssessmentCard(analysis)
                        colorPaletteCard(analysis)
                        
                        proceedToStyleButton(analysis)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
        }
        .navigationTitle("Konu ve Derinlik Analizi")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToStyle) {
            if let analysis = analysisResult {
                StyleSelectionView(sourceImage: sourceImage, analysis: analysis, targetDevice: selectedDevice)
            }
        }
        .task {
            await runAnalysis()
        }
    }
    
    private var loadingAnalysisView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.6)
                .tint(Color.auraCyan)
            
            Text("Konu ve Derinlik Analizi Yapılıyor...")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Sınırlayıcı kutular, odak bölgeleri ve iOS kilit ekranı saat uyumluluğu kontrol ediliyor.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    private func analysisPreviewCanvas(_ analysis: ImageAnalysisResult) -> some View {
        ZStack {
            Image(uiImage: sourceImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 340)
                .cornerRadius(18)
                .overlay(
                    GeometryReader { geo in
                        let w = geo.size.width
                        let h = geo.size.height
                        
                        // Subject Bounding Box Overlay
                        let box = analysis.boundingBox
                        let rect = CGRect(x: box.origin.x * w, y: box.origin.y * h, width: box.width * w, height: box.height * h)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.auraCyan, lineWidth: 2)
                            .frame(width: rect.width, height: rect.height)
                            .position(x: rect.midX, y: rect.midY)
                            .overlay(
                                Text(analysis.subjectType)
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.auraCyan)
                                    .cornerRadius(4)
                                    .position(x: rect.midX, y: rect.minY - 10)
                            )
                        
                        // Simulated Lock Screen Clock Safe Area
                        let clockArea = selectedDevice.clockSafeArea
                        let clockRect = CGRect(x: clockArea.origin.x * w, y: clockArea.origin.y * h, width: clockArea.width * w, height: clockArea.height * h)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                analysis.clockSafeRegion.isClockOccluded ? Color.orange : Color.green,
                                style: StrokeStyle(lineWidth: 1.5, dash: [4, 4])
                            )
                            .frame(width: clockRect.width, height: clockRect.height)
                            .position(x: clockRect.midX, y: clockRect.midY)
                            .overlay(
                                Text(analysis.clockSafeRegion.isClockOccluded ? "Saat Çakışması (Derinlik Modu)" : "Saat Bölgesi Uygun")
                                    .font(.system(size: 9, weight: .heavy))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(analysis.clockSafeRegion.isClockOccluded ? Color.orange : Color.green)
                                    .cornerRadius(4)
                                    .position(x: clockRect.midX, y: clockRect.maxY + 10)
                            )
                    }
                )
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }
    
    private func metricsSummaryCard(_ analysis: ImageAnalysisResult) -> some View {
        HStack(spacing: 12) {
            metricItem(
                title: "Konu",
                value: analysis.subjectType,
                subvalue: "%\(Int(analysis.subjectConfidence * 100)) eşleşme",
                icon: "person.crop.circle.badge.checkmark"
            )
            
            metricItem(
                title: "Derinlik Efekti",
                value: analysis.depthEffectScore > 0.7 ? "Uygun" : "Standart",
                subvalue: "%\(Int(analysis.depthEffectScore * 100)) puan",
                icon: "square.2.layers.3d"
            )
        }
    }
    
    private func metricItem(title: String, value: String, subvalue: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color.auraCyan)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
            Text(subvalue)
                .font(.caption2)
                .foregroundColor(Color.auraCyan.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .glassCard(cornerRadius: 16)
    }
    
    private func clockSafeAssessmentCard(_ analysis: ImageAnalysisResult) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "clock.badge.checkmark.fill")
                    .foregroundColor(analysis.clockSafeRegion.isClockOccluded ? .orange : .green)
                Text("Kilit Ekranı Saat Kompozisyonu")
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.white)
            }
            
            Text(analysis.clockSafeRegion.safeRecommendation)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(3)
            
            ForEach(analysis.compositionTips, id: \.self) { tip in
                HStack(alignment: .top, spacing: 6) {
                    Text("•").foregroundColor(Color.auraCyan)
                    Text(tip)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .glassCard(cornerRadius: 18)
    }
    
    private func colorPaletteCard(_ analysis: ImageAnalysisResult) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Baskın Renkler")
                .font(.caption.weight(.bold))
                .foregroundColor(.white.opacity(0.7))
            
            HStack(spacing: 10) {
                ForEach(analysis.dominantColorsHex, id: \.self) { hex in
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color(hex: hex) ?? .gray)
                            .frame(width: 16, height: 16)
                        Text(hex)
                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(8)
                }
            }
        }
    }
    
    private func proceedToStyleButton(_ analysis: ImageAnalysisResult) -> some View {
        Button(action: {
            HapticManager.shared.medium()
            navigateToStyle = true
        }) {
            HStack(spacing: 8) {
                Text("Stil Seç ve Oluştur")
                    .font(.headline.weight(.bold))
                Image(systemName: "arrow.right")
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
            .shadow(color: Color.auraAccent.opacity(0.4), radius: 12)
        }
        .padding(.top, 10)
    }
    
    private func runAnalysis() async {
        do {
            let result = try await ImageAnalysisService.shared.analyzeLocally(image: sourceImage, targetDevice: selectedDevice)
            self.analysisResult = result
            self.isAnalyzing = false
            HapticManager.shared.success()
        } catch {
            self.isAnalyzing = false
        }
    }
}
