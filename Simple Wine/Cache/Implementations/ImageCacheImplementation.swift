import Foundation
import UIKit

final class ImageCacheImplementation: ImageCache {
    
    private struct Constants {
        static let cachedImagesDirectory = "CachedImages"
        static let cacheResetTimeout: TimeInterval = 24 * 3600 * 30 // 30 days
    }
    
    private let fileManagerProtocol: FileManager
    private let inMemoryCache: NSCache<NSString, UIImage>!
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManagerProtocol = fileManager
        self.inMemoryCache = NSCache<NSString, UIImage>()
        self.inMemoryCache.totalCostLimit = 100 * 1024 * 1024 // 100 Mb cache size
    }
    
    func save(image: UIImage, name: String, id: String) {
        do {
            try self.ensureCachesDirectoryExistence()
            guard let cacheDirectoryForID = self.cacheDirectory(for: id) else { return }
            var cachedImageAlreadyExists: Bool = false
            if !FileManager.default.fileExists(atPath: cacheDirectoryForID.absoluteString) {
                guard let fileURL = cacheDirectoryForID.fileURL else { return }
                try FileManager.default.createDirectory(at: fileURL, withIntermediateDirectories: false, attributes: nil)
            } else {
                if let files = try? FileManager.default.contentsOfDirectory(at: cacheDirectoryForID, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles) {
                    for filename in files {
                        if self.validateFileName(for: name) != filename.lastPathComponent {
                            try FileManager.default.removeItem(at: filename)
                        }
                    }
                    cachedImageAlreadyExists = (files.count > 0)
                    if cachedImageAlreadyExists {
                        let cachedImageData: NSData = try NSData(contentsOf: files.first!)
                        let newImageData = image.pngData()
                        if let newData = newImageData, cachedImageData.isEqual(to: newData) {
                            cachedImageAlreadyExists = true
                        } else {
                            cachedImageAlreadyExists = false
                            try FileManager.default.removeItem(at: files.first!)
                        }
                    }
                }
            }
            if !cachedImageAlreadyExists {
                if let imagePath = self.imagePath(id: id, name: self.validateFileName(for: name)), let data = image.pngData() {
                    try data.write(to: URL(fileURLWithPath: imagePath.absoluteString))
                }
            }
            self.inMemoryCache.setObject(image, forKey: NSString(string: name))
        } catch let error {
            SWLog(error: error)
        }
    }
    
    func image(for name: String, id: String) -> UIImage? {
        let image: UIImage? = self.inMemoryCache.object(forKey: NSString(string: name))
        if let image = image {
            return image
        } else {
            if let imagePath = self.imagePath(id: id, name: self.validateFileName(for: name)) {
                if let image = UIImage(contentsOfFile: imagePath.path) {
                    self.inMemoryCache.setObject(image, forKey: NSString(string: name))
                    return image
                }
            }
            
            return nil
        }
    }
    
    private func ensureCachesDirectoryExistence() throws {
        guard let directory = self.cachedImagesDirectory, let directoryURL = directory.fileURL else { return }
        let attributes = try? FileManager.default.attributesOfItem(atPath: directory.absoluteString)
        if let creationDate = attributes?[FileAttributeKey.creationDate] as? Date,
            Date().timeIntervalSince(creationDate) > Constants.cacheResetTimeout {
            try FileManager.default.removeItem(at: directoryURL)
        }
        if !FileManager.default.fileExists(atPath: directory.absoluteString) {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: false, attributes: [FileAttributeKey.creationDate : Date()])
        }
    }
    
    private func cacheDirectory(for id: String) -> URL? {
        return self.cachedImagesDirectory?.appendingPathComponent(id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? id)
    }
    
    private func imagePath(id: String, name: String) -> URL? {
        let idDirectory = self.cacheDirectory(for: id)
        return idDirectory?.appendingPathComponent(name)
    }
    
    private var cachedImagesDirectory: URL? {
        return self.documentsDirectory?.url?.appendingPathComponent(Constants.cachedImagesDirectory)
    }
    
    private var documentsDirectory: String? {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
    }
    
    private func validateFileName(for name: String) -> String {
        let characters = CharacterSet(charactersIn: "/\"#%;:.?,|[]{}@$%^*")
        return name.components(separatedBy: characters).joined()
    }
}

private extension String {
    var fileURL: URL? {
        return URL(fileURLWithPath: self)
    }
}

private extension URL {
    var fileURL: URL? {
        return self.absoluteString.fileURL
    }
}
