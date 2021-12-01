//
//  MessageCellTableViewCell.swift
//  CustomCell
//
//  Created by Madan AR on 18/11/21.
//

import UIKit
import FirebaseAuth

class MessageCell: UITableViewCell {

    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    var leadingConstraintOfImageView: NSLayoutConstraint!
    var trailingConstraintOfImageView: NSLayoutConstraint!
    
    var imageView : UIImageView  = {
        var imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    var chatMessage: Message! {
        didSet {
            var isIncoming = true
            guard let uid = Auth.auth().currentUser?.uid else { return }
            if uid == chatMessage.fromId{
                isIncoming = false
            }
            bubbleBackgroundView.backgroundColor = isIncoming ? .systemTeal : .darkGray
            messageLabel.textColor = isIncoming ? .black : .white
            
            messageLabel.text = chatMessage.text
            
            if isIncoming {
                trailingConstraint.isActive = false
                trailingConstraintOfImageView.isActive = false
                leadingConstraint.isActive = true
                leadingConstraintOfImageView.isActive = true
               
            } else {
                leadingConstraint.isActive = false
                leadingConstraintOfImageView.isActive = false
                trailingConstraint.isActive = true
                trailingConstraintOfImageView.isActive = true
           }
            
//            if chatMessage.imageUrl != nil {
//                guard let imageUrl = chatMessage.imageUrl else { return }
//                NetworkManager.shared.downloadImage(fromURL: imageUrl) { image in
//                    if image != nil{
//                        DispatchQueue.main.async {
//                            self.mainImageView.image = image
//                        }
//                    }
//                }
//            }
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        bubbleBackgroundView.backgroundColor = .yellow
        bubbleBackgroundView.layer.cornerRadius = 12
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubbleBackgroundView)
        
        
        addSubview(messageLabel)
        addSubview(imageView)
        
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            
            
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
    //        mainImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            imageView.widthAnchor.constraint(equalToConstant: 75),
      //      mainImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: 32),
            imageView.heightAnchor.constraint(equalToConstant: 75),
      //      mainImageView.heightAnchor.constraint(equalToConstant: 250),
           // tableView.frame.width / imageRatio
           
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
            ]
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint.isActive = false
        leadingConstraintOfImageView = imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraintOfImageView.isActive = false
        
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint.isActive = true
        trailingConstraintOfImageView = imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraintOfImageView.isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
