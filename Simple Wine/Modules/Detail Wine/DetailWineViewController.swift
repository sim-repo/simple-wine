import UIKit

final class DetailWineViewController: BaseViewController {

    private var viewModel: DetailWineViewModel! {
        didSet { bind() }
    }
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var wineImageView: UIImageView!
    @IBOutlet private weak var propertiesStack: UIStackView!
    @IBOutlet private weak var articleLabel: UILabel!
    @IBOutlet private weak var priceTitleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    var isWineLiked: Bool = false {
        didSet {
            updateLikeButton()
        }
    }
    
    init(viewModel: DetailWineViewModel) {
        super.init(nibName: nil, bundle: nil)
        defer { self.viewModel = viewModel }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isWineLiked = viewModel.isWineLiked
        articleLabel.textColor = AppTheme.darkGray
        priceTitleLabel.textColor = AppTheme.darkGray
        priceLabel.textColor = AppTheme.tint
        //detailLabel.textColor = AppTheme.darkGray
        reloadView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
    
    func reloadView() {
        nameLabel.text = viewModel.nameTitle
        
        reloadProperties()
        articleLabel.text = viewModel.articleTitle
        priceLabel.text = Float(viewModel.price ?? 0).currency(fractionDigits: 0)
//        var description = viewModel.descriptionTitle?.lowercased()
//        var firstCharacter = description?.first?.description.uppercased()
//        if firstCharacter != nil {
//            description?.removeFirst()
//            firstCharacter! += description!
//        } else {
//            firstCharacter = description
//        }
//        detailLabel.text = firstCharacter
//

        //wineInformationView.descriptionText = firstCharacter
        updateSubviewsAppeareance(show: !viewModel.isActivityIndicatorAnimating)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        wineImageView.image = nil
        viewModel.close()
    }
    
    @IBAction func clickLike(_ sender: Any){
        isWineLiked.toggle()
        viewModel.isWineLiked = isWineLiked
    }
    
    private func updateSubviewsAppeareance(show: Bool) {
        if show {
            scrollView.subviews.forEach { $0.isHidden = false }
        } else {
            scrollView.subviews.filter { $0 != closeButton }.forEach { $0.isHidden = true }
        }
    }
    
    private func bind() {
        viewModel.onBitrixDidChanged = { [weak self] in
            guard let sself = self else { return }
            UIView.animate(withDuration: 0.25, animations: {
                sself.reloadView()
            })
        }
        viewModel.onImageDidLoaded = { [weak self] in
            guard let sself = self else { return }
            UI_THREAD {
                let transition = CATransition()
                transition.duration = 0.25
                transition.type = CATransitionType.fade
                sself.wineImageView.layer.add(transition, forKey: nil)
                sself.wineImageView.image = sself.viewModel.wineImage
            }
        }
        viewModel.onFlagImageDidLoaded = { [weak self] in
            guard let `self` = self else { return }
            UI_THREAD {
                self.reloadProperties()
            }
        }
        viewModel.onAcitivityIndicatorStateChanged = { [weak self] in
            guard let sself = self else { return }
            sself.viewModel.isActivityIndicatorAnimating ? sself.activityIndicator.startAnimating() : sself.activityIndicator.stopAnimating()
            sself.updateSubviewsAppeareance(show: !sself.viewModel.isActivityIndicatorAnimating)
        }
        viewModel.onErrorOccured = { [weak self] (error: SWError) in
            guard let sself = self else { return }
            if sself.presentedViewController == nil {
                let alert = UIAlertController(error: error)
                alert.addAction(UIAlertAction(title: Localization.Common.OK, style: .default, handler: nil))
                sself.present(alert, animated: true, completion: nil)
            }
        }
        viewModel.isLikedChanged = { [weak self] in
            guard let `self` = self else { return }
            self.isWineLiked = self.viewModel.isWineLiked
        }
    }
    
}

private extension DetailWineViewController {
    
    func reloadProperties(){
        while propertiesStack.arrangedSubviews.count > 0 {
            propertiesStack.arrangedSubviews.last?.removeFromSuperview()
        }
        
        for items in viewModel.winePropertyItems {
            let view = WinePropertyView()
            view.winePropertyItem = items
            propertiesStack.addArrangedSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(height)]", metrics: ["height" : view.intrinsicContentSize.height], views: ["view" : view]))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(width)]", metrics: ["width" : propertiesStack.frame.width], views: ["view" : view]))
        }
    }
    
    private func updateLikeButton() {
        let imageName = isWineLiked ? "LikeButton" : "DislikeButton"
        let tintColor = isWineLiked ? AppTheme.tint : UIColor.black
        UI_THREAD {
            self.likeButton.setImage(UIImage(named: imageName), for: .normal)
            self.likeButton.tintColor = tintColor
        }
    }
}

extension Localization {
    
    enum DetailWine {
        static var inRestaurant: String {
            switch Localization() {
                case .russian: return "В ресторане"
            }
        }
        static var withYourself: String {
            switch Localization() {
                case .russian: return "С собой"
            }
        }
    }
    
}
