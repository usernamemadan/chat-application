//
//  CollectionViewController.swift
//  CustomCell
//
//  Created by Madan AR on 09/11/21.
//

import UIKit
import FirebaseAuth


class ConversationViewController: UIViewController {

    // MARK: - properties
    var collecionView: UICollectionView!
    let ai = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ChatApp"
        view.backgroundColor = .white
        self.isLoggedIn()
    }
    
    //MARK: - actions
    @objc func logout(){
        do{
            try Auth.auth().signOut();
            showAlert(error: "successfully logged out")
        } catch let logoutError {
            print(logoutError)
        }
       
    }
    
    @objc func selectContactTapped(){
        let VC = SelectContactsViewController()
        VC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(VC, animated: true)
    }
    
 
    var profilePadding = 0
    var showCheckBox = false
    
    @objc func editTapped(){
        
//        navigationController?.pushViewController(ChatController(), animated: true)
        
        showCheckBox = !showCheckBox
        DispatchQueue.main.async {
            self.viewDidLoad()
        }
    }
    
    // MARK: - helper functions
   
    
    
    func configureActivityIndicator(){
        ai.center = self.view.center
        ai.startAnimating()
        ai.hidesWhenStopped = true
        view.addSubview(ai)
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(selectContactTapped))
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        navigationItem.rightBarButtonItems = [edit, add]
    }
    
    
    func configureUICollectionView(){
        collecionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collecionView)
        collecionView.backgroundColor = .systemGreen
        collecionView.delegate = self
        collecionView.dataSource = self
        collecionView.register(ConversationCell.self, forCellWithReuseIdentifier: ConversationCell.reuseIdentifier)
    }
    
    func configureUI(){
        configureNavigationBar()
        configureUICollectionView()
    }
    
    func isLoggedIn(){
        configureActivityIndicator()
        if Auth.auth().currentUser?.uid == nil {
            ai.stopAnimating()
            presentLoginScreen()
        }
        else {
            ai.stopAnimating()
            configureUI()
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
    
    func showAlert(error: String) {
        let dialogMessage = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.presentLoginScreen()
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }

}

extension ConversationViewController: AuthenticationDelegate{
    func authenticationDidComplete() {
        configureUI()
    }
}

extension ConversationViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collecionView.dequeueReusableCell(withReuseIdentifier: ConversationCell.reuseIdentifier, for: indexPath) as! ConversationCell
        cell.backgroundColor = .darkGray

        if showCheckBox{
            cell.profilePadding = 55
            cell.checkBox.isHidden = false
        }
        else{
            cell.profilePadding = 5
            cell.checkBox.isHidden = true
        }
        return cell
    
    }
}

extension ConversationViewController: UICollectionViewDelegateFlowLayout{
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
