import SwiftUI

public struct WallpaperEditorView: View {
    @State var project: WallpaperProject
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var storageManager: StorageManager
    
    @State private var activeImage: UIImage?
    @State private var subjectCutout: UIImage?
    @State private var selectedClockFont: LockScreenPreviewView.ClockFontStyle = .rounded
    @State private var showingExportSheet = false
    @State private var isRegenerating = false
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.auraDarkBg.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    // Lock Screen Live Interactive Canvas
                    ZStack {
                        if let img = activeImage {
                            LockScreenPreviewView(
                                baseImage: img,
                                subjectCutout: subjectCutout,
                                enableDepthEffect: project.enableDepthEffect,
                                overlayDimming: project.overlayDimming,
                                clockFontName: selectedClockFont
                            )
                            .frame(maxWidth: 320, maxHeight: 540)
                            .cornerRadius(38)
                            .overlay(
                                RoundedRectangle(cornerRadius: 38)
                                    .stroke(Color.white.opacity(0.18), lineWidth: 3)
                            )
                            .shadow(color: Color.black.opacity(0.6), radius: 25, y: 10)
                        } else {
                            ProgressView()
                                .frame(width: 320, height: 540)
                        }
                    }
                    .padding(.top, 4)
                    
                    // Variations Selector
                    VariationsGridView(
                        project: $project,
                        onSelectVariation: { variation in
                            loadVariation(variation)
                        },
                        onRegenerate: {
                            Task { await regenerateMore() }
                        }
                    )
                    .padding(.horizontal, 20)
                    
                    // Quick Adjustment Controls
                    controlsBar
                        .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Export CTA
                    exportButton
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                }
            }
            .navigationTitle("Lock Screen Editor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        storageManager.saveProject(project)
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.8))
                }
            }
            .sheet(isPresented: $showingExportSheet) {
                if let img = activeImage {
                    ExportView(project: project, baseImage: img)
                }
            }
            .task {
                initialLoad()
            }
        }
    }
    
    private var controlsBar: some View {
        HStack(spacing: 16) {
            // Depth effect toggle
            Button(action: {
                HapticManager.shared.light()
                project.enableDepthEffect.toggle()
            }) {
                HStack(spacing: 6) {
                    Image(systemName: project.enableDepthEffect ? "square.2.layers.3d.top.filled" : "square.2.layers.3d")
                        .foregroundColor(project.enableDepthEffect ? Color.auraCyan : .white.opacity(0.4))
                    Text("Depth")
                        .font(.caption.weight(.bold))
                        .foregroundColor(project.enableDepthEffect ? .white : .white.opacity(0.5))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .glassCard(cornerRadius: 12)
            }
            
            // Dimming slider
            Menu {
                Button("No Dimming (100% Bright)") { project.overlayDimming = 0.0 }
                Button("Subtle Dim (15%)") { project.overlayDimming = 0.15 }
                Button("Medium Dim (30%)") { project.overlayDimming = 0.30 }
                Button("OLED Deep Dim (50%)") { project.overlayDimming = 0.50 }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "sun.min.fill")
                        .foregroundColor(Color.auraCyan)
                    Text("Dimming")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .glassCard(cornerRadius: 12)
            }
            
            // Clock Font
            Menu {
                ForEach(LockScreenPreviewView.ClockFontStyle.allCases) { font in
                    Button(font.rawValue) {
                        selectedClockFont = font
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "textformat")
                        .foregroundColor(Color.auraCyan)
                    Text(selectedClockFont.rawValue)
                        .font(.caption.weight(.bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .glassCard(cornerRadius: 12)
            }
        }
    }
    
    private var exportButton: some View {
        Button(action: {
            HapticManager.shared.medium()
            showingExportSheet = true
        }) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.down.circle.fill")
                Text("Export 4K Wallpaper")
                    .font(.headline.weight(.bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
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
    }
    
    private func initialLoad() {
        if let selectedId = project.selectedVariationId,
           let variation = project.variations.first(where: { $0.id == selectedId }) {
            loadVariation(variation)
        } else if let first = project.variations.first {
            loadVariation(first)
        }
    }
    
    private func loadVariation(_ variation: WallpaperVariation) {
        if let local = variation.localFilename, let img = storageManager.loadImage(named: local) {
            self.activeImage = img
            Task {
                self.subjectCutout = try? await LockScreenCompositor.shared.generateSubjectCutout(from: img)
            }
        }
    }
    
    private func regenerateMore() async {
        guard let sourceName = project.originalImageFilename,
              let srcImage = storageManager.loadImage(named: sourceName) else { return }
        
        guard let style = GenerationStyle.styles.first(where: { $0.id == project.selectedStyleId }) else { return }
        
        do {
            let newVars = try await WallpaperGenerationService.shared.generateVariations(
                sourceImage: srcImage,
                analysis: project.analysisResult,
                style: style,
                variationCount: 2
            )
            project.variations.append(contentsOf: newVars)
            if let last = newVars.last {
                project.selectedVariationId = last.id
                loadVariation(last)
            }
            storageManager.saveProject(project)
            HapticManager.shared.success()
        } catch {
            print("Regenerate failed: \(error)")
        }
    }
}
