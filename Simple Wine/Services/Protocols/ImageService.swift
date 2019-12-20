import Foundation
import UIKit

protocol ImageService {
    func downloadImage(url: URL, id: String, completion: ((UIImage?) -> Void)?) -> URLSessionTask
    func image(for name: String, id: String) -> UIImage?
}
