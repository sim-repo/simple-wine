
import UIKit

class MenuCoverViewController: BaseViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var borderView: UIView!
    var backgroundView: MenuCoverView!
    
    //MARK: - Properties
    
    var viewModel: MenuCoverModuleInput! {
        didSet { bind() }
    }
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        
        // Setup theme
        self.backgroundView = AppTheme.menuCoverView
        self.backgroundView.delegate = self
        self.view.insertSubview(backgroundView, at: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.backgroundView.frame = self.view.bounds
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: - View Model
    
    func bind() {
        
    }
}

extension MenuCoverViewController: MenuCoverViewDelegate {
    func didSelectItem(_ item: MenuCoverItem) {
        switch item {
        case .wineCard:
            showWineCard()
        case .logout:
            logout()
        }
    }
    
    private func showWineCard() {
        let mapMode = ModulesFactory.mapMode()
        self.navigationController?.show(mapMode, sender: self)
    }
    
    private func logout() {
        AuthServiceImplementation().signOut {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
