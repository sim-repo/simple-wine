import UIKit

class WhiteLabelListViewController: BaseViewController {
    
    //MARK: - Properties
    
    var viewModel: WhiteLabelListModuleInput! {
        didSet { bind() }
    }
    
    @IBOutlet private var stackView: UIStackView!
    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let array: [ThemeType] = [.grandcru, .kuznetsky, .depo]
        
        for type in array {
            let view = WhiteLabelListItemView(with: type)
            view.isFirst = (array.first == type)
            view.clickCall = { self.showSignIn() }
            stackView.addArrangedSubview(view)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    //MARK: - View Model
    
    func bind() {
        
    }

    //MARK: - Private
    private func showSignIn() {
        let signinViewController = ModulesFactory.signIn().vc
        self.navigationController?.pushViewController(signinViewController, animated: true)
    }
    
    
}
