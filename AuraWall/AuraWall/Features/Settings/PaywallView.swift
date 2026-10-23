import SwiftUI
import StoreKit

public struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var storeKitManager: StoreKitManager
    @State private var selectedPlan: SubscriptionPlanType = .yearly
    
    public var body: some View {
        ZStack {
            Color.auraDarkBg.ignoresSafeArea()
            
            // Atmosferik Işıma
            RadialGradient(
                colors: [Color.auraAccent.opacity(0.25), Color.clear],
                center: .top,
                startRadius: 20,
                endRadius: 360
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    dismissButton
                    heroHeader
                    featuresList
                    planSelector
                    subscribeCTA
                    footerLinks
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
        }
    }
    
    private var dismissButton: some View {
        HStack {
            Spacer()
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
    }
    
    private var heroHeader: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#FFD700")!.opacity(0.15))
                    .frame(width: 72, height: 72)
                Image(systemName: "crown.fill")
                    .font(.system(size: 36))
                    .foregroundColor(Color(hex: "#FFD700")!)
            }
            
            Text("AuraWall Pro'yu Aç")
                .font(.system(size: 28, weight: .black))
                .foregroundColor(.white)
            
            Text("Sınırsız ultra çözünürlüklü yapay zeka duvar kağıdı üretimi, konu derinlik ayrımı ve özel OLED estetik modeller.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
    }
    
    private var featuresList: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(SubscriptionPlanType.features) { feat in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: feat.icon)
                        .font(.system(size: 18))
                        .foregroundColor(Color.auraCyan)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(feat.title)
                            .font(.subheadline.weight(.bold))
                            .foregroundColor(.white)
                        Text(feat.subtitle)
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.65))
                    }
                }
            }
        }
        .padding(18)
        .glassCard(cornerRadius: 20)
    }
    
    private var planSelector: some View {
        VStack(spacing: 12) {
            ForEach(SubscriptionPlanType.allCases) { plan in
                let isSelected = selectedPlan == plan
                
                Button(action: {
                    HapticManager.shared.light()
                    selectedPlan = plan
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            HStack {
                                Text(plan.title)
                                    .font(.subheadline.weight(.bold))
                                    .foregroundColor(.white)
                                
                                if plan == .yearly {
                                    Text("%50 TASARRUF")
                                        .font(.system(size: 9, weight: .heavy))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.auraCyan)
                                        .cornerRadius(4)
                                }
                            }
                            
                            if let trial = plan.trialDescription {
                                Text(trial)
                                    .font(.caption2)
                                    .foregroundColor(Color.auraCyan)
                            }
                        }
                        
                        Spacer()
                        
                        Text(plan.priceDisplay)
                            .font(.subheadline.weight(.heavy))
                            .foregroundColor(.white)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.auraCardBg)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(isSelected ? Color.auraCyan : Color.white.opacity(0.1), lineWidth: isSelected ? 2 : 1)
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private var subscribeCTA: some View {
        Button(action: {
            HapticManager.shared.heavy()
            Task {
                if let product = storeKitManager.availableProducts.first(where: { $0.id == selectedPlan.id }) {
                    _ = try? await storeKitManager.purchase(product)
                } else {
                    storeKitManager.debugUnlockPro()
                }
                dismiss()
            }
        }) {
            Text("Ücretsiz Denemeyi Başlat ve Abone Ol")
                .font(.headline.weight(.bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [Color.auraCyan, Color.white],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(18)
                .shadow(color: Color.auraCyan.opacity(0.4), radius: 14)
        }
    }
    
    private var footerLinks: some View {
        HStack(spacing: 18) {
            Button("Satın Alımları Geri Yükle") {
                Task {
                    await storeKitManager.restorePurchases()
                }
            }
            Text("•")
            Button("Kullanım Şartları") {}
            Text("•")
            Button("Gizlilik Politikası") {}
        }
        .font(.caption2)
        .foregroundColor(.white.opacity(0.5))
        .padding(.top, 4)
    }
}
