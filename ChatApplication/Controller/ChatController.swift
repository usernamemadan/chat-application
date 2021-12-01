//
//  ChatControllerViewController.swift
//  CustomCell
//
//  Created by Madan AR on 18/11/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate  {

    fileprivate let cellId = "id123"
    var user: User?
    var messages: [Message] = []
    
    var images = [#imageLiteral(resourceName: "im3"), #imageLiteral(resourceName: "im2"), #imageLiteral(resourceName: "image1")]

    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var imagePickerController = UIImagePickerController()

    var messageTextField = CustomTextField(placeholder: "Type the message here..")
    
    
    lazy var sendMessageContainerView: SendMessageContainerView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.forward.fill")!
        let tap = UITapGestureRecognizer(target: self, action: #selector(HandleSendMessage))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        let photoButton = UIImageView()
        photoButton.image = UIImage(systemName: "photo.fill")
        let tapOnPhoto = UITapGestureRecognizer(target: self, action: #selector(pickPhoto))
        photoButton.addGestureRecognizer(tapOnPhoto)
        photoButton.isUserInteractionEnabled = true
        
        
        return SendMessageContainerView(iv: imageView, photoButton: photoButton, textField: messageTextField)
        
    }()
    
    var testMsg:[Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        imagePickerController.delegate = self
        
        navigationItem.title = user?.firstName
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        configureMessageLabel()
        configureTableView()
        configureNotificationObserver()
        
        DatabaseManager.shared.getMessages(messageId: getMessageId()) { messages in
            self.messages = messages
            self.tableView.reloadData()
         //   let lastIndex = NSIndexPath(row: self.messages.count - 1, section: 0)
           // self.tableView.scrollToRow(at: lastIndex as IndexPath, at: .bottom, animated: false)
        }
        
    }
    
    @objc func pickPhoto(){
        self.imagePickerController.allowsEditing = true
        self.present(self.imagePickerController, animated:  true, completion:  nil)
    }
    
    @objc func HandleSendMessage(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let text = messageTextField.text!
        let toId = user!.uid
        let msgId = getMessageId()

        let values = [ "msgId": msgId, "fromId": uid, "toId": toId, "text": text,"timestamp": Date()] as [String : Any]
        let message = Message(dictionary: values)
        DatabaseManager.shared.addMessage(with: message)
        DatabaseManager.shared.addRecentMessage(with: message)
        messageTextField.text = ""
    }
    
    @objc func  keyboardWillShow(){
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 350
        }
    }
    
    @objc func keyboardWillHide(){
        if view.frame.origin.y == -350 {
            self.view.frame.origin.y = 0
        }
    }
    
    func getMessageId() -> String {
        guard let uid = Auth.auth().currentUser?.uid else { return "" }
        let toId = user!.uid
        return uid > toId ? uid+toId : toId+uid
    }
    
    func configureNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
  
    
    func configureMessageLabel(){
        view.addSubview(sendMessageContainerView)
        NSLayoutConstraint.activate([
            sendMessageContainerView.heightAnchor.constraint(equalToConstant: 50),
            sendMessageContainerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            sendMessageContainerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            sendMessageContainerView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: sendMessageContainerView.topAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return messages.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageCell
       cell.chatMessage = messages[indexPath.row]
       
       if let imageUrl = messages[indexPath.row].imageUrl {
           NetworkManager.shared.downloadImage(fromURL: imageUrl) { image in
               if image != nil{
                   DispatchQueue.main.async {
                       cell.imageView.image = image
                   }
               }
              
           }
       }
       
 //      let height = tableView.frame.width / images[indexPath.row].getImageRatio()
  //     cell.mainImageView.image = images[indexPath.row]
       return cell
    }

    
    
    
}

//MARK: - UIImagePickerControllerDelegate
extension ChatController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = image.pngData() else { return }
        NetworkManager.shared.uploadChatImage(imageData: imageData) { [self] in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let text = "image"
            let toId = self.user!.uid
            let msgId = getMessageId()
            guard let urlString = UserDefaults.standard.value(forKey: "url") as? String else { return }

            let values = [ "msgId": msgId, "fromId": uid, "toId": toId, "text": text,"timestamp": Date(), "imageUrl": urlString] as [String : Any]
            let message = Message(dictionary: values)
            DatabaseManager.shared.addMessage(with: message)
        }
        
        
        
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true,completion: nil)
    }
    
}
