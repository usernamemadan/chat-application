//
//  RegisterViewController.swift
//  CustomCell
//
//  Created by Madan AR on 10/11/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {

//    let emailTextField: UITextField = {
//        let textField = UITextField()
//        textField.backgroundColor = .orange
//        textField.placeholder = "Enter the email"
//        textField.layer.cornerRadius = 10
//        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//
//    let emailContainverView: UIView = {
//        let view = UIView()
//        view.clipsToBounds = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        view.backgroundColor = .purple
//
//        let image = UIImageView()
//        image.image = UIImage(systemName: "envelope.fill")
//        view.addSubview(image)
//        image.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive  = true
//        image.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
//        image.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        image.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        image.translatesAutoresizingMaskIntoConstraints = false
//
//        let textField = UITextField()
//        textField.backgroundColor = .orange
//        textField.placeholder = "Enter the email"
//        textField.layer.cornerRadius = 10
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(textField)
//        textField.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 15).isActive = true
//        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
//        textField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
//
//
//        return view
//    }()
//
    
    var emailTextField = CustomTextField(placeholder: "Email")
    var passwordTextField = CustomTextField(placeholder: "Password")
    var firstNameTextField = CustomTextField(placeholder: "First Name")
    var lastNameTextField = CustomTextField(placeholder: "Second Name")
    var alreadyHaveAnAcc = UITextField()
    
    lazy var emailContainerView: CustomContainerView = {
       return CustomContainerView(image: UIImage(systemName: "envelope.fill")!, textField: emailTextField)
        
    }()
    
    lazy var passwordContainerView: CustomContainerView = {
        passwordTextField.isSecureTextEntry = true
       return CustomContainerView(image: UIImage(systemName: "eye.fill")!, textField: passwordTextField)
    }()
    
    lazy var firstNameContainerView: CustomContainerView = {
       return CustomContainerView(image: UIImage(systemName: "square.and.pencil")!, textField: firstNameTextField)
    }()
    
    lazy var lastNameContainerView: CustomContainerView = {
       return CustomContainerView(image: UIImage(systemName: "square.and.pencil")!, textField: lastNameTextField)
    }()
        
    let signupButton = CustomButton(buttonText: "Signup")
    let loginButton = CustomButton(buttonText: "Login")
    
    
    let photoButton: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.image =  UIImage(systemName: "person")
        image.tintColor = .black
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        return image
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        configureSignupButton()
        configureTextField()
        configureLoginButton()
        configureNotificationObserver()
    
    }
    
    func configureNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func  keyboardWillShow(){
        print("keyboard will show")
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 80
        }
    }
    
    @objc func keyboardWillHide(){
        print("keyboaard will hide")
        if view.frame.origin.y == -80 {
            self.view.frame.origin.y = 0
        }
    }
    
    func configureSignupButton(){
        view.addSubview(signupButton)
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.topAnchor.constraint(equalTo: lastNameContainerView.bottomAnchor, constant: 25).isActive = true
        
        signupButton.addTarget(self, action: #selector(signupButtonPressed), for: UIControl.Event.touchUpInside)
    }
    
    func configureLoginButton(){
        view.addSubview(loginButton)
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: alreadyHaveAnAcc.bottomAnchor, constant: 25).isActive = true
        
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: UIControl.Event.touchUpInside)
    }
    
    func configureUI(){
        
        view.addSubview(photoButton)
        photoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, firstNameContainerView, lastNameContainerView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 15
        view.addSubview(stack)
        
        
        stack.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 30).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        
        
    }
    
    func configureTextField(){
        alreadyHaveAnAcc.text = "Already have an account?"
        alreadyHaveAnAcc.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alreadyHaveAnAcc)
        alreadyHaveAnAcc.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 50).isActive = true
        alreadyHaveAnAcc.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    @objc func signupButtonPressed(){
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, err) in
            if err != nil {
                print("Error creating user")
            }
            else {

                let db = Firestore.firestore()
                db.collection("users").document(result!.user.uid).setData(["firstname":self.firstNameTextField.text!, "lastname":self.lastNameTextField.text!, "uid": result!.user.uid ]) { error in
                    if error != nil {
                        // Show error message
                        print("Error saving user data")
                    }
                }
                
                // Transition to the home screen
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }

        }
    }
    
    @objc func loginButtonPressed(){
        dismiss(animated: true, completion: nil)
    }

}
