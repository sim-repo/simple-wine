import Foundation
import UIKit

extension UIViewController {
    
    static func fromStoryboard<T>() -> T {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
    }
}
