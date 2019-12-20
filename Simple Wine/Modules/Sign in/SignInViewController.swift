import UIKit

final class SignInViewController: ScrollViewController {
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    // MARK: - Outlets
    //@IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var loginTextField: TextField!
    @IBOutlet private weak var passwordTextField: TextField!
    @IBOutlet private weak var signInButton: UIButton!
    
    var viewModel: SignInViewModel! {
        didSet { bind() }
    }
    
    // MARK: - Actions
    @IBAction func signIn(_ sender: Any) {
        tryToSignIn()
    }

    // MARK: - Intance methods
    
    private func setInvalidState() {
        loginTextField.setInvalidState()
        passwordTextField.setInvalidState()
    }
    
    private func resetInvalidState() {
        loginTextField.resetInvalidState()
        passwordTextField.resetInvalidState()
    }
    
    private func bind() {
        viewModel.onSignInCompleted = { [weak self] user in
            guard let sself = self else { return }
            
            // Enable input views
            sself.updateInputEnabled(true)
            
            if let _ = user {
                let vc = ModulesFactory.menuCover().vc
                sself.navigationController?.fadeTo(vc)
            } else {
                sself.setInvalidState()
            }
        }
    }
    
    @objc private func tryToSignIn() {
        
        guard let login = self.loginTextField.text,
            !login.isEmpty else {
                loginTextField.setInvalidState()
                return
        }
        guard let password = self.passwordTextField.text,
            !password.isEmpty else {
                passwordTextField.setInvalidState()
                return
        }
        
        // Disable input views
        updateInputEnabled(false)
        
        viewModel.signIn(login: login, password: password)
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        #if DEBUG
            loginTextField.text = Config.testLogin
            passwordTextField.text = Config.testPassword
        #endif
        
        logoImageView.image = AppTheme.logo
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = view.backgroundColor
        navigationController?.navigationBar.isTranslucent = true
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginTextField.becomeFirstResponder()
    }
    
    fileprivate func unsubscibeFromNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscibeFromNotifications()
        view.endEditing(true)
    }
    
    fileprivate func updateInputEnabled(_ enabled: Bool) {
        loginTextField.textColor = enabled ? .black : .lightGray
        loginTextField.isEnabled = enabled
        
        passwordTextField.textColor = enabled ? .black : .lightGray
        passwordTextField.isEnabled = enabled
        
        signInButton.isEnabled = enabled
    }
}

// MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let tf = textField as? TextField else { return true }
        
        if tf == loginTextField {
            
            if let text = tf.text,
                !text.isEmpty {
                passwordTextField.becomeFirstResponder()
            } else {
                tf.setInvalidState()
            }
            
        } else if tf == passwordTextField {
            if let text = tf.text,
                !text.isEmpty {
                tryToSignIn()
            } else {
                tf.setInvalidState()
            }
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let tf = textField as? TextField {
            tf.resetInvalidState()
        }
        return true
    }
    
}
