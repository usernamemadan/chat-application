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

//public extension UIAlertController {
//    func show() {
//        let win = UIWindow(frame: UIScreen.main.bounds)
//        let vc = UIViewController()
//        vc.view.backgroundColor = .clear
//        win.rootViewController = vc
//        win.windowLevel = UIWindow.Level.alert + 1  // Swift 3-4: UIWindowLevelAlert + 1
//        win.makeKeyAndVisible()
//        vc.present(self, animated: true, completion: nil)
//    }
//}
