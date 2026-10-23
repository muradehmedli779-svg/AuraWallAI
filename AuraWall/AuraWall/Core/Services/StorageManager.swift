import UIKit

@MainActor
public final class StorageManager: ObservableObject {
    public static let shared = StorageManager()
    
    @Published public private(set) var savedProjects: [WallpaperProject] = []
    
    private let fileManager = FileManager.default
    private let projectsKey = "aurawall_saved_projects_v1"
    
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private init() {
        loadProjects()
    }
    
    public func loadProjects() {
        guard let data = UserDefaults.standard.data(forKey: projectsKey) else {
            // Seed a sample welcome project if empty
            if savedProjects.isEmpty {
                let welcomeProject = WallpaperProject(
                    title: "Neon Cyberpunk Horizon",
                    selectedStyleId: "cyber-neon"
                )
                self.savedProjects = [welcomeProject]
            }
            return
        }
        
        do {
            self.savedProjects = try JSONDecoder().decode([WallpaperProject].self, from: data)
        } catch {
            print("Failed to decode saved projects: \(error)")
        }
    }
    
    public func saveProject(_ project: WallpaperProject) {
        if let index = savedProjects.firstIndex(where: { $0.id == project.id }) {
            savedProjects[index] = project
        } else {
            savedProjects.insert(project, at: 0)
        }
        persist()
    }
    
    public func deleteProject(_ project: WallpaperProject) {
        savedProjects.removeAll { $0.id == project.id }
        persist()
    }
    
    private func persist() {
        do {
            let data = try JSONEncoder().encode(savedProjects)
            UserDefaults.standard.set(data, forKey: projectsKey)
        } catch {
            print("Failed to persist projects: \(error)")
        }
    }
    
    public func saveImage(_ image: UIImage, prefix: String = "aura") throws -> String {
        let filename = "\(prefix)_\(UUID().uuidString).png"
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        guard let data = image.pngData() else {
            throw APIError.unprocessableData
        }
        
        try data.write(to: fileURL)
        return filename
    }
    
    public func loadImage(named filename: String) -> UIImage? {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        return UIImage(contentsOfFile: fileURL.path)
    }
}
