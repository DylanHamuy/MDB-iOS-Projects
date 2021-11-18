//
//  SignUpViewController.swift
//  MDB Social
//
//  Created by Dylan Hamuy on 11/3/21.
//

import UIKit
import FirebaseAuth
import NotificationBannerSwift
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!

    @IBOutlet weak var lastNameTextField: UITextField!

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    private var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        setUpElements()
        
    }
    
    func setUpElements() {
        //hide error label
        errorLabel.alpha = 0
        
        //styling elements
        Utilities.styleTextField(firstNameTextField)
        
        Utilities.styleTextField(lastNameTextField)
        
        Utilities.styleTextField(emailTextField)
        
        Utilities.styleTextField(usernameTextField)
        
        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleTextField(confirmPasswordTextField)
        
        Utilities.styleFilledButton(signUpButton)
        
    }
    
    //check the fields and validate that the data is correct. if everything is correct, return nil. otherwise return error message as a string
    func validateFields() -> String? {
        
        //check that all fields are filled in
        if  firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill in all fields"
        }
        
        //Check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedConfirmPassword = confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
             return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        if cleanedPassword != cleanedConfirmPassword {
            return "Please make sure your passwords match"
        }
        
        func validateEmail(enteredEmail:String) -> Bool {

            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            return emailPredicate.evaluate(with: enteredEmail)

        }
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if  !validateEmail(enteredEmail: cleanedEmail){
            return "Enter correct email format"
        }
        return nil
    }


    
    @IBAction func signUpTapped(_ sender: Any) {
        //validate the fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }
        
        else{
            
            //create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let fullName = firstName + " " + lastName
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            
            //create the user
            SOCAuthManager.shared.signUp(withEmail: email, password: password, fullName: fullName, username: username){ [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                    window.rootViewController = vc
                    let options: UIView.AnimationOptions = .transitionCrossDissolve
                    let duration: TimeInterval = 0.3
                    UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
                case .failure(let error):
                    switch error {
                    case .emailAlreadyInUse:
                        self.showErrorBanner(withTitle: "Email already in use", subtitle: "")
                    case .operationNotAllowed:
                        self.showErrorBanner(withTitle: "Error with operation", subtitle: "")
                    default:
                        self.showErrorBanner(withTitle: "User not found", subtitle: "Please provide an email")
                    }
                }
                
            }
            
            //transition to feedVC
            //self.transitionToFeedVC()
        }

    }
    
    func showError(_ message:String){
        showErrorBanner(withTitle: message)
    }
    
    func transitionToFeedVC(){
        performSegue(withIdentifier: "goToFeedVC", sender: self)
    }

    private func showErrorBanner(withTitle title: String, subtitle: String? = nil) {
        guard bannerQueue.numberOfBanners == 0 else { return }
        let banner = FloatingNotificationBanner(title: title, subtitle: subtitle,
                                                titleFont: .systemFont(ofSize: 17, weight: .medium),
                                                subtitleFont: subtitle != nil ?
                                                    .systemFont(ofSize: 14, weight: .regular) : nil,
                                                style: .warning)
        
        banner.show(bannerPosition: .top,
                    queue: bannerQueue,
                    edgeInsets: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15),
                    cornerRadius: 10,
                    shadowColor: .primaryText,
                    shadowOpacity: 0.3,
                    shadowBlurRadius: 10)
    }
}
