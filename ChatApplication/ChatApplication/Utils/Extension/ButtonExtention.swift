//
//  ButtonAnimationExtention.swift
//  ChatApplication
//
//  Created by Madan AR on 09/12/21.
//

import UIKit

extension UIButton {
    func pulse() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1
        layer.add(pulse, forKey: nil)
    }
    
    func flash(){
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        layer.add(flash, forKey: nil)
    }
    
    func shake(){
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let formPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: formPoint)
        shake.fromValue = fromValue
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        shake.toValue = toValue
        layer.add(shake, forKey: nil)
    }
}
