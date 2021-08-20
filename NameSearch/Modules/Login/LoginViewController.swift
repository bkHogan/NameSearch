import UIKit


protocol LoginViewType: AnyObject {
    func updateUI()
    func showError()
}

class LoginViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    
    var viewModel:LoginType!
    
    override func viewDidLoad() {
        viewModel  = LoginViewModel(loginView:self)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        viewModel.login(userName:usernameTextField.text!, password: passwordTextField.text!)
    }

    
}

extension LoginViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension LoginViewController:LoginViewType {
    func updateUI() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showDomainSearch", sender: self)
        }
    }
    
    func showError() {
        
    }
}
