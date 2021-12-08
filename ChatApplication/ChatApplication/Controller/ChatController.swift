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

    var user: User?
    var messages: [Message] = []
    var pickedImage: UIImage?
    
    var imagePickerController = UIImagePickerController()
    lazy var messageTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = 20
        textField.attributedPlaceholder = NSAttributedString(
            string: "Message",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        return textField
    }()
    
    lazy var sendButton: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "sendButton-1.png")!
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(HandleSendMessage))
        imageView.addGestureRecognizer(tapOnImage)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var selectPhotoButton: UIImageView = {
        let photoButton = UIImageView()
        photoButton.image = UIImage(systemName: "photo.fill")
        photoButton.tintColor = UIColor.colors.WALightGray2
        let tapOnPhoto = UITapGestureRecognizer(target: self, action: #selector(pickPhoto))
        photoButton.addGestureRecognizer(tapOnPhoto)
        photoButton.isUserInteractionEnabled = true
        return photoButton
    }()
    
    lazy var sendMessageContainerView: SendMessageContainerView = {
        return SendMessageContainerView(imageview: sendButton, photoButton: selectPhotoButton, textField: messageTextField)
    }()
    
    override var inputAccessoryView: UIView? {
         get {
             sendMessageContainerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 65)
             return sendMessageContainerView
         }
     }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
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
            guard let image = pickedImage else { return }
           
            NetworkManager.shared.uploadImage(image: image, path: "Chat Images") { url in
                message.imageUrl = url
                DatabaseManager.shared.addMessage(with: message)
                self.pickedImage = nil
            }
        }
        else{
            DatabaseManager.shared.addMessage(with: message)
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
    
    func configureNavigationBar(){
        navigationItem.title = user?.firstName
        navigationController?.navigationBar.prefersLargeTitles = true
    }
        
    func configureTableView(){
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.messageCellIdentifier)
        tableView.register(ImageCell.self, forCellReuseIdentifier: ImageCell.imageCellIdentifier)
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        tableView.keyboardDismissMode = .interactive
        tableView.alwaysBounceVertical = true
        tableView.backgroundView = UIImageView(image: UIImage(named: "wallpaper.png"))
        tableView.backgroundView?.contentMode = .scaleToFill
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if messages[indexPath.row].imageUrl == nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.messageCellIdentifier, for: indexPath) as! MessageCell
            cell.chatMessage = messages[indexPath.row]
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.imageCellIdentifier, for: indexPath) as! ImageCell
            cell.chatMessage = messages[indexPath.row]
            cell.chatImageView.image = self.messages[indexPath.row].image
            
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
