import Foundation

final class AuthServiceImplementation: AuthService {
    
    // MARK: - Instance Properties
    
    private var keychainService: KeychainService
    private let apiClient: ApiClient
    private let systemDevice = ModulesFactory.systemDevice()
    
    var task: URLSessionTask?
    
    // MARK: -
    
    private(set) var token: String? {
        get {
            return UserDefaults().string(forKey: "token")
            //self.keychainService.token
        } set {
            let ud = UserDefaults()
            ud.set(newValue, forKey: "token")
            ud.synchronize()
            //self.keychainService.token = newValue
        }
    }
    
    private(set) var deviceCode: String? {
        get {
            return UserDefaults().string(forKey: "deviceCode")
        } set {
            let ud = UserDefaults()
            ud.set(newValue, forKey: "deviceCode")
            ud.synchronize()
        }
    }
    
    private(set) var login: String? {
        get {
            return UserDefaults().string(forKey: "login")
        } set {
            let ud = UserDefaults()
            ud.set(newValue, forKey: "login")
            ud.synchronize()
        }
    }
    
    private(set) var vinothequeID: String? {
        get {
            return UserDefaults().string(forKey: "vinothequeID")
            //self.keychainService.vinothequeID
        } set {
            let ud = UserDefaults()
            ud.set(newValue, forKey: "vinothequeID")
            ud.synchronize()
            //self.keychainService.vinothequeID = newValue
        }
    }
    
    var isUserLoggedIn: Bool {
        return self.token != nil
    }
    
    // MARK: - Initializers
    init(keychainService: KeychainService = KeychainServiceImplementation(),
         apiClient: ApiClient = ApiClientImplementation()) {
        self.keychainService = keychainService
        self.apiClient = apiClient
    }
    
    // MARK: - Instance Methods
    
    func checkToken(completion: @escaping (_ isNormalToken: Bool) -> Void) {
        guard let token = self.token, let deviceCode = self.deviceCode else {
            return
        }
        let checkTokenRequest = CheckTokenRequest(token: token, deviceCode: deviceCode)
        let _ = apiClient.makeRequest(request: checkTokenRequest, onSuccess: { [weak self] (authResponse, task, data) in
            self?.setTheme()
            completion(true)
        }) { (error, task, data) in
            completion(false)
        }
    }
    
    func signIn(login: String,
                password: String,
                completion: @escaping SignInResponseBlock) {
        
        systemDevice.loadSystemDevice(completion: {[weak self] (deviceCode, error) in
            guard let self = self, let deviceCode = deviceCode else {
                completion(nil)
                return
            }
            
            self.deviceCode = deviceCode
            
            // 1) create POST request for token to /user/authorization/
            let authRequest = AuthTokenRequest(login: login, password: password, deviceCode: deviceCode)
            let _ = self.apiClient.makeRequest(request: authRequest, onSuccess: { [weak self] (authResponse, task, data) in
                guard let sself = self, let token = authResponse?.value?.token else {
                    completion(nil)
                    return
                }
                
                // 2) create GET request to /user/profile with token to get user (Vinotheque info)
                let userRequest = UserProfileRequest(token: token, deviceCode: deviceCode)
                let _ = sself.apiClient.makeRequest(request: userRequest, onSuccess: { (userResponse, task, data) in
                    guard let user = userResponse?.value else {
                        completion(nil)
                        return
                    }
                    user.token = token
                    sself.token = token
                    //                sself.vinothequeID = user.vinothequeID
                    sself.login = login
                    
                    sself.setTheme()
                    completion(user)
                }, onFailure: { (error, task, data) in
                    completion(nil)
                })
                
            }) { (error, task, data)  in
                completion(nil)
            }
        })
    }
    
    func signOut(completion: @escaping SignOutResponseBlock) {
        SynchronizationManager.shared.clearData()
        
        self.token = nil
        completion()
    }
    
    private func setTheme(){
        guard let login = login else { return }
        guard let domain = login.components(separatedBy: "@").last, domain == "grandcru.ru" else { return }
        AppTheme.theme = .grandcru
    }
}
