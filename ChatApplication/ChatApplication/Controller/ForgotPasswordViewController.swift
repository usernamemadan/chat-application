//
//  ForgotPasswordViewController.swift
//  ChatApplication
//
//  Created by Madan AR on 06/12/21.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    var emailTextField = CustomTextField(placeholder: "Enter the email")
    
    lazy var emailContainerView: CustomContainerView = {
       return CustomContainerView(image: UIImage(systemName: "envelope.fill")!, textField: emailTextField)
    }()
    let proceedButton = CustomButton(buttonText: "Proceed")
    let backButton = CustomButton(buttonText: "Back")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureEmail()
        configureProceedButton()
        configureBackButton()
    }

    func configureEmail(){
        view.addSubview(emailContainerView)
        emailContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        emailContainerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        emailContainerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        emailContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        emailContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func configureProceedButton(){
        view.addSubview(proceedButton)
        
        proceedButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        proceedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        proceedButton.topAnchor.constraint(equalTo: emailContainerView.bottomAnchor, constant: 25).isActive = true
        proceedButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        proceedButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
    }
    
    @objc func resetPassword(){
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { error in
            if let error = error {
                self.showAlert(error: error.localizedDescription)
                return
            }
            self.showAlert(error: "A password reset link has been sent to email")
        }
    }
    
    func configureBackButton(){
        view.addSubview(backButton)
        
        backButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backButton.topAnchor.constraint(equalTo: proceedButton.bottomAnchor, constant: 50).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backButton.addTarget(self, action: #selector(showLoginScreen), for: .touchUpInside)
    }
    
    @objc func showLoginScreen(){
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(error: String) {
        let dialogMessage = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: .none)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
