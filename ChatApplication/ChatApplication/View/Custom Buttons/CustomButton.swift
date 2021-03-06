//
//  CustomButton.swift
//  CustomCell
//
//  Created by Madan AR on 14/11/21.
//

import UIKit

class CustomButton: UIButton {

    init(buttonText: String) {
        super.init(frame: .zero)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        self.setTitleColor(.white, for: .normal)
        self.setTitle(buttonText, for: .normal)
        backgroundColor = .colors.WALightGreen
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
