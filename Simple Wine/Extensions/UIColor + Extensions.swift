import UIKit

extension UIColor {
    
    // MARK: - Intializers
    
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0,
                  green: g / 255.0,
                  blue: b / 255.0,
                  alpha: a)
    }
    
    // MARK: - Type Methods
    
    public static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1.0) -> UIColor {
        return UIColor(r: r, g: g, b: b, a: a)
    }

}

