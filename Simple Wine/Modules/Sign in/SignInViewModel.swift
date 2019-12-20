import Foundation

protocol SignInViewModelProtocol: class {
    var onSignInCompleted: ((User?) -> Void)? { get set }
    func signIn(login: String, password: String)
}

final class SignInViewModel: NSObject, SignInViewModelProtocol, SignInModuleInput {
    
    // MARK: - Instance Properties
    
    private var user: User?
    
    var onSignInCompleted: ((User?) -> Void)?
    
    private let authService: AuthService
    
    init(userService: AuthService = AuthServiceImplementation()) {
        self.authService = userService
    }
    
    func signIn(login: String, password: String) {
        let _ = authService.signIn(login: login, password: password) { [weak self] (user) in
            guard let sself = self else { return }
            UI_THREAD {
                sself.onSignInCompleted?(user)
            }
        }
    }
}
