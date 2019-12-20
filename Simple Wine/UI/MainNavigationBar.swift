import UIKit

final class MainNavigationBar: UINavigationBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func setDefaultStyle() {
        backIndicatorImage = UIImage(named: "LeftArrowButton")?.withRenderingMode(.alwaysOriginal).scaleImageToSize(newSize: CGSize(width: 29, height: 29))
        backIndicatorTransitionMaskImage = UIImage(named: "LeftArrowButton")?.withRenderingMode(.alwaysOriginal).scaleImageToSize(newSize: CGSize(width: 29, height: 29))
        barTintColor = AppTheme.navbarBackground
        tintColor = AppTheme.lightGray
        shadowImage = UIImage()
        //isTranslucent = false
        titleTextAttributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17.0, weight: .regular),
            NSAttributedString.Key.foregroundColor : AppTheme.tint
        ]
    }
    
    private func initialize() {
        setDefaultStyle()
    }
}
