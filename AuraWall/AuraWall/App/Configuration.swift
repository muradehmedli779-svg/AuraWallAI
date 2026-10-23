import Foundation
import SwiftUI

/// App-wide environment configuration and backend connectivity
public enum Configuration {
    public static let appName = "AuraWall AI"
    public static let appVersion = "1.0.0"
    public static let buildNumber = "1"
    public static let bundleIdentifier = "com.aurawall.app"
    
    // Cloud API URL (defaults to zero-maintenance cloud backend or on-device)
    public static var backendBaseURL: URL {
        if let custom = UserDefaults.standard.string(forKey: "custom_backend_url"),
           let url = URL(string: custom), !custom.isEmpty {
            return url
        }
        // Free cloud backend default
        return URL(string: "https://aurawall-api.onrender.com/api/v1")!
    }
    
    // Direct API Keys (stored safely in UserDefaults so no server is needed at all!)
    public static var openAIKey: String {
        get { UserDefaults.standard.string(forKey: "user_openai_api_key") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "user_openai_api_key") }
    }
    
    public static var replicateToken: String {
        get { UserDefaults.standard.string(forKey: "user_replicate_token") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "user_replicate_token") }
    }
    
    public static let defaultTimeoutSeconds: TimeInterval = 60.0
    
    public enum StoreKit {
        public static let proMonthlyID = "com.aurawall.app.pro.monthly"
        public static let proYearlyID = "com.aurawall.app.pro.yearly"
        public static let proLifetimeID = "com.aurawall.app.pro.lifetime"
    }
}
