import Foundation
import UIKit

final class ImageServiceImplementation: ImageService {
    
    private let urlSession: URLSessionProtocol
    private let imageCache: ImageCache
    
    init(urlSession: URLSessionProtocol = URLSession.shared, imageCache: ImageCache = ImageCacheImplementation()) {
        self.urlSession = urlSession
        self.imageCache = imageCache
    }
    
    func downloadImage(url: URL, id: String, completion: ((UIImage?) -> Void)?) -> URLSessionTask {
        let task = self.urlSession.dataTask(with: URLRequest(url: url)) { [weak self] (data, response, error) in
            guard let sself = self else { return }
            guard error == nil else {
                SWLog(error: error!)
                completion?(nil)
                return
            }
            if let data = data, var image = UIImage(data: data) {
                sself.imageCache.save(image: image, name: url.path, id: id)
                sself.decompressImage(image: &image)
                completion?(image)
            } else {
                completion?(nil)
            }
        }
        task.resume()
        return task
    }
    
    func image(for name: String, id: String) -> UIImage? {
        return self.imageCache.image(for: name, id: id)
    }
    
    private func decompressImage(image: inout UIImage) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        image.draw(in: CGRect(x: 0, y: 0, width: 1, height: 1))
        UIGraphicsEndImageContext()
    }
    
}
