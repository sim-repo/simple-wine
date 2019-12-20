import UIKit
import Fabric
import Crashlytics

final class AppLaunchConfigurator {
    
    // MARK: - Instance Properties
    
    let authService: AuthService
    
    // MARK: - Initializers
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    // MARK: - Instance Methods
    
    func configure(for window: UIWindow) {
        configureThirdPartiesServices()
        configureApp(for: window)
    }
    
    private func configureApp(for window: UIWindow) {
        // Restore theme
        if let currentTheme = UserDefaults.standard.value(forKey: Constants.UserDefaults.currentTheme) as? String {
            AppTheme.theme = ThemeType(rawValue: currentTheme) ?? .grandcru
        }
        
        // Configure root view controller
        let rootViewController = UINavigationController(navigationBarClass: MainNavigationBar.self, toolbarClass: nil)
        let firstViewController = ModulesFactory.whiteLabelList().vc
        rootViewController.setViewControllers([firstViewController], animated: false)
        window.rootViewController = rootViewController
        self.authService.checkToken { (isNormalToken) in
            if isNormalToken {
                UI_THREAD {
                    let menuCoverVC = ModulesFactory.menuCover().vc
                    firstViewController.navigationController?.fadeTo(menuCoverVC)
                }
            }
        }
    }
    
    private func configureThirdPartiesServices() {
        Fabric.with([Crashlytics.self])
    }
    
}
