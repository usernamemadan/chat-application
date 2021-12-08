//
//  ImageCell.swift
//  ChatApplication
//
//  Created by Madan AR on 02/12/21.
//

import UIKit
import FirebaseAuth

class ImageCell: UITableViewCell {
    
    static let imageCellIdentifier = "ImageCell"
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    var leadingConstraintImage: NSLayoutConstraint!
    var trailingConstraintImage: NSLayoutConstraint!
    
    let bubbleBackgroundView: UIView = {
        var view = UIView()
        view.backgroundColor = .systemYellow
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let fromLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .systemYellow
        return label
    }()
    
    var chatImageView : UIImageView  = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let messageLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var chatMessage: Message? {
        didSet {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let isIncoming = uid != chatMessage?.fromId
            bubbleBackgroundView.backgroundColor = isIncoming ? .colors.WAGrayLight : .colors.WAGreen
            messageLabel.text = chatMessage?.text
            
            if isIncoming {
                trailingConstraint.isActive = false
                trailingConstraintImage.isActive = false
                leadingConstraint.isActive = true
                leadingConstraintImage.isActive = true
                
                fromLabel.text = chatMessage?.sender?.firstName
                
            } else {
                leadingConstraint.isActive = false
                leadingConstraintImage.isActive = false
                trailingConstraint.isActive = true
                trailingConstraintImage.isActive = true
                
                fromLabel.text = ""
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        configureImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImageView(){
        addSubview(bubbleBackgroundView)
        addSubview(fromLabel)
        addSubview(chatImageView)
        addSubview(messageLabel)
        
        let imageViewConstraints = [
            
            fromLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            fromLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            fromLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            fromLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 32),
            
            chatImageView.topAnchor.constraint(equalTo: fromLabel.bottomAnchor),
            chatImageView.bottomAnchor.constraint(equalTo: messageLabel.topAnchor),
            chatImageView.widthAnchor.constraint(equalToConstant: 200),
            chatImageView.heightAnchor.constraint(equalToConstant: 200),
            
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLabel.widthAnchor.constraint(equalToConstant: 200),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: fromLabel.topAnchor, constant: -6),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: chatImageView.leadingAnchor, constant: -6),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 6),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: chatImageView.trailingAnchor, constant: 6),
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
