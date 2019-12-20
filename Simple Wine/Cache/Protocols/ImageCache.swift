import Foundation
import UIKit

protocol ImageCache: class {
    func image(for name: String, id: String) -> UIImage?
    func save(image: UIImage, name: String, id: String)
}
