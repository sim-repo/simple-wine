
import UIKit

@IBDesignable
class WhiteLabelListItemView: UIView {

    @IBOutlet private weak var highlightView: UIView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private var lineView: UIView!
    
    var isFirst: Bool = false {
        didSet { lineView.isHidden = isFirst }
    }
    var themeType: ThemeType
    var clickCall: (()->())?
    
    required init?(coder aDecoder: NSCoder) {
        themeType = .depo
        super.init(coder: aDecoder)
    }
    
    init(with: ThemeType) {
        themeType = with
        super.init(frame: CGRect.zero)
        guard let view = loadViewFromNib() else { return }
        
        if let logo = themeType.logo() { logoImageView.image = logo }
        view.addToSuper(view: self)
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "WhiteLabelListItemView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.highlightView.isHidden = false
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        self.highlightView.isHidden = true
        AppTheme.theme = themeType
        clickCall?()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        self.highlightView.isHidden = true
    }
}
