import XCTest
@testable import AuraWall

final class AuraWallTests: XCTestCase {
    
    func testDeviceProfileResolutionCalculations() {
        let profile = DeviceProfile.iPhone16ProMax
        XCTAssertEqual(profile.pixelWidth, 1320)
        XCTAssertEqual(profile.pixelHeight, 2868)
        XCTAssertTrue(profile.aspectRatio > 0.45 && profile.aspectRatio < 0.50)
        XCTAssertTrue(profile.supportsDepthEffect)
    }
    
    func testClockSafeRegionAssessmentLogic() {
        // Test non-occluding subject box (placed in lower half)
        let safeBox = CGRect(x: 0.2, y: 0.5, width: 0.6, height: 0.4)
        let clockArea = DeviceProfile.iPhone16Pro.clockSafeArea
        let intersection = safeBox.intersection(clockArea)
        
        XCTAssertTrue(intersection.isNull || intersection.width * intersection.height < 0.02)
    }
    
    func testGenerationStylesCompleteness() {
        let styles = GenerationStyle.styles
        XCTAssertGreaterThanOrEqual(styles.count, 6)
        
        for style in styles {
            XCTAssertFalse(style.name.isEmpty)
            XCTAssertFalse(style.promptSuffix.isEmpty)
            XCTAssertFalse(style.sampleGradientColors.isEmpty)
            XCTAssertTrue(style.sampleGradientColors.first?.hasPrefix("#") == true)
        }
    }
    
    func testWallpaperProjectInitialization() {
        let project = WallpaperProject(
            title: "Neon Horizon",
            selectedStyleId: "cyber-neon"
        )
        XCTAssertEqual(project.title, "Neon Horizon")
        XCTAssertEqual(project.selectedStyleId, "cyber-neon")
        XCTAssertTrue(project.enableDepthEffect)
        XCTAssertEqual(project.scale, 1.0)
    }
}
