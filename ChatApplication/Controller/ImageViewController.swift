//
//  ImageViewController.swift
//  CustomCell
//
//  Created by Madan AR on 29/11/21.
//

import UIKit



class ImageViewController: UIViewController {

    let imageView = UIImageView()
    let size: CGFloat = 400
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureImageView()
        addGesture()
    }
    
    func configureImageView(){
        view.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        imageView.backgroundColor = .red
        imageView.center = view.center
    }
    
    func addGesture(){
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        imageView.addGestureRecognizer(pinchGesture)
        imageView.isUserInteractionEnabled = true
    }

    @objc func didPinch(_ gesture: UIPinchGestureRecognizer){
        if gesture.state == .changed{
            let scale = gesture.scale
            print(scale)
            imageView.frame = CGRect(x: 0, y: 0, width: size * scale, height: size * scale)
            imageView.center = view.center
        }
    }
}


