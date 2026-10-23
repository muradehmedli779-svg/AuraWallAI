import UIKit
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

public final class LockScreenCompositor {
    public static let shared = LockScreenCompositor()
    private let ciContext = CIContext(options: [.useSoftwareRenderer: false])
    
    private init() {}
    
    /// Extracts a foreground subject mask using Apple Vision VNGenerateForegroundInstanceMaskRequest
    public func generateSubjectCutout(from image: UIImage) async throws -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        if #available(iOS 17.0, *) {
            let request = VNGenerateForegroundInstanceMaskRequest()
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try handler.perform([request])
            
            guard let result = request.results?.first else { return nil }
            let maskPixelBuffer = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
            
            let maskCI = CIImage(cvPixelBuffer: maskPixelBuffer)
            let inputCI = CIImage(cgImage: cgImage)
            
            let filter = CIFilter.blendWithMask()
            filter.inputImage = inputCI
            filter.backgroundImage = CIImage.empty()
            filter.maskImage = maskCI
            
            guard let outputCI = filter.outputImage,
                  let outputCG = ciContext.createCGImage(outputCI, from: outputCI.extent) else {
                return nil
            }
            return UIImage(cgImage: outputCG)
        } else {
            // Fallback for earlier versions
            return image
        }
    }
    
    /// Renders final ultra-high-resolution wallpaper with user editor modifications (scale, pan, blur, dimming)
    public func renderFinalExport(
        baseImage: UIImage,
        project: WallpaperProject,
        targetDevice: DeviceProfile = .currentDevice
    ) -> UIImage {
        let targetSize = CGSize(width: targetDevice.pixelWidth, height: targetDevice.pixelHeight)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { ctx in
            let cgCtx = ctx.cgContext
            
            // 1. Black canvas
            cgCtx.setFillColor(UIColor.black.cgColor)
            cgCtx.fill(CGRect(origin: .zero, size: targetSize))
            
            // 2. Base image with transform
            cgCtx.saveGState()
            
            let drawWidth = targetSize.width * project.scale
            let drawHeight = (targetSize.width / (baseImage.size.width / baseImage.size.height)) * project.scale
            let drawX = (targetSize.width - drawWidth) / 2.0 + project.offset.width
            let drawY = (targetSize.height - drawHeight) / 2.0 + project.offset.height
            
            var processedImage = baseImage
            
            // Optional blur filter
            if project.blurBackground > 0.5, let ciInput = CIImage(image: baseImage) {
                let blur = CIFilter.gaussianBlur()
                blur.inputImage = ciInput
                blur.radius = Float(project.blurBackground)
                if let output = blur.outputImage, let cg = ciContext.createCGImage(output, from: ciInput.extent) {
                    processedImage = UIImage(cgImage: cg)
                }
            }
            
            processedImage.draw(in: CGRect(x: drawX, y: drawY, width: drawWidth, height: drawHeight))
            cgCtx.restoreGState()
            
            // 3. User dimming overlay (for better lock screen clock legibility)
            if project.overlayDimming > 0.05 {
                cgCtx.setFillColor(UIColor.black.withAlphaComponent(CGFloat(project.overlayDimming)).cgColor)
                cgCtx.fill(CGRect(origin: .zero, size: targetSize))
            }
        }
    }
}
