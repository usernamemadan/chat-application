//
//  Extension.swift
//  CustomCell
//
//  Created by Madan AR on 15/11/21.
//

import Foundation
import UIKit

extension String{
    func isValidEmail() -> Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: self)
    }
    
    
    func isValidPassword() -> Bool {
        // at least one uppercase
        // at least one digit
        // at least one lowercase
        // 6 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{6,}")
        return passwordTest.evaluate(with: self)
    }
}




