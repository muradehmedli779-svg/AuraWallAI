import SwiftUI
import Photos

public struct ExportView: View {
    let project: WallpaperProject
    let baseImage: UIImage
    
    @Environment(\.dismiss) private var dismiss
    @State private var exportedImage: UIImage?
    @State private var isSaving = false
    @State private var saveSuccess = false
    @State private var saveErrorMessage: String?
    @State private var showingGuide = false
    @State private var showingShareSheet = false
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.auraDarkBg.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    if let rendered = exportedImage {
                        Image(uiImage: rendered)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 420)
                            .cornerRadius(24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1.5)
                            )
                            .shadow(color: Color.black.opacity(0.5), radius: 20)
                        
                        // Çözünürlük bilgileri
                        HStack(spacing: 20) {
                            specPill(icon: "sparkles", text: "4K Ultra Çözünürlük")
                            specPill(icon: "aspectratio", text: "\(Int(rendered.size.width)) × \(Int(rendered.size.height))")
                            specPill(icon: "checkmark.shield.fill", text: "Kayıpsız PNG")
                        }
                    } else {
                        ProgressView("4K Tuval Hazırlanıyor...")
                            .frame(height: 420)
                    }
                    
                    Spacer()
                    
                    actionButtons
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
            .navigationTitle("Duvar Kağıdını Dışa Aktar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $showingGuide) {
                WallpaperSetupGuideView()
            }
            .sheet(isPresented: $showingShareSheet) {
                if let rendered = exportedImage {
                    ShareSheet(activityItems: [rendered])
                }
            }
            .task {
                renderOutput()
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: {
                saveToPhotoLibrary()
            }) {
                HStack(spacing: 8) {
                    if isSaving {
                        ProgressView().tint(.white)
                    } else {
                        Image(systemName: saveSuccess ? "checkmark.circle.fill" : "square.and.arrow.down.fill")
                        Text(saveSuccess ? "Fotoğraflara Kaydedildi!" : "Fotoğraf Kütüphanesine Kaydet")
                    }
                }
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    saveSuccess ?
                    LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing) :
                    LinearGradient(colors: [Color.auraAccent, Color.auraCyan], startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(18)
                .shadow(color: Color.auraAccent.opacity(0.35), radius: 12)
            }
            .disabled(isSaving || saveSuccess)
            
            HStack(spacing: 12) {
                Button(action: {
                    showingShareSheet = true
                }) {
                    Label("AirDrop / Paylaş", systemImage: "square.and.arrow.up")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .glassCard(cornerRadius: 14)
                }
                
                Button(action: {
                    showingGuide = true
                }) {
                    Label("iOS Kurulum Kılavuzu", systemImage: "questionmark.circle")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(Color.auraCyan)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .glassCard(cornerRadius: 14)
                }
            }
            
            if let error = saveErrorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
    
    private func specPill(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundColor(Color.auraCyan)
            Text(text)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.06))
        .cornerRadius(12)
    }
    
    private func renderOutput() {
        let final = LockScreenCompositor.shared.renderFinalExport(baseImage: baseImage, project: project)
        self.exportedImage = final
    }
    
    private func saveToPhotoLibrary() {
        guard let rendered = exportedImage else { return }
        isSaving = true
        saveErrorMessage = nil
        
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    UIImageWriteToSavedPhotosAlbum(rendered, nil, nil, nil)
                    isSaving = false
                    saveSuccess = true
                    HapticManager.shared.success()
                case .denied, .restricted:
                    isSaving = false
                    saveErrorMessage = "Fotoğraf Kütüphanesi erişimi reddedildi. Ayarlar → AuraWall'dan etkinleştirin."
                    HapticManager.shared.error()
                case .notDetermined:
                    isSaving = false
                @unknown default:
                    isSaving = false
                }
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
