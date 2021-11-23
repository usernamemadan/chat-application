//
//  LoginViewController.swift
//  CustomCell
//
//  Created by Madan AR on 10/11/21.
//

import UIKit
import FirebaseAuth

protocol AuthenticationDelegate: class {
    func authenticationDidComplete()
}

class LoginViewController: UIViewController {
    
    // MARK: - properties
    weak var delegate: AuthenticationDelegate?
    var emailTextField = CustomTextField(placeholder: "Email")
    var passwordTextField = CustomTextField(placeholder: "Password")
    var dontHaveAnAccountTextField = UITextField()
    let loginButton = CustomButton(buttonText: "Login")
    let signupButton = CustomButton(buttonText: "Signup")
    
    lazy var emailContainerView: CustomContainerView = {
       return CustomContainerView(image: UIImage(systemName: "envelope.fill")!, textField: emailTextField)
        
    }()
    
    lazy var passwordContainerView: CustomContainerView = {
        passwordTextField.isSecureTextEntry = true
       return CustomContainerView(image: UIImage(systemName: "eye.fill")!, textField: passwordTextField)
    }()
    
    let chatLogo: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.image =  UIImage(systemName: "message.circle")
        image.tintColor = .black
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        return image
    }()
 
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        configureLoginButton()
        configureTextField()
        configureSignupButton()
        configureDelegates()
    }
    
    //MARK: - actions
    @objc func loginButtonPressed(){
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        guard email.isValidEmail(), password.isValidPassword() else {
            showAlert(error: "Please enter valid email and password")
            return
        }
        
        NetworkManager.shared.logUserIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                self.showAlert(error: error!.localizedDescription)
                return
            }
            self.delegate?.authenticationDidComplete()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func signupButtonPressed(){
        presentRegisterScreen()
    }
    
    // MARK: - helper functions
    func configureDelegates(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func configureLoginButton(){
        view.addSubview(loginButton)
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: 25).isActive = true
        
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: UIControl.Event.touchUpInside)
    }
    
    func configureSignupButton(){
        view.addSubview(signupButton)
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.topAnchor.constraint(equalTo: dontHaveAnAccountTextField.bottomAnchor, constant: 25).isActive = true
        
        signupButton.addTarget(self, action: #selector(signupButtonPressed), for: UIControl.Event.touchUpInside)
    }
    
    func configureTextField(){
        dontHaveAnAccountTextField.text = "Don't have an account?"
        dontHaveAnAccountTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dontHaveAnAccountTextField)
        dontHaveAnAccountTextField.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 200).isActive = true
        dontHaveAnAccountTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func configureUI(){
       
        view.addSubview(chatLogo)
        chatLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        chatLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 15
        view.addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
    }
   
    func presentRegisterScreen(){
        let registerVC = RegisterViewController()
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true, completion: nil)
    }
    
    func showAlert(error: String) {
        let dialogMessage = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: .none)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: - UITextfieldDelegate
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
