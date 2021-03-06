//
//  UserInfoCell.swift
//  CustomCell
//
//  Created by Madan AR on 17/11/21.
//

import UIKit

class UserInfoCell: UICollectionViewCell {
    
    static let reuseIdentifier = "userCell"
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.white.cgColor
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
    
    let checkBox = CheckBox()
    var profileImagePadding = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.clipsToBounds = true
        
        configureCheckBox()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CGFloat(profileImagePadding)).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -50).isActive = true
    }
    
    func configureCheckBox(){
        contentView.addSubview(checkBox)
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 50).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setup(user: User){
        nameLabel.text = user.firstName + " " + user.lastName
        let profileImageUrl = user.profileImageUrl
         NetworkManager.shared.downloadImage(fromURL: profileImageUrl) { image in
             if image != nil {
                 DispatchQueue.main.async {
                     self.profileImageView.image = image
                 }
             }
         }
        
    }
    
}
