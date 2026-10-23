import SwiftUI

public struct WallpaperSetupGuideView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let steps = [
        GuideStep(
            number: "1",
            title: "Kilit Ekranına Uzun Bas",
            description: "iPhone'unu uyandır ve mevcut kilit ekranına, duvar kağıdı galeri seçici görünene kadar uzun bas.",
            icon: "hand.tap.fill"
        ),
        GuideStep(
            number: "2",
            title: "Mavi Artı (+) Butonuna Dokun",
            description: "Yeni duvar kağıdı oluşturmak için sağ alt köşedeki '+' butonuna dokun.",
            icon: "plus.circle.fill"
        ),
        GuideStep(
            number: "3",
            title: "'Fotoğraflar'ı Seç ve AuraWall'u Bul",
            description: "Üstteki 'Fotoğraflar' butonuna dokun ve AuraWall'dan az önce dışa aktardığın 4K duvar kağıdını seç.",
            icon: "photo.on.rectangle"
        ),
        GuideStep(
            number: "4",
            title: "Derinlik Efekti Otomatik Etkinleşir",
            description: "AuraWall kompozisyonu ve güvenli bölgeleri özel olarak tasarladığından, iOS konuyu otomatik algılar ve saati arka plana gönderir.",
            icon: "square.2.layers.3d.top.filled"
        ),
        GuideStep(
            number: "5",
            title: "Duvar Kağıdı Çifti Olarak Ayarla",
            description: "Sağ üst köşedeki 'Ekle' butonuna dokun, ardından 'Duvar Kağıdı Çifti Olarak Ayarla'yı seç veya Ana Ekran bulanıklığını özelleştir.",
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
            .navigationTitle("iOS Kurulum Talimatları")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Yapay Zeka Duvar Kağıdını Ayarla")
                .font(.title3.weight(.bold))
                .foregroundColor(.white)
            Text("Yerleşik Derinlik Efektini etkinleştirmek için Apple'ın resmi iOS adımlarını izle.")
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
                Text("Derinlik Efekti İpucu")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white)
            }
            
            Text("iOS önizleme ekranında Derinlik Efekti devre dışı kalırsa, Apple'ın duvar kağıdı düzenleyicisinin sağ alt köşesindeki üç noktaya (...) dokun ve 'Derinlik Efekti'nin işaretli olduğundan emin ol. AuraWall, iOS uyumluluğunu garantilemek için konu örtüşmesini %25'in altında tutar.")
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
