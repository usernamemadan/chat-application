//
//  MessageCellTableViewCell.swift
//  CustomCell
//
//  Created by Madan AR on 18/11/21.
//

import UIKit
import FirebaseAuth

class MessageCell: UITableViewCell {
    
    let messageLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let fromLabel: UILabel = {
        var label = UILabel()
        label.text = "   "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .systemPurple
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
    
    
    var chatMessage: Message? {
        didSet {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let isIncoming = uid != chatMessage?.fromId
            
            bubbleBackgroundView.backgroundColor = isIncoming ? .systemTeal : .darkGray
            messageLabel.textColor = isIncoming ? .black : .white
            messageLabel.text = chatMessage?.text
            
            if isIncoming {
                trailingConstraint.isActive = false
                leadingConstraint.isActive = true
                DatabaseManager.shared.fetchUser(uid: chatMessage!.fromId) { user in
                    DispatchQueue.main.async {
                        self.fromLabel.text = user.firstName
                    }
                }
            }
            else {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
                
                DispatchQueue.main.async {
                    self.fromLabel.text = ""
                }
            }
        }
    }
    

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        configureMessageCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureMessageCell(){
    
        addSubview(bubbleBackgroundView)
        addSubview(fromLabel)
        addSubview(messageLabel)
        
        let constraints = [
            
            fromLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            fromLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            fromLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 32),
            
            messageLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor, constant: 0),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: fromLabel.topAnchor, constant: -16),
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
