//
//  CustomContainerView.swift
//  CustomCell
//
//  Created by Madan AR on 11/11/21.
//

import Foundation
import UIKit

class CustomContainerView: UIView {
    init(image: UIImage, textField: UITextField) {
        super.init(frame: .zero)
        tintColor = .black
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 25
        
        let iv = UIImageView()
        addSubview(iv)
        iv.image = image
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iv.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 25).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: iv.rightAnchor,constant: 10).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
