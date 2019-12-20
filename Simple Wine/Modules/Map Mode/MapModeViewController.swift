import UIKit
import Reachability

var STATIC_URL: String?

final class MapModeViewController: BaseViewController {
    
    // MARK: - Instance Properties
    
    private lazy var system = ModulesFactory.systemDevice()
    
    @IBOutlet private var lines: [UIView]!
    
    @IBOutlet private weak var stackView: UIStackView!
    
    private lazy var syncIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    private lazy var syncButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.setImage(UIImage(named: "SyncButton"), for: .normal)
        button.tintColor = AppTheme.lightGray
        button.addTarget(self, action: #selector(syncBarButtonItemDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Instance Methods
    
    private func setupNavbar() {        
        // Set title icon
        let image = AppTheme.logo
        let width = UIScreen.main.bounds.width / 3
        let height = width * image.size.height / image.size.width
        
        let imageView: UIImageView!
        if #available(iOS 11, *) {
            imageView = UIImageView()
            imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        } else {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        }
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        navigationItem.titleView = imageView
        
        // Add sync button
        
        #if DEBUG
            let syncBarView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            syncBarView.backgroundColor = UIColor.clear

            var frame = syncIndicator.frame
            frame.origin = CGPoint(x: (syncBarView.frame.width - frame.width)/2, y: (syncBarView.frame.height - frame.height)/2)
            syncIndicator.frame = frame
            syncIndicator.isHidden = true
            syncBarView.addSubview(syncIndicator)
            syncButton.frame = syncBarView.bounds
            syncBarView.addSubview(syncButton)
            let syncBarButtonItem = UIBarButtonItem(customView: syncBarView)
            navigationItem.rightBarButtonItem = syncBarButtonItem
        #endif

    }
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        
        system.loadURL()
        
        for line in self.lines {
            line.backgroundColor = AppTheme.line
        }
        
        // Observe synchronization updates
        NotificationCenter.default.addObserver(self, selector: #selector(updateLoadingState), name: .synchronizationDidStart, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLoadingState), name: .synchronizationDidFinish, object: nil)
        
        for mode in [.classic, .price] as [WineMapMode] {
            let view = MapModeListItemView.load(with: mode)
            view.clickCall = { (view) in
                var wineMap = ModulesFactory.wineMap()
                wineMap.module.wineMapMode = view.mapMode
                self.navigationController?.pushViewController(wineMap.vc, animated: true)
            }
            stackView.addArrangedSubview(view)
        }
        let view = UIView()
        view.backgroundColor = UIColor.clear
        stackView.addArrangedSubview(view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // It's time to try to sync data
        syncData()
        
        // Update screen state
        updateLoadingState()
    }
    
    
    // MARK: - Actions
    
    @objc func syncBarButtonItemDidTap(_ sender: UIButton) {
        // Create sync information alert
        let alertController: UIAlertController
        if SynchronizationManager.shared.isSyncing {
            alertController = UIAlertController(title: nil, message: "Идет обновление.\nПожалуйста подождите...", preferredStyle: .actionSheet)
        }
        else {
            alertController = UIAlertController(title: "Время последнего обновления:", message: SynchronizationManager.shared.lastSyncDateString, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Обновить сейчас",
                                                    style: UIAlertAction.Style.default,
                                                    handler: {[weak self] (alert: UIAlertAction!) in
                                                        guard let self = self else { return }
                                                        
                                                        // Force sync data now
                                                        self.syncData(forced: true)
                                                        
            }))
        }
        
        alertController.view.tintColor = AppTheme.tint
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        present(alertController, animated: true)
    }
    
    
    // MARK: - Private Helpers
    
    @objc private func updateLoadingState() {
        // If there is no synced data then show sync is in progress indication
        syncIndicator.isHidden = !SynchronizationManager.shared.isSyncing
        syncButton.setImage(SynchronizationManager.shared.isSyncing ? UIImage() : UIImage(named: "SyncButton"), for: .normal)
        
        showLoading(!SynchronizationManager.shared.hasSynchronizedData() && SynchronizationManager.shared.isSyncing)
    }
    
    private func syncData(forced: Bool = false) {
        SynchronizationManager.shared.startSync(forced: forced, completion: { (success, error) in
            if let error = error {
                ToastView.showError(error: error)
            }
        })
    }
    
    private func showLoading(_ loading: Bool) {
        
        for view in stackView.subviews {
            if let view = view as? MapModeListItemView {
                view.isLoading = loading
            }
        }
        
    }
    
}
