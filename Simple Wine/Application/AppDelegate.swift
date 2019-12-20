import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Instance Properties
    var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        return window
    }()
    
    
    // MARK: - Instance Methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Setup background fetch interval
        #if DEBUG
        let syncConfiguration = DebugSyncConfiguration()
        #else
        let syncConfiguration = DefaultSyncConfiguration()
        #endif
        UIApplication.shared.setMinimumBackgroundFetchInterval(syncConfiguration.interval)
        
        // Setup app services
        let authService = AuthServiceImplementation()
        let appLaunchConfigurator = AppLaunchConfigurator(authService: authService)
        SynchronizationManager.shared.setup(authService: authService, configuration: syncConfiguration)
        
        // Launch app
        appLaunchConfigurator.configure(for: window!)
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Start background fetch
        SynchronizationManager.shared.startSync { (success, error) in
            completionHandler(success ? .newData : .noData)
        }
    }
    
}

