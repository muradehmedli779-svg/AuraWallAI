import Foundation
import UIKit

public enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case serverError(statusCode: Int, message: String)
    case decodingError(Error)
    case unprocessableData
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The API URL is invalid."
        case .networkError(let error):
            return "Network connection error: \(error.localizedDescription)"
        case .serverError(let code, let message):
            return "Server responded with status \(code): \(message)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .unprocessableData:
            return "Failed to process image payload."
        }
    }
}

public actor APIClient {
    public static let shared = APIClient()
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = Configuration.defaultTimeoutSeconds
        config.timeoutIntervalForResource = 120.0
        self.session = URLSession(configuration: config)
    }
    
    /// Health check to verify if backend server is responsive
    public func isBackendReachable() async -> Bool {
        guard let url = URL(string: Configuration.backendBaseURL.absoluteString + "/health") else { return false }
        do {
            var request = URLRequest(url: url)
            request.timeoutInterval = 3.0
            let (_, response) = try await session.data(for: request)
            if let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) {
                return true
            }
            return false
        } catch {
            return false
        }
    }
    
    /// Sends image to backend for multi-modal Vision analysis
    public func analyzeImage(imageData: Data) async throws -> AnalyzeImageResponse {
        let endpointURL = Configuration.backendBaseURL.appendingPathComponent(NetworkEndpoint.analyzeImage.path)
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"upload.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw APIError.unprocessableData
        }
        
        guard (200...299).contains(http.statusCode) else {
            let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw APIError.serverError(statusCode: http.statusCode, message: errorMsg)
        }
        
        do {
            return try JSONDecoder().decode(AnalyzeImageResponse.self, data: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    /// Requests wallpaper generation variations from backend
    public func generateWallpapers(request: GenerateWallpaperRequest) async throws -> GenerateWallpaperResponse {
        let endpointURL = Configuration.backendBaseURL.appendingPathComponent(NetworkEndpoint.generateWallpaper.path)
        
        var urlRequest = URLRequest(url: endpointURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await session.data(for: urlRequest)
        guard let http = response as? HTTPURLResponse else {
            throw APIError.unprocessableData
        }
        
        guard (200...299).contains(http.statusCode) else {
            let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown server error"
            throw APIError.serverError(statusCode: http.statusCode, message: errorMsg)
        }
        
        do {
            return try JSONDecoder().decode(GenerateWallpaperResponse.self, data: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
