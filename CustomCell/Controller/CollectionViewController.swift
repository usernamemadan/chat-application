//
//  CollectionViewController.swift
//  CustomCell
//
//  Created by Madan AR on 09/11/21.
//

import UIKit
import FirebaseAuth


class CollectionViewController: UIViewController {

    var collecionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoggedIn()
        
        view.backgroundColor = .black
        self.title = "Whatsapp"
        
       
    }
    
    func configureNavigationBar() {
    
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .darkGray
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 38)!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = attributes
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
    }
    
    @objc func logout(){
        do{
            try Auth.auth().signOut();
            presentLoginScreen()
        } catch let logoutError {
            print(logoutError)
        }
       
    }
    
    
    func configureUICollectionView(){
        collecionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collecionView)
        collecionView.backgroundColor = .systemGreen
        collecionView.delegate = self
        collecionView.dataSource = self
        collecionView.register(ConversationCell.self, forCellWithReuseIdentifier: ConversationCell.reuseIdentifier)
    }
    
    func isLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
        }
        else {
            configureNavigationBar()
            configureUICollectionView()
        }
        
    }
    
    func presentLoginScreen(){
        DispatchQueue.main.async {
            let loginVC = LoginViewController()
            loginVC.delegate = self
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)
        }
    }


}
extension CollectionViewController: AuthenticationDelegate{
    func authenticationDidComplete() {
        print("inside authenticaion did complete*********")
        configureNavigationBar()
        configureUICollectionView()
    }
    
    
}



extension CollectionViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collecionView.dequeueReusableCell(withReuseIdentifier: ConversationCell.reuseIdentifier, for: indexPath)
        cell.backgroundColor = .darkGray
        return cell
    
    }
    
    
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

    extension UIButton {
        func attributedTitle(firstPart: String, secondPart: String) {
            let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)]
            
            let attributedTitle = NSMutableAttributedString(string: "\(firstPart)  ", attributes: atts)
            
            let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]

            attributedTitle.append(NSAttributedString(string: secondPart, attributes: boldAtts))
            
            setAttributedTitle(attributedTitle, for: .normal)
}
    }
