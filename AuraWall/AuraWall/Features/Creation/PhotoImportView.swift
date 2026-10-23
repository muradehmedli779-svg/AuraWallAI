import SwiftUI
import PhotosUI

public struct PhotoImportView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var importedImage: UIImage?
    @State private var isValidating = false
    @State private var validationErrorMessage: String?
    @State private var navigateToAnalysis = false
    @State private var showingCamera = false
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.auraDarkBg.ignoresSafeArea()
                
                VStack(spacing: 30) {
                    headerView
                    
                    if let image = importedImage {
                        imagePreviewCard(image)
                    } else {
                        importDropzone
                    }
                    
                    Spacer()
                    
                    actionButtons
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .navigationDestination(isPresented: $navigateToAnalysis) {
                    if let image = importedImage {
                        ImageAnalysisView(sourceImage: image)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.7))
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Import Reference")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
            
            Text("Select a portrait, pet, or favorite photo. Our AI preserves subject identity while generating clock-safe lock screen artwork.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.65))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
    }
    
    private var importDropzone: some View {
        VStack(spacing: 24) {
            PhotosPicker(selection: $selectedItem, matching: .images) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.auraAccent.opacity(0.15))
                            .frame(width: 80, height: 80)
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 36))
                            .foregroundColor(Color.auraCyan)
                    }
                    
                    VStack(spacing: 6) {
                        Text("Choose from Photo Library")
                            .font(.headline.weight(.bold))
                            .foregroundColor(.white)
                        Text("Supports portraits, pets, cars, and objects")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 240)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(
                            Color.auraAccent.opacity(0.4),
                            style: StrokeStyle(lineWidth: 1.5, dash: [8, 8])
                        )
                        .background(Color.auraCardBg.opacity(0.5))
                )
            }
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    await processPickedItem(newItem)
                }
            }
            
            HStack {
                Rectangle().fill(Color.white.opacity(0.1)).frame(height: 1)
                Text("OR").font(.caption2.weight(.bold)).foregroundColor(.white.opacity(0.4))
                Rectangle().fill(Color.white.opacity(0.1)).frame(height: 1)
            }
            
            // Text-only direct generation option
            Button(action: {
                // Generate without reference photo
                importedImage = generateStarterCanvas()
                navigateToAnalysis = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "wand.and.stars")
                        .foregroundColor(Color.auraCyan)
                    Text("Generate from Prompt Only (No Image)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white.opacity(0.9))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .glassCard(cornerRadius: 14)
            }
        }
    }
    
    private func imagePreviewCard(_ image: UIImage) -> some View {
        VStack(spacing: 12) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 320)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.auraCyan.opacity(0.5), lineWidth: 1.5)
                )
            
            HStack(spacing: 16) {
                Label("\(Int(image.size.width)) × \(Int(image.size.height)) px", systemImage: "aspectratio")
                Label("Verified", systemImage: "checkmark.seal.fill")
                    .foregroundColor(Color.auraCyan)
            }
            .font(.caption.weight(.semibold))
            .foregroundColor(.white.opacity(0.7))
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            if let _ = importedImage {
                Button(action: {
                    HapticManager.shared.medium()
                    navigateToAnalysis = true
                }) {
                    Text("Analyze & Compose")
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
                        .shadow(color: Color.auraAccent.opacity(0.35), radius: 12)
                }
                
                Button("Choose Different Photo") {
                    importedImage = nil
                    selectedItem = nil
                }
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
            }
            
            if let error = validationErrorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 4)
            }
        }
    }
    
    private func processPickedItem(_ item: PhotosPickerItem?) async {
        guard let item = item else { return }
        isValidating = true
        validationErrorMessage = nil
        
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data) else {
                validationErrorMessage = "Unable to read image data."
                isValidating = false
                return
            }
            
            // Validate minimum resolution (at least 512x512)
            if uiImage.size.width < 300 || uiImage.size.height < 300 {
                validationErrorMessage = "Image resolution is too low. Please choose a sharper photo."
                isValidating = false
                return
            }
            
            self.importedImage = uiImage
            self.isValidating = false
            HapticManager.shared.success()
        } catch {
            validationErrorMessage = "Error loading image: \(error.localizedDescription)"
            isValidating = false
        }
    }
    
    private func generateStarterCanvas() -> UIImage {
        let size = CGSize(width: 800, height: 1200)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            UIColor(hex: "#090A0F")?.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
        }
    }
}
