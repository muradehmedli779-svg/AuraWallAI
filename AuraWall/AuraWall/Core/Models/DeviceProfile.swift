import SwiftUI

/// Profile describing target iPhone models, lock screen aspect ratios, and safe clock regions
public struct DeviceProfile: Identifiable, Hashable, Codable {
    public let id: String
    public let name: String
    public let series: String
    public let screenWidth: CGFloat
    public let screenHeight: CGFloat
    public let scale: CGFloat
    public let clockSafeArea: CGRect // Normalized 0..1 bounding box where iOS lock screen clock sits
    public let supportsDepthEffect: Bool
    
    public var pixelWidth: Int { Int(screenWidth * scale) }
    public var pixelHeight: Int { Int(screenHeight * scale) }
    public var aspectRatio: CGFloat { screenWidth / screenHeight }
    
    // MARK: - iPhone 18 Serisi
    public static let iPhone18ProMax = DeviceProfile(
        id: "iphone-18-pro-max",
        name: "iPhone 18 Pro Max",
        series: "iPhone 18 Serisi",
        screenWidth: 440,
        screenHeight: 956,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.12, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone18Pro = DeviceProfile(
        id: "iphone-18-pro",
        name: "iPhone 18 Pro",
        series: "iPhone 18 Serisi",
        screenWidth: 402,
        screenHeight: 874,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.13, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone18Plus = DeviceProfile(
        id: "iphone-18-plus",
        name: "iPhone 18 Plus",
        series: "iPhone 18 Serisi",
        screenWidth: 430,
        screenHeight: 932,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.13, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone18 = DeviceProfile(
        id: "iphone-18",
        name: "iPhone 18",
        series: "iPhone 18 Serisi",
        screenWidth: 393,
        screenHeight: 852,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.13, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    // MARK: - iPhone 17 Serisi
    public static let iPhone17ProMax = DeviceProfile(
        id: "iphone-17-pro-max",
        name: "iPhone 17 Pro Max",
        series: "iPhone 17 Serisi",
        screenWidth: 440,
        screenHeight: 956,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.12, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone17Pro = DeviceProfile(
        id: "iphone-17-pro",
        name: "iPhone 17 Pro",
        series: "iPhone 17 Serisi",
        screenWidth: 402,
        screenHeight: 874,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.13, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone17 = DeviceProfile(
        id: "iphone-17",
        name: "iPhone 17",
        series: "iPhone 17 Serisi",
        screenWidth: 393,
        screenHeight: 852,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.13, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    // MARK: - iPhone 16 Serisi
    public static let iPhone16ProMax = DeviceProfile(
        id: "iphone-16-pro-max",
        name: "iPhone 16 Pro Max",
        series: "iPhone 16 Serisi",
        screenWidth: 440,
        screenHeight: 956,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.12, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone16Pro = DeviceProfile(
        id: "iphone-16-pro",
        name: "iPhone 16 Pro",
        series: "iPhone 16 Serisi",
        screenWidth: 402,
        screenHeight: 874,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.13, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone16Plus = DeviceProfile(
        id: "iphone-16-plus",
        name: "iPhone 16 Plus",
        series: "iPhone 16 Serisi",
        screenWidth: 430,
        screenHeight: 932,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.13, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone16 = DeviceProfile(
        id: "iphone-16",
        name: "iPhone 16",
        series: "iPhone 16 Serisi",
        screenWidth: 393,
        screenHeight: 852,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.13, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    // MARK: - iPhone 15 Serisi
    public static let iPhone15ProMax = DeviceProfile(
        id: "iphone-15-pro-max",
        name: "iPhone 15 Pro Max",
        series: "iPhone 15 Serisi",
        screenWidth: 430,
        screenHeight: 932,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.13, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone15Pro = DeviceProfile(
        id: "iphone-15-pro",
        name: "iPhone 15 Pro",
        series: "iPhone 15 Serisi",
        screenWidth: 393,
        screenHeight: 852,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.13, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone15Plus = DeviceProfile(
        id: "iphone-15-plus",
        name: "iPhone 15 Plus",
        series: "iPhone 15 Serisi",
        screenWidth: 430,
        screenHeight: 932,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.13, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone15 = DeviceProfile(
        id: "iphone-15",
        name: "iPhone 15",
        series: "iPhone 15 Serisi",
        screenWidth: 393,
        screenHeight: 852,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.13, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    // MARK: - iPhone 14 Serisi
    public static let iPhone14ProMax = DeviceProfile(
        id: "iphone-14-pro-max",
        name: "iPhone 14 Pro Max",
        series: "iPhone 14 Serisi",
        screenWidth: 430,
        screenHeight: 932,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.13, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone14Pro = DeviceProfile(
        id: "iphone-14-pro",
        name: "iPhone 14 Pro",
        series: "iPhone 14 Serisi",
        screenWidth: 393,
        screenHeight: 852,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.13, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone14Plus = DeviceProfile(
        id: "iphone-14-plus",
        name: "iPhone 14 Plus",
        series: "iPhone 14 Serisi",
        screenWidth: 428,
        screenHeight: 926,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.14, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone14 = DeviceProfile(
        id: "iphone-14",
        name: "iPhone 14",
        series: "iPhone 14 Serisi",
        screenWidth: 390,
        screenHeight: 844,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.14, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    // MARK: - iPhone 13 Serisi
    public static let iPhone13ProMax = DeviceProfile(
        id: "iphone-13-pro-max",
        name: "iPhone 13 Pro Max",
        series: "iPhone 13 Serisi",
        screenWidth: 428,
        screenHeight: 926,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.14, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone13Pro = DeviceProfile(
        id: "iphone-13-pro",
        name: "iPhone 13 Pro",
        series: "iPhone 13 Serisi",
        screenWidth: 390,
        screenHeight: 844,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.14, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone13 = DeviceProfile(
        id: "iphone-13",
        name: "iPhone 13",
        series: "iPhone 13 Serisi",
        screenWidth: 390,
        screenHeight: 844,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.14, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone13Mini = DeviceProfile(
        id: "iphone-13-mini",
        name: "iPhone 13 mini",
        series: "iPhone 13 Serisi",
        screenWidth: 375,
        screenHeight: 812,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.14, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    // MARK: - iPhone 12 Serisi
    public static let iPhone12ProMax = DeviceProfile(
        id: "iphone-12-pro-max",
        name: "iPhone 12 Pro Max",
        series: "iPhone 12 Serisi",
        screenWidth: 428,
        screenHeight: 926,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.14, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone12Pro = DeviceProfile(
        id: "iphone-12-pro",
        name: "iPhone 12 Pro",
        series: "iPhone 12 Serisi",
        screenWidth: 390,
        screenHeight: 844,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.14, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone12 = DeviceProfile(
        id: "iphone-12",
        name: "iPhone 12",
        series: "iPhone 12 Serisi",
        screenWidth: 390,
        screenHeight: 844,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.14, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone12Mini = DeviceProfile(
        id: "iphone-12-mini",
        name: "iPhone 12 mini",
        series: "iPhone 12 Serisi",
        screenWidth: 375,
        screenHeight: 812,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.14, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    // MARK: - iPhone 11 Serisi
    public static let iPhone11ProMax = DeviceProfile(
        id: "iphone-11-pro-max",
        name: "iPhone 11 Pro Max",
        series: "iPhone 11 Serisi",
        screenWidth: 414,
        screenHeight: 896,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.14, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone11Pro = DeviceProfile(
        id: "iphone-11-pro",
        name: "iPhone 11 Pro",
        series: "iPhone 11 Serisi",
        screenWidth: 375,
        screenHeight: 812,
        scale: 3.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.14, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let iPhone11 = DeviceProfile(
        id: "iphone-11",
        name: "iPhone 11",
        series: "iPhone 11 Serisi",
        screenWidth: 414,
        screenHeight: 896,
        scale: 2.0,
        clockSafeArea: CGRect(x: 0.1, y: 0.14, width: 0.8, height: 0.18),
        supportsDepthEffect: true
    )
    
    public static let allDevices: [DeviceProfile] = [
        // 18
        .iPhone18ProMax, .iPhone18Pro, .iPhone18Plus, .iPhone18,
        // 17
        .iPhone17ProMax, .iPhone17Pro, .iPhone17,
        // 16
        .iPhone16ProMax, .iPhone16Pro, .iPhone16Plus, .iPhone16,
        // 15
        .iPhone15ProMax, .iPhone15Pro, .iPhone15Plus, .iPhone15,
        // 14
        .iPhone14ProMax, .iPhone14Pro, .iPhone14Plus, .iPhone14,
        // 13
        .iPhone13ProMax, .iPhone13Pro, .iPhone13, .iPhone13Mini,
        // 12
        .iPhone12ProMax, .iPhone12Pro, .iPhone12, .iPhone12Mini,
        // 11
        .iPhone11ProMax, .iPhone11Pro, .iPhone11
    ]
    
    public static var currentDevice: DeviceProfile {
        let bounds = UIScreen.main.bounds
        for device in allDevices {
            if abs(device.screenWidth - bounds.width) < 2 && abs(device.screenHeight - bounds.height) < 2 {
                return device
            }
        }
        return .iPhone15Pro
    }
}
