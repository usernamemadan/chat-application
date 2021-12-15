//
//  File.swift
//  CustomCell
//
//  Created by Madan AR on 11/11/21.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        
        font = UIFont.systemFont(ofSize: 16)
        textColor = .white
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.colors.WALightGray2]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
