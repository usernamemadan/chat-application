//
//  ConversationCell.swift
//  CustomCell
//
//  Created by Madan AR on 09/11/21.
//

import UIKit

protocol presentImageDelegate: AnyObject{
    func presentImage(image: UIImage)
}

class ConversationCell: UICollectionViewCell {
    static let reuseIdentifier = "Cell"
    weak var delegate: presentImageDelegate?
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.image = UIImage(systemName: "person.fill")
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14.54)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checkBox = CheckBox()
    var profilePadding = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
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
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true
        
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -50).isActive = true
        
        
        messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        
        
        timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true

    }
    
    @objc func selectImage(){
        delegate?.presentImage(image: profileImageView.image!)
    }
    
}

