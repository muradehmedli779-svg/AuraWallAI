import SwiftUI

/// Profile describing target iPhone models, lock screen aspect ratios, and safe clock regions
public struct DeviceProfile: Identifiable, Hashable, Codable {
    public let id: String
    public let name: String
    public let screenWidth: CGFloat
    public let screenHeight: CGFloat
    public let scale: CGFloat
    public let clockSafeArea: CGRect // Normalized 0..1 bounding box where iOS lock screen clock sits
    public let supportsDepthEffect: Bool
    
    public var pixelWidth: Int { Int(screenWidth * scale) }
    public var pixelHeight: Int { Int(screenHeight * scale) }
    public var aspectRatio: CGFloat { screenWidth / screenHeight }
    
    public static let iPhone16ProMax = DeviceProfile(
        id: "iphone-16-pro-max",
        name: "iPhone 16 Pro Max",
        screenWidth: 440,
        screenHeight: 956,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.12, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone16Pro = DeviceProfile(
        id: "iphone-16-pro",
        name: "iPhone 16 Pro",
        screenWidth: 402,
        screenHeight: 874,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.13, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone15ProMax = DeviceProfile(
        id: "iphone-15-pro-max",
        name: "iPhone 15 Pro Max",
        screenWidth: 430,
        screenHeight: 932,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.13, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone15 = DeviceProfile(
        id: "iphone-15",
        name: "iPhone 15 / 15 Pro",
        screenWidth: 393,
        screenHeight: 852,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.13, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let allDevices: [DeviceProfile] = [
        .iPhone16ProMax,
        .iPhone16Pro,
        .iPhone15ProMax,
        .iPhone15
    ]
    
    public static var currentDevice: DeviceProfile {
        let bounds = UIScreen.main.bounds
        for device in allDevices {
            if abs(device.screenWidth - bounds.width) < 5 && abs(device.screenHeight - bounds.height) < 5 {
                return device
            }
        }
        return .iPhone16Pro
    }
}
