//
//  CreateGroupController.swift
//  ChatApplication
//
//  Created by Madan AR on 05/12/21.
//

import UIKit
import FirebaseAuth

class CreateGroupController: UIViewController, UINavigationControllerDelegate {

    var imagePickerController = UIImagePickerController()
    
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.image =  UIImage(systemName: "person.crop.circle.badge.plus")
        image.tintColor = .darkGray
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addImage))
        image.addGestureRecognizer(tap)
        image.isUserInteractionEnabled = true

        return image
    }()
    
    let groupNameTextField = CustomTextField(placeholder: "Group Name")
    
    lazy var groupNameContainerView: CustomContainerView = {
       return CustomContainerView(image: UIImage(systemName: "square.and.pencil")!, textField: groupNameTextField)
    }()
    
    let createGroupButton = CustomButton(buttonText: "Create Group")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .colors.WAGray
        navigationController?.navigationBar.prefersLargeTitles = false

        configureGroupImage()
        configureGroupNameField()
        configureCreateGroupButton()
    }
    
    @objc func addImage(){
        imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true
        self.present(self.imagePickerController, animated:  true, completion:  nil)
    }
    
    @objc func selectContacts(){
        guard let groupName = self.groupNameTextField.text, !groupName.isEmpty else {
            createGroupButton.shake()
            return
        }
        
        let VC = SelectUsersViewController()
        VC.showCheckBox = true
        VC.delgate = self
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func configureGroupImage(){
        view.addSubview(profileImage)
        
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
    }

    func configureGroupNameField(){
        view.addSubview(groupNameContainerView)
        
        groupNameContainerView.translatesAutoresizingMaskIntoConstraints = false
        groupNameContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        groupNameContainerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        groupNameContainerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        groupNameContainerView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 25).isActive = true
    }

    func configureCreateGroupButton(){
        view.addSubview(createGroupButton)
        
        createGroupButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        createGroupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createGroupButton.topAnchor.constraint(equalTo: groupNameContainerView.bottomAnchor, constant: 50).isActive = true
        createGroupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        createGroupButton.addTarget(self, action: #selector(selectContacts), for: .touchUpInside)
    }
    
   
    
}
    
extension CreateGroupController: createGroupDelegate{
    func createGroup(usersId: String, selectedUsers: [User]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let image = profileImage.image  else { return }
        guard let groupName = self.groupNameTextField.text, !groupName.isEmpty else {
            createGroupButton.shake()
            return
        }
        
        NetworkManager.shared.uploadImage(image: image, path: "Profile Images") { url in
            let values = ["uid": UUID().uuidString + uid + usersId,
                          "first_name": groupName,
                          "last_name": "",
                          "email": "",
                          "profile_image_url": url,
                          "timestamp": Date(),
                          "isGroup": true] as [String : Any]
            
            let user = User(dictionary: values)
            DatabaseManager.shared.addUser(with: user)
            DatabaseManager.shared.fetchUser(uid: uid) { currentUser in
                var groupUsers = selectedUsers
                groupUsers.append(currentUser)
                DatabaseManager.shared.addGroupUsers(group: user, users: groupUsers)
            }
            
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

//MARK: - UIImagePickerControllerDelegate
extension CreateGroupController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        profileImage.image = image
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true,completion: nil)
    }
    
}
