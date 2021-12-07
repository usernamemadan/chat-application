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
    
    let groupNameTextField = CustomTextField(placeholder: "Group Name")
    
    lazy var groupNameContainerView: CustomContainerView = {
       return CustomContainerView(image: UIImage(systemName: "square.and.pencil")!, textField: groupNameTextField)
    }()
    
    let signupButton = CustomButton(buttonText: "Create Group")
    
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
        profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        
    }

    func configureGroupNameField(){
        view.addSubview(groupNameContainerView)
        groupNameContainerView.translatesAutoresizingMaskIntoConstraints = false
        groupNameContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        groupNameContainerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        groupNameContainerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        groupNameContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
    }

    func configureCreateGroupButton(){
        view.addSubview(signupButton)
        
        signupButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 500).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        signupButton.addTarget(self, action: #selector(selectContacts), for: .touchUpInside)
    }
    
    @objc func selectContacts(){
        let VC = SelectContactsViewController()
        VC.showCheckBox = true
        VC.delgate = self
        navigationController?.pushViewController(VC, animated: true)
    }
    
}
    
extension CreateGroupController: createGroupDelegate{
    func createGroup(uniqueId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let image = profileImage.image  else { return }
        
        NetworkManager.shared.uploadImage(image: image, path: "Profile Images") { url in
            let values = ["uid": UUID().uuidString + uid + uniqueId,
                          "first_name": self.groupNameTextField.text!,
                          "last_name": "",
                          "email": "",
                          "profile_image_url": url,
                          "timestamp": Date(),
                          "isGroup": true] as [String : Any]
            
            let user = User(dictionary: values)
            DatabaseManager.shared.insertUser(with: user)
            
            let chatVC = ChatController()
            chatVC.user = user
            
            var vcArray = self.navigationController?.viewControllers
            vcArray!.removeLast()
            vcArray!.removeLast()
            vcArray!.append(chatVC)
            self.navigationController?.setViewControllers(vcArray!, animated: false)
            
        }
    }
    
    
}
