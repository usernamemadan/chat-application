//
//  ImageCell.swift
//  ChatApplication
//
//  Created by Madan AR on 02/12/21.
//

import UIKit
import FirebaseAuth

class ImageCell: UITableViewCell {

        let bubbleBackgroundView: UIView = {
            var view = UIView()
            view.backgroundColor = .systemYellow
            view.layer.cornerRadius = 12
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    var leadingConstraintImage: NSLayoutConstraint!
    var trailingConstraintImage: NSLayoutConstraint!
    
        var chatImageView : UIImageView  = {
            var imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.clipsToBounds = true
            return imageView
        }()
    
    
        let messageLabel: UILabel = {
            var label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            return label
        }()
    
    var chatMessage: Message! {
        didSet {
          //  var isIncoming: Bool
            guard let uid = Auth.auth().currentUser?.uid else { return }
            var isIncoming = uid != chatMessage?.fromId
            bubbleBackgroundView.backgroundColor = isIncoming ? .systemTeal : .darkGray
            messageLabel.textColor = isIncoming ? .black : .systemTeal
            
         //   messageLabel.text = chatMessage.text
            
    
            if isIncoming {
                trailingConstraint.isActive = false
                trailingConstraintImage.isActive = false
                leadingConstraint.isActive = true
                leadingConstraintImage.isActive = true

            } else {
                leadingConstraint.isActive = false
                leadingConstraintImage.isActive = false
                trailingConstraint.isActive = true
                trailingConstraintImage.isActive = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
          configureImageView()
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureImageView(){
        addSubview(bubbleBackgroundView)
        addSubview(chatImageView)
        addSubview(messageLabel)

         let imageViewConstraints = [
            chatImageView.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            chatImageView.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: 0),
            chatImageView.widthAnchor.constraint(equalToConstant: 200),
            chatImageView.heightAnchor.constraint(equalToConstant: 200),


            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLabel.widthAnchor.constraint(equalToConstant: 200),
           


            bubbleBackgroundView.topAnchor.constraint(equalTo: chatImageView.topAnchor, constant: -16),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: chatImageView.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: chatImageView.trailingAnchor, constant: 16),

           
        ]

        NSLayoutConstraint.activate(imageViewConstraints)

        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint.isActive = false
        leadingConstraintImage = chatImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraintImage.isActive = false
        
        trailingConstraint = messageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -32)
        trailingConstraint.isActive = true
        trailingConstraintImage = chatImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -32)
        trailingConstraint.isActive = true

    }
}
