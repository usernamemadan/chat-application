//
//  CreateGroupController.swift
//  ChatApplication
//
//  Created by Madan AR on 05/12/21.
//

import UIKit
import FirebaseAuth

class CreateGroupController: UIViewController {

    let profileImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.image =  UIImage(systemName: "person.fill.viewfinder")
        image.tintColor = .black
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true

        return image
    }()
    
    let firstNameTextField = CustomTextField(placeholder: "First Name")
    
    lazy var firstNameContainerView: CustomContainerView = {
       return CustomContainerView(image: UIImage(systemName: "square.and.pencil")!, textField: firstNameTextField)
    }()
    
    let signupButton = CustomButton(buttonText: "Signup")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureGroupImage()
        configureGroupNameField()
        configureCreateGroupButton()
    }
    
    func configureGroupImage(){
        view.addSubview(profileImage)
        
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        
//        profileImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
//        profileImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100).isActive = true
//        profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -100).isActive = true
//        profileImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    func configureGroupNameField(){
        view.addSubview(firstNameContainerView)
        firstNameContainerView.translatesAutoresizingMaskIntoConstraints = false
        firstNameContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        firstNameContainerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        firstNameContainerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        firstNameContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 400).isActive = true
    }

    func configureCreateGroupButton(){
        view.addSubview(signupButton)
        
        signupButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 500).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        signupButton.addTarget(self, action: #selector(createGroup), for: .touchUpInside)
    }
    
    @objc func createGroup(){
        guard let imageData = self.profileImage.image?.pngData() else { return }
        NetworkManager.shared.uploadImage(imageData: imageData) {
            guard let urlString = UserDefaults.standard.value(forKey: "url") as? String else { return }
         //   guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let values = ["uid": UUID().uuidString, "first_name": self.firstNameTextField.text!, "last_name": "", "email": "", "profile_image_url": urlString, "timestamp": Date(), "isGroup": true] as [String : Any]
            let user = User(dictionary: values)
            DatabaseManager.shared.insertUser(with: user)
          //  self.delegate?.authenticationDidComplete()
            self.navigationController?.popToRootViewController(animated: true)
            
        }
    }
    
}
