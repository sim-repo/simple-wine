import Foundation

typealias SignInResponseBlock = (User?) -> Void
typealias SignOutResponseBlock = () -> Void

enum CurrentUserAuthStatus: Int {
    case notLogged, loggedId
}

enum AccountType {
    case simplewine, grandcru
}

protocol AuthService {
    
    // MARK: - Intsance Properties
    
    var isUserLoggedIn: Bool { get }
    var token: String? { get }
    var deviceCode: String? { get }
    var vinothequeID: String? { get }
    
    // MARK: - Intsance Methods
    
    func checkToken(completion: @escaping (_ isNormalToken: Bool) -> Void)
    func signIn(login: String,
                password: String,
                completion: @escaping SignInResponseBlock)
    func signOut(completion: @escaping SignOutResponseBlock)
}
