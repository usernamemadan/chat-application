//
//  ChatControllerViewController.swift
//  CustomCell
//
//  Created by Madan AR on 18/11/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth



class ChatController: UITableViewController, UINavigationControllerDelegate  {

    fileprivate let messageCellIdentifier = "id1"
    fileprivate let imageCellIdentifier = "id2"
    var user: User?
    var messages: [Message] = []
    var pickedImage: UIImage?
    
    var imagePickerController = UIImagePickerController()
    var messageTextField = CustomTextField(placeholder: "Type the message here..")
    
    lazy var sendButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.forward.fill")!
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(HandleSendMessage))
        imageView.addGestureRecognizer(tapOnImage)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var selectPhotoButton: UIImageView = {
        let photoButton = UIImageView()
        photoButton.image = UIImage(systemName: "photo.fill")
    //    photoButton.
        let tapOnPhoto = UITapGestureRecognizer(target: self, action: #selector(pickPhoto))
        photoButton.addGestureRecognizer(tapOnPhoto)
        photoButton.isUserInteractionEnabled = true
        return photoButton
    }()
    
    lazy var sendMessageContainerView: SendMessageContainerView = {
        return SendMessageContainerView(imageview: sendButton, photoButton: selectPhotoButton, textField: messageTextField)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = user?.firstName
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureTableView()

        DatabaseManager.shared.getMessages(messageId: getMessageId()) { messages in
            self.messages = messages
            DispatchQueue.main.async {
                self.tableView.reloadData()
                let lastIndex = NSIndexPath(row: self.messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: lastIndex as IndexPath, at: .bottom, animated: true)
            }
        }
    }

    override var inputAccessoryView: UIView? {
         get {
             sendMessageContainerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
             return sendMessageContainerView
         }
     }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Actions
    @objc func pickPhoto(){
        imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true
        self.present(self.imagePickerController, animated:  true, completion:  nil)
    }
    
    @objc func HandleSendMessage(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let text = messageTextField.text!
        let toId = user!.uid
        let msgId = getMessageId()
        let isGroupMessage: Bool = user!.isGroup
     
        if pickedImage == nil && text == "" {
            return
        }
        
        let values = [ "msgId": msgId, "fromId": uid, "toId": toId, "text": text,"timestamp": Date(), "isGroupMessage": isGroupMessage] as [String : Any]
        let message = Message(dictionary: values)
        
        if pickedImage != nil {
            guard let imageData = pickedImage?.pngData() else { return }
           
            NetworkManager.shared.uploadChatImage(imageData: imageData) {
                guard let urlString = UserDefaults.standard.value(forKey: "url") as? String else { return }
                message.imageUrl = urlString
                DatabaseManager.shared.addMessage(with: message)
                DatabaseManager.shared.addRecentMessage(with: message)
                self.pickedImage = nil
            }
        }
        else{
            DatabaseManager.shared.addMessage(with: message)
            DatabaseManager.shared.addRecentMessage(with: message)
        }
       
        selectPhotoButton.image = UIImage(systemName: "photo.fill")
        messageTextField.text = ""
    }
    
    
    // MARK: - Helper functions
    func getMessageId() -> String {
        guard let uid = Auth.auth().currentUser?.uid else { return "" }
        if user?.isGroup == true {
            return user!.uid
        }
            
        let toId = user!.uid
        return uid > toId ? uid+toId : toId+uid
    }
        
    func configureTableView(){
        tableView.register(MessageCell.self, forCellReuseIdentifier: messageCellIdentifier)
        tableView.register(ImageCell.self, forCellReuseIdentifier: imageCellIdentifier)
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        tableView.keyboardDismissMode = .interactive
        tableView.alwaysBounceVertical = true
       
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].imageUrl == nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: messageCellIdentifier, for: indexPath) as! MessageCell
            cell.chatMessage = messages[indexPath.row]
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: imageCellIdentifier, for: indexPath) as! ImageCell
            cell.chatMessage = messages[indexPath.row]
            DispatchQueue.main.async {
                cell.chatImageView.image = self.messages[indexPath.row].image
            }
            return cell
        }
    }

}


//MARK: - UIImagePickerControllerDelegate

extension ChatController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
   
        pickedImage = image
        selectPhotoButton.image = pickedImage
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true,completion: nil)
    }
    
}
