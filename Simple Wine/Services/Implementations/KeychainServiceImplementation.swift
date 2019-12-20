import Foundation
import SwiftKeychainWrapper

final class KeychainServiceImplementation: KeychainService {
    
    private struct KeychainKeys {
        static let token = "token"
        static let vinothequeID = "vinothequeID"
    }
    
    // MARK: - Intsance Properties
    
    private var _token: String?
    private var _vinothequeID: String?
    
    private let keychainWrapper = KeychainWrapper.standard
    
    // MARK: -
    
    var token: String? {
        get {
            if self._token == nil {
                // if no token cached
                let token = keychainWrapper.string(forKey: KeychainKeys.token)
                self._token = token
            }
            return self._token
        } set {
            self._token = newValue
            self.set(value: newValue, for: KeychainKeys.token)
        }
    }
    
    var vinothequeID: String? {
        get {
            if self._vinothequeID == nil {
                let vinothequeID = keychainWrapper.string(forKey: KeychainKeys.vinothequeID)
                self._vinothequeID = vinothequeID
            }
            return self._vinothequeID
        } set {
            self._vinothequeID = newValue
            self.set(value: newValue, for: KeychainKeys.vinothequeID)
        }
    }
    
    // MARK: - Intance methods
    private func set(value: String?, for key: String) {
        guard let newValue = value else {
            // if token set to nil - remove from keychain
            keychainWrapper.removeObject(forKey: key)
            return
        }
        let isSavedSuccessfully = keychainWrapper.set(newValue, forKey: key)
        if !isSavedSuccessfully {
            fatalError("=== Fail to write access \(key) to keychain")
        }
    }
}
