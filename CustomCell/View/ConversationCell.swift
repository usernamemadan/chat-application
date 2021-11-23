//
//  ConversationCell.swift
//  CustomCell
//
//  Created by Madan AR on 09/11/21.
//

import UIKit



class ConversationCell: UICollectionViewCell {
    static let reuseIdentifier = "Cell"
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.borderColor = UIColor.white.cgColor
        iv.image = UIImage(systemName: "person.fill")
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "full name"
      //  label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "this is the sample message"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "9:30"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checkBox = CheckBox()
    var profilePadding = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        profileImageView.layer.cornerRadius = 35
        contentView.clipsToBounds = true
        configureCheckBox()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    func configureCheckBox(){
        contentView.addSubview(checkBox)
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 50).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()

        profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CGFloat(profilePadding)).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -50).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        

//        let stack = UIStackView(arrangedSubviews: [nameLabel, messageLabel])
//        stack.axis = .vertical
//        stack.spacing = 4
//        addSubview(stack)
//        stack.translatesAutoresizingMaskIntoConstraints = false
        
 //      stack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
 //      stack.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
//        stack.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10).isActive = true
//        stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10).isActive = true
//        stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10).isActive = true
//
//        stack.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
//        stack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10).isActive = true
    }

    
    
}


