//
//  SendMessageContainerView.swift
//  CustomCell
//
//  Created by Madan AR on 21/11/21.
//

import UIKit

class SendMessageContainerView: UIView {
    init(imageview: UIImageView, photoButton: UIImageView, textField: UITextField) {
        super.init(frame: .zero)
        tintColor = .black
    
   //     heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageview)
        
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageview.rightAnchor.constraint(equalTo: rightAnchor, constant: -15) .isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(photoButton)
        
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        photoButton.rightAnchor.constraint(equalTo: imageview.leftAnchor, constant: -15).isActive = true
        photoButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        photoButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        photoButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: leftAnchor,constant: 10).isActive = true
        textField.rightAnchor.constraint(equalTo: photoButton.leftAnchor, constant: -10).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
