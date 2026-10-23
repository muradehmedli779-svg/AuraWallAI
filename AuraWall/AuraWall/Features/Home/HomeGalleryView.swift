import SwiftUI

public struct HomeGalleryView: View {
    @EnvironmentObject var storageManager: StorageManager
    @EnvironmentObject var storeKitManager: StoreKitManager
    
    @State private var showingCreationFlow = false
    @State private var showingSettings = false
    @State private var showingPaywall = false
    @State private var selectedProjectForEditing: WallpaperProject?
    
    let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.auraDarkBg.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 26) {
                        headerSection
                        heroCreationCard
                        stylesInspirationSection
                        recentCreationsSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingCreationFlow) {
                PhotoImportView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
            .sheet(item: $selectedProjectForEditing) { project in
                WallpaperEditorView(project: project)
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("AuraWall AI")
                    .font(.system(size: 28, weight: .black))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Text("Yapay Zeka Kilit Ekranı Tasarımcısı")
                    .font(.caption.weight(.bold))
                    .tracking(1.0)
                    .foregroundColor(Color.auraCyan)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: {
                    HapticManager.shared.light()
                    showingSettings = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(width: 40, height: 40)
                        .glassCard(cornerRadius: 12)
                }
            }
        }
        .padding(.top, 16)
    }
    
    private var heroCreationCard: some View {
        Button(action: {
            HapticManager.shared.medium()
            showingCreationFlow = true
        }) {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.auraAccent.opacity(0.6), Color(hex: "#1E1236")!],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.auraCyan.opacity(0.5), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .frame(height: 180)
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.auraCyan)
                                .frame(width: 8, height: 8)
                            Text("YAPAY ZEKA MOTORU")
                                .font(.caption2.weight(.heavy))
                                .tracking(1.5)
                                .foregroundColor(Color.auraCyan)
                        }
                        
                        Text("Yeni Duvar Kağıdı\nOluştur")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Text("Gerçek AI • Saat Uyumlu • 4K Ultra")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(Color.auraCyan)
                            .frame(width: 52, height: 52)
                            .shadow(color: Color.auraCyan.opacity(0.5), radius: 14)
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                .padding(22)
            }
        }
        .buttonStyle(.plain)
    }
    
    private var stylesInspirationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Öne Çıkan Stiller")
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(GenerationStyle.styles) { style in
                        VStack(alignment: .leading, spacing: 8) {
                            ZStack(alignment: .topTrailing) {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: style.sampleGradientColors.compactMap { Color(hex: $0) },
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 130, height: 180)
                                    .overlay(
                                        VStack {
                                            Spacer()
                                            Image(systemName: style.iconSystemName)
                                                .font(.system(size: 28))
                                                .foregroundColor(.white.opacity(0.85))
                                            Spacer()
                                        }
                                    )
                            }
                            
                            Text(style.name)
                                .font(.caption.weight(.bold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                            
                            Text(style.category)
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .frame(width: 130)
                    }
                }
            }
        }
    }
    
    private var recentCreationsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Kütüphanen")
                    .font(.headline.weight(.bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(storageManager.savedProjects.count) Duvar Kağıdı")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            if storageManager.savedProjects.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.3))
                        .padding(.top, 20)
                    Text("Henüz duvar kağıdı oluşturulmadı")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white.opacity(0.6))
                    Text("Bir fotoğraf yükleyerek yapay zeka ile kilit ekranı tasarlamaya başlayın.")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.4))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity)
                .glassCard(cornerRadius: 18)
            } else {
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(storageManager.savedProjects) { project in
                        projectThumbnailCard(project)
                    }
                }
            }
        }
    }
    
    private func projectThumbnailCard(_ project: WallpaperProject) -> some View {
        Button(action: {
            HapticManager.shared.light()
            selectedProjectForEditing = project
        }) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.auraCardBg)
                        .frame(height: 220)
                    
                    if let filename = project.variations.first?.localFilename,
                       let uiImage = storageManager.loadImage(named: filename) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 220)
                            .clipped()
                            .cornerRadius(18)
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 30))
                                .foregroundColor(Color.auraCyan)
                            Text(project.selectedStyleId.capitalized)
                                .font(.caption.weight(.bold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
                
                Text(project.title)
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(project.updatedAt.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .buttonStyle(.plain)
    }
}
