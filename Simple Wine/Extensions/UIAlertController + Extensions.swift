import UIKit

extension UIAlertController {
    
    convenience init(error: SWError) {
        self.init(title: error.title, message: error.message, preferredStyle: .alert)
    }
}
