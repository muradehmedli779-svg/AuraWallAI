import SwiftUI

public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var storeKitManager: StoreKitManager
    @EnvironmentObject var storageManager: StorageManager
    
    @State private var showingPaywall = false
    @State private var openAIKey: String = Configuration.openAIKey
    @State private var replicateToken: String = Configuration.replicateToken
    @State private var customBackendUrl: String = Configuration.backendBaseURL.absoluteString
    @State private var useOnDeviceOnly: Bool = UserDefaults.standard.bool(forKey: "use_on_device_only")
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.auraDarkBg.ignoresSafeArea()
                
                List {
                    // Subscription Section
                    Section {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(storeKitManager.isProUser ? "AuraWall Pro Aktif" : "Ücretsiz Sürüm")
                                    .font(.headline.weight(.bold))
                                    .foregroundColor(.white)
                                Text(storeKitManager.isProUser ? "Sınırsız 4K ve Derinlik Matting" : "Tüm stilleri açmak için yükseltin")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            Spacer()
                            if !storeKitManager.isProUser {
                                Button("Yükselt") {
                                    showingPaywall = true
                                }
                                .font(.caption.weight(.bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.auraCyan)
                                .cornerRadius(10)
                            }
                        }
                        .listRowBackground(Color.auraCardBg)
                    } header: {
                        Text("Üyelik")
                    }
                    
                    // Zero-Server AI Engine
                    Section {
                        Toggle(isOn: $useOnDeviceOnly) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Cihaz İçi Çevrimdışı Mod")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.white)
                                Text("Sunucu veya internet olmadan iPhone içinde üret")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                        .onChange(of: useOnDeviceOnly) { _, val in
                            UserDefaults.standard.set(val, forKey: "use_on_device_only")
                        }
                        .listRowBackground(Color.auraCardBg)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("OpenAI API Anahtarı (İsteğe Bağlı)")
                                .font(.caption.weight(.bold))
                                .foregroundColor(.white.opacity(0.8))
                            SecureField("sk-...", text: $openAIKey)
                                .textFieldStyle(.plain)
                                .padding(10)
                                .background(Color.white.opacity(0.06))
                                .cornerRadius(8)
                                .onChange(of: openAIKey) { _, val in
                                    Configuration.openAIKey = val
                                }
                            Text("Anahtar girerseniz doğrudan telefonunuzdan DALL-E 3 üretir, bilgisayarda sunucu açmanız gerekmez.")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .listRowBackground(Color.auraCardBg)
                    } header: {
                        Text("Yapay Zeka Motoru (Sunucusuz)")
                    }
                    
                    // Storage & Cache
                    Section {
                        HStack {
                            Text("Kaydedilen Duvar Kağıtları")
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(storageManager.savedProjects.count)")
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .listRowBackground(Color.auraCardBg)
                    } header: {
                        Text("Depolama")
                    }
                    
                    // About
                    Section {
                        HStack {
                            Text("Sürüm")
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(Configuration.appVersion) (\(Configuration.buildNumber))")
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .listRowBackground(Color.auraCardBg)
                    } header: {
                        Text("Hakkında")
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Ayarlar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
        }
    }
}
