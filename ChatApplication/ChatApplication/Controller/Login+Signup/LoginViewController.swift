//
//  LoginViewController.swift
//  CustomCell
//
//  Created by Madan AR on 10/11/21.
//

import UIKit
import FirebaseAuth

protocol AuthenticationDelegate: AnyObject {
    func authenticationDidComplete()
}

class LoginViewController: UIViewController {
    
    // MARK: - properties
    weak var delegate: AuthenticationDelegate?
    var emailTextField = CustomTextField(placeholder: "Email")
    var passwordTextField = CustomTextField(placeholder: "Password")
    var dontHaveAnAccountTextField = UITextField()
    let loginButton = CustomButton(buttonText: "Login")
    var forgotPasswordButton = UIButton()
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
        image.tintColor = .systemGray
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        return image
    }()
 
    
    let scrollView = UIScrollView(frame: .zero)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colors.WALightGray
      
        configureScrollView()
        configureUI()
        configureLoginButton()
        configureForgotPasswordTextField()
        configureDontHaveAccTextField()
        configureSignupButton()
        configureDelegates()
        
    }
    
    //MARK: - actions
    @objc func loginButtonPressed(){
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        guard !email.isEmpty, !password.isEmpty else {
            loginButton.shake()
            return
        }
        guard email.isValidEmail(), password.isValidPassword() else {
            showAlert(error: "Please enter valid email and password")
            return
        }
        loginButton.flash()
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
        signupButton.pulse()
        presentRegisterScreen()
    }
    
    @objc func handleForgotPassword(){
       presentForgotPasswordScreen()
    }
    
    @objc func handleOrientationChange() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: 700)
    }
    
    // MARK: - helper functions
    func configureDelegates(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func configureScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: 700)
    }
    
    func configureLoginButton(){
        scrollView.addSubview(loginButton)
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: 25).isActive = true
        
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: UIControl.Event.touchUpInside)
        
    }
    
    func configureForgotPasswordTextField(){
        forgotPasswordButton.setTitle("Forgot password? click here", for: .normal)
        forgotPasswordButton.setTitleColor(.white, for: .normal)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(forgotPasswordButton)
        forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15).isActive = true
        forgotPasswordButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        forgotPasswordButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
    }
    
    func configureSignupButton(){
        scrollView.addSubview(signupButton)
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        signupButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        signupButton.topAnchor.constraint(equalTo: dontHaveAnAccountTextField.bottomAnchor, constant: 15).isActive = true
        
        signupButton.addTarget(self, action: #selector(signupButtonPressed), for: UIControl.Event.touchUpInside)
    }
    
    func configureDontHaveAccTextField(){
        dontHaveAnAccountTextField.text = "Don't have an account?"
        dontHaveAnAccountTextField.textColor = .white
        dontHaveAnAccountTextField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(dontHaveAnAccountTextField)
        dontHaveAnAccountTextField.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 100).isActive = true
        dontHaveAnAccountTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
    }
    
    func configureUI(){
       
        scrollView.addSubview(chatLogo)
        chatLogo.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        chatLogo.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true

        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 15
        scrollView.addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 200).isActive = true
        stack.leftAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leftAnchor, constant: 50).isActive = true
        stack.rightAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.rightAnchor, constant: -50).isActive = true
    }
   
    func presentRegisterScreen(){
        let registerVC = RegisterViewController()
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true, completion: nil)
    }
    
    func presentForgotPasswordScreen(){
        let VC = ForgotPasswordViewController()
        VC.modalPresentationStyle = .fullScreen
        present(VC, animated: true)
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
    
    
    func configureObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
}

//MARK: - UITextfieldDelegate
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
