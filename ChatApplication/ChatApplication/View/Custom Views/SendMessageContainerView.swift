//
//  SendMessageContainerView.swift
//  CustomCell
//
//  Created by Madan AR on 21/11/21.
//

import UIKit

class SendMessageContainerView: UIView {
    
    let bubbleBackgroundView: UIView = {
        var view = UIView()
        view.backgroundColor = .colors.WALightGray
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(imageview: UIImageView, photoButton: UIImageView, textField: UITextField) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 65))

        tintColor = .colors.WAGreen
        layer.cornerRadius = 25
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bubbleBackgroundView)
        
        addSubview(imageview)
        
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -5).isActive = true
        imageview.rightAnchor.constraint(equalTo: rightAnchor, constant: -15) .isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(photoButton)
        
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        photoButton.rightAnchor.constraint(equalTo: imageview.leftAnchor, constant: -15).isActive = true
        photoButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        photoButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -5).isActive = true
        photoButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -5).isActive = true
        textField.leftAnchor.constraint(equalTo: leftAnchor,constant: 15).isActive = true
        textField.rightAnchor.constraint(equalTo: photoButton.leftAnchor, constant: -10).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        bubbleBackgroundView.topAnchor.constraint(equalTo: textField.topAnchor, constant: -5).isActive = true
        bubbleBackgroundView.leftAnchor.constraint(equalTo: textField.leftAnchor, constant: -10).isActive = true
        bubbleBackgroundView.rightAnchor.constraint(equalTo: photoButton.rightAnchor, constant: 10).isActive = true
        bubbleBackgroundView.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 5).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width , height: 65)
    }

}
