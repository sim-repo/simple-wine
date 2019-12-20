import UIKit

extension UIView {
    
    // MARK: - Instance Properties
    
    public var top: CGFloat {
        return self.frame.origin.y
    }
    
    public var bottom: CGFloat {
        return self.frame.origin.y + self.frame.height
    }
    
    public var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame = CGRect(x: newValue, y: top, width: width, height: height)
        }
    }
    
    public var right: CGFloat {
        return self.frame.origin.x + self.frame.width
    }
    
    public var height: CGFloat {
        return self.frame.height
    }
    
    public var width: CGFloat {
        return self.frame.width
    }
    
    // MARK: -
    
    public var adjusted: CGRect {
        return CGRect(x: Int(floor(self.frame.origin.x)),
                      y: Int(floor(self.frame.origin.y)),
                      width: Int(ceil(self.frame.width)),
                      height: Int(ceil(self.frame.height)))
    }
    

    class func fromXib<T>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as! T
    }
    
    enum ViewSide {
        case left, right, top, bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, withThickness thickness: CGFloat, withLeftIndent leftIndent: CGFloat = 0.0, andRightIndent rightIndent: CGFloat = 0.0) {
        let border = CALayer()
        border.backgroundColor = color
        switch side {
        case .left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height)
        case .right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height)
        case .top: border.frame = CGRect(x: frame.minX, y: 0, width: frame.width, height: thickness)
        case .bottom: border.frame = CGRect(x: frame.minX + leftIndent, y: frame.height, width: frame.width - leftIndent - rightIndent, height: thickness)
        }
        layer.addSublayer(border)
    }
    
    func removeBorders() {
        layer.sublayers = nil
    }
    
    
    // MARK: -
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
}
