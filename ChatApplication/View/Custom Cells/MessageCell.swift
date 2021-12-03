//
//  MessageCellTableViewCell.swift
//  CustomCell
//
//  Created by Madan AR on 18/11/21.
//

import UIKit
import FirebaseAuth

//class MessageCell: UITableViewCell {
//
//    let messageLabel: UILabel = {
//        var label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.numberOfLines = 0
//        return label
//    }()
//
//    var leadingC: NSLayoutConstraint?
//    var trailingC: NSLayoutConstraint?
//
//    var leadingConstraints: [NSLayoutConstraint] = []
//    var trailingConstraints: [NSLayoutConstraint] = []
//
//
//    var messageViewConstraints: [NSLayoutConstraint] = []
//    var imageViewConstraints: [NSLayoutConstraint] = []
//
//    var chatImageView : UIImageView  = {
//        var imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.clipsToBounds = true
//        return imageView
//    }()
//
//    let bubbleBackgroundView: UIView = {
//        var view = UIView()
//        view.backgroundColor = .systemYellow
//        view.layer.cornerRadius = 12
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    var chatMessage: Message? {
//        didSet {
//      //      var isIncoming: Bool
//            guard let uid = Auth.auth().currentUser?.uid else { return }
//            var isIncoming = uid != chatMessage?.fromId
//
//            if(chatMessage?.imageUrl != nil){
////                configureImageView()
////                if isIncoming {
////                    messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = false
////                    chatImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = false
////
////                    chatImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
////                    messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
////                }
////                else{
////                    chatImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = false
////                    messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = false
////
////                    messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
////                    chatImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
////                }
//
//            }
//            else{
//                configureMessageView()
//                if isIncoming {
//        //           messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = false
//                    trailingC?.isActive = false
//                    leadingC?.isActive = true
//
//        //            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
//        //            leadingC?.isActive = true
//                }
//                else{
////                   messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = false
//             //       leadingC?.isActive = false
//               //     trailingC?.isActive = true
//////
////                   messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
//                }
//            }
//
//            bubbleBackgroundView.backgroundColor = isIncoming ? .systemTeal : .darkGray
//            messageLabel.textColor = isIncoming ? .black : .white
//            messageLabel.text = chatMessage?.text
//          //  messageLabel.text = ""
//
////            if isIncoming {
//            //    setLeadingConstraints()
////                trailingConstraint.isActive = false
////                trailingConstraintOfImageView.isActive = false
////               leadingConstraint.isActive = true
////                leadingConstraintOfImageView.isActive = true
//
// //           }
////            else {
//           //     setTrailingConstraints()
////                leadingConstraint.isActive = false
////                leadingConstraintOfImageView.isActive = false
////                trailingConstraint.isActive = true
////                trailingConstraintOfImageView.isActive = true
// //          }
//
////            if chatMessage.imageUrl != nil {
////                guard let imageUrl = chatMessage.imageUrl else { return }
////                NetworkManager.shared.downloadImage(fromURL: imageUrl) { image in
////                    if image != nil{
////                        DispatchQueue.main.async {
////                            self.mainImageView.image = image
////                        }
////                    }
////                }
////            }
//
//        }
//}
//
//    var height = 0
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        print("height   \(height)")
//
//        backgroundColor = .white
////        configureImageView()
////       configureMessageView()
//
//        leadingC?.isActive = false
//        trailingC?.isActive = true
//
//    }
//
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func configureImageView(){
//        addSubview(bubbleBackgroundView)
//        addSubview(chatImageView)
//        addSubview(messageLabel)
//
//
//
//        imageViewConstraints = [
//            chatImageView.topAnchor.constraint(equalTo: topAnchor, constant: 32),
//            chatImageView.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: 0),
//            chatImageView.widthAnchor.constraint(equalToConstant: 200),
//    //        chatImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -32),
//            chatImageView.heightAnchor.constraint(equalToConstant: 200),
//
//
//            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
//            messageLabel.widthAnchor.constraint(equalToConstant: 200),
//    //        messageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -32),
//
//
//            bubbleBackgroundView.topAnchor.constraint(equalTo: chatImageView.topAnchor, constant: -16),
//            bubbleBackgroundView.leadingAnchor.constraint(equalTo: chatImageView.leadingAnchor, constant: -16),
//            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
//            bubbleBackgroundView.trailingAnchor.constraint(equalTo: chatImageView.trailingAnchor, constant: 16),
//
//        ]
//
//        NSLayoutConstraint.activate(imageViewConstraints)
//
//
//    }
//
//    func configureMessageView(){
//
//        addSubview(bubbleBackgroundView)
//        addSubview(messageLabel)
//
//        leadingC =  messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
//        trailingC = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
//
//        leadingC?.isActive = false
//        trailingC?.isActive = true
//
//
//
//        messageViewConstraints = [
//            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
//            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
//            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
//
//            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
//            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
//            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
//            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
//            ]
//        NSLayoutConstraint.activate(messageViewConstraints)
//
////        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
////        leadingConstraint.isActive = false
////        leadingConstraintOfImageView = chatImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
////        leadingConstraintOfImageView.isActive = false
////
////        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
////        trailingConstraint.isActive = true
////        trailingConstraintOfImageView = chatImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
////        trailingConstraintOfImageView.isActive = true
//
//    }
//
//    func setLeadingConstraints(){
////        leadingConstraints = [
////            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
////        //    chatImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
////        ]
////        NSLayoutConstraint.activate(leadingConstraints)
//    }
//
//    func setTrailingConstraints(){
//        trailingConstraints = [
//            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
//            chatImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
//        ]
//     //   NSLayoutConstraint.activate(trailingConstraints)
//    }
//
//    func printHeight(){
//        print(height)
//    }
//}
//








class MessageCell: UITableViewCell {

        let messageLabel: UILabel = {
            var label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            return label
        }()
        let bubbleBackgroundView: UIView = {
            var view = UIView()
            view.backgroundColor = .systemYellow
            view.layer.cornerRadius = 12
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    
        var chatImageView : UIImageView  = {
            var imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.clipsToBounds = true
            return imageView
        }()
    
    
    var chatMessage: Message! {
        didSet {

            guard let uid = Auth.auth().currentUser?.uid else { return }
            var isIncoming = uid != chatMessage?.fromId
            bubbleBackgroundView.backgroundColor = isIncoming ? .systemTeal : .darkGray
            messageLabel.textColor = isIncoming ? .black : .white
            
            messageLabel.text = chatMessage.text
            
            
            if isIncoming {
                trailingConstraint.isActive = false
                leadingConstraint.isActive = true
               
            } else {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        configureMessageCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureMessageCell(){
        bubbleBackgroundView.backgroundColor = .yellow
        bubbleBackgroundView.layer.cornerRadius = 12
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubbleBackgroundView)
        
        addSubview(messageLabel)
        
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            

            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
            ]
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint.isActive = false
        
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint.isActive = true
    
    }
}
