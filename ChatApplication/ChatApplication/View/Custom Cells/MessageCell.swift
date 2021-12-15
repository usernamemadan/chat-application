//
//  MessageCellTableViewCell.swift
//  CustomCell
//
//  Created by Madan AR on 18/11/21.
//

import UIKit
import FirebaseAuth

class MessageCell: UITableViewCell {
    
    static let messageCellIdentifier = "messageCell"
    
    let messageLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let fromLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .systemYellow
        return label
    }()
    
    let bubbleBackgroundView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
        
    var chatMessage: Message? {
        didSet {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let isIncoming = uid != chatMessage?.fromId
            
            bubbleBackgroundView.backgroundColor = isIncoming ? UIColor.colors.WALightGray : UIColor.colors.WAGreen
            messageLabel.text = chatMessage?.text
            
            if isIncoming {
                trailingConstraint.isActive = false
                leadingConstraint.isActive = true
                if chatMessage?.isGroupMessage == true{
                    fromLabel.text = chatMessage?.sender?.firstName
                }
            }
            else {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
                fromLabel.text = ""
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
            fromLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            fromLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 32),
            
            messageLabel.topAnchor.constraint(equalTo: fromLabel.bottomAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            messageLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: fromLabel.topAnchor, constant: -10),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -10),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 10),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        
    }
}
