//
//  RegisterViewController.swift
//  CustomCell
//
//  Created by Madan AR on 10/11/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class RegisterViewController: UIViewController, UINavigationControllerDelegate{
    
    // MARK: - properties
    weak var delegate: AuthenticationDelegate?
    var emailTextField = CustomTextField(placeholder: "Email")
    var passwordTextField = CustomTextField(placeholder: "Password")
    var firstNameTextField = CustomTextField(placeholder: "First Name")
    var lastNameTextField = CustomTextField(placeholder: "Second Name")
    var alreadyHaveAnAcc = UITextField()
    
    let signupButton = CustomButton(buttonText: "Signup")
    let loginButton = CustomButton(buttonText: "Login")
    
    var imagePickerController = UIImagePickerController()
    let storage = Storage.storage().reference()
    
    lazy var emailContainerView: CustomContainerView = {
        return CustomContainerView(image: UIImage(systemName: "envelope.fill")!, textField: emailTextField)
        
    }()
    
    lazy var passwordContainerView: CustomContainerView = {
        passwordTextField.isSecureTextEntry = true
        return CustomContainerView(image: UIImage(systemName: "eye.fill")!, textField: passwordTextField)
    }()
    
    lazy var firstNameContainerView: CustomContainerView = {
        firstNameTextField.textColor = .white
        return CustomContainerView(image: UIImage(systemName: "square.and.pencil")!, textField: firstNameTextField)
    }()
    
    lazy var lastNameContainerView: CustomContainerView = {
        lastNameTextField.textColor = .white
        return CustomContainerView(image: UIImage(systemName: "square.and.pencil")!, textField: lastNameTextField)
    }()
    
    
    let scrollView = UIScrollView(frame: .zero)
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.image =  UIImage(systemName: "person.fill.badge.plus")
        image.tintColor = .systemGray
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        return image
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colors.WALightGray
        configureScrollView()
        configureUI()
        configureSignupButton()
        configureTextField()
        configureLoginButton()
        configureNotificationObserver()
        configureDelegates()
        
    }
    
    //MARK: - actions
    @objc func addImage(){
        imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true
        self.present(self.imagePickerController, animated:  true, completion:  nil)
    }
    
    @objc func signupButtonPressed(){
        signupButton.pulse()
        signup()
    }
    
    @objc func loginButtonPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func  keyboardWillShow(){
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 80
        }
    }
    
    @objc func keyboardWillHide(){
        if view.frame.origin.y == -80 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func handleOrientationChange() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: 700)
    }
    
    // MARK: - helper functions
    func configureScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: 800)
    }
    
    
    func configureNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    
    func configureSignupButton(){
        scrollView.addSubview(signupButton)
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        signupButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        signupButton.topAnchor.constraint(equalTo: lastNameContainerView.bottomAnchor, constant: 25).isActive = true
        
        signupButton.addTarget(self, action: #selector(signupButtonPressed), for: UIControl.Event.touchUpInside)
    }
    
    func configureLoginButton(){
        scrollView.addSubview(loginButton)
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: alreadyHaveAnAcc.bottomAnchor, constant: 25).isActive = true
        
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: UIControl.Event.touchUpInside)
    }
    
    func configureUI(){
        
        scrollView.addSubview(profileImage)
        profileImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 80).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addImage))
        profileImage.addGestureRecognizer(tap)
        profileImage.isUserInteractionEnabled = true
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, firstNameContainerView, lastNameContainerView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 15
        scrollView.addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 30).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
    }
    
    func configureTextField(){
        alreadyHaveAnAcc.text = "Already have an account?"
        alreadyHaveAnAcc.textColor = .white
        alreadyHaveAnAcc.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(alreadyHaveAnAcc)
        alreadyHaveAnAcc.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 50).isActive = true
        alreadyHaveAnAcc.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func configureDelegates(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
    }
    
    
    func signup(){
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text
        else { return }
        
        guard isInputValid() == true else {
            signupButton.shake()
            return
        }
        
        NetworkManager.shared.SignUserIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print( error!.localizedDescription)
                return
            }
            
            guard let image = self.profileImage.image else { return}
            
            NetworkManager.shared.uploadImage(image: image, path: "Profile Images", completion: { url in
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                let values = ["uid": uid,
                              "first_name": firstName,
                              "last_name": lastName,
                              "email": email,
                              "profile_image_url": url,
                              "timestamp": Date(),
                              "isGroup": false] as [String : Any]
                let user = User(dictionary: values)
                DatabaseManager.shared.addUser(with: user)
                self.delegate?.authenticationDidComplete()
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            })
            
        }
    }
    
    func isInputValid() -> Bool {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return false}
        guard email.isValidEmail(), password.isValidPassword() else {
            showErrorAlert(error: "Please enter valid email and password")
            return false
        }
        
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text else { return false }
        guard firstName != "", lastName != "" else {
            showErrorAlert(error: "First name and last name connot be empty")
            return false
        }
        
        return true
    }
    
    func showErrorAlert(error: String) {
        let dialogMessage = UIAlertController(title: "error", message: error, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: .none)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.scrollView.endEditing(true)
    }
    
}

//MARK: - UITextfieldDelegate
extension RegisterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - UIImagePickerControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        profileImage.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true,completion: nil)
    }
    
}
