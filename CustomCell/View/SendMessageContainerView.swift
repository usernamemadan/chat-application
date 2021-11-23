//
//  SendMessageContainerView.swift
//  CustomCell
//
//  Created by Madan AR on 21/11/21.
//

import UIKit

class SendMessageContainerView: UIView {
    init(iv: UIImageView, textField: UITextField) {
        super.init(frame: .zero)
        tintColor = .black
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iv)
        
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iv.rightAnchor.constraint(equalTo: rightAnchor, constant: -15) .isActive = true
        iv.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: leftAnchor,constant: 10).isActive = true
        textField.rightAnchor.constraint(equalTo: iv.leftAnchor, constant: -10).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
