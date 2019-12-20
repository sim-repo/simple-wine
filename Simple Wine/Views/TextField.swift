import UIKit

final class TextField: UITextField {
    
    // MARK: - Instance properties
    private let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 30);
    
    // MARK: - Instance Methods
    
    func setInvalidState() {
        
        // make textField text color "warning"
        self.textColor = AppTheme.textFieldInvalid
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: AppTheme.textFieldInvalid])
        
        // shake textField
        self.textColor = AppTheme.error
        let shakeDistance: CGFloat = 5.0
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - shakeDistance, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + shakeDistance, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }
    
    func resetInvalidState() {
        
        // set textField placeholder color to default
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: AppTheme.textFieldPlaceholder])
        // set textField text color to deafult
        self.textColor = AppTheme.textFieldText
    }

    
    // MARK: - UITextField
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

}
