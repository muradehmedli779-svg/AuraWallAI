import SwiftUI

@main
struct AuraWallApp: App {
    @StateObject private var storeKitManager = StoreKitManager()
    @StateObject private var storageManager = StorageManager.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    init() {
        configureAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    HomeGalleryView()
                } else {
                    OnboardingView(isCompleted: $hasCompletedOnboarding)
                }
            }
            .preferredColorScheme(.dark)
            .environmentObject(storeKitManager)
            .environmentObject(storageManager)
            .task {
                await storeKitManager.updateSubscriptionStatus()
            }
        }
    }
    
    private func configureAppearance() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 34, weight: .black)
        ]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
}
