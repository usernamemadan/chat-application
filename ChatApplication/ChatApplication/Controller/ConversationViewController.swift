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
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var recentMessages: [Message] = []
    var recentUsers: [User] = []
    var profilePadding = 0
    var showCheckBox = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ChatApp"
        view.backgroundColor = .white
  //      logout()
        isLoggedIn()
    }
 
    
    override func viewDidAppear(_ animated: Bool) {
        DatabaseManager.shared.getRecentMessages { recentMessages in
            self.recentMessages = recentMessages

            DispatchQueue.main.async {
                self.collecionView.reloadData()
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        listenerRef?.remove()
    }
    
    //MARK: - actions
    @objc func logout(){
        showAlert(error: "Do you want to logout?")
    }
    
    @objc func selectContactTapped(){
        let VC = SelectContactsViewController()
        VC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func editTapped(){
        showCheckBox = !showCheckBox
        DispatchQueue.main.async {
            self.viewDidLoad()
        }
    }
    
    // MARK: - helper functions
   
    func configureActivityIndicator(){
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
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
        let addGroup = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createGroup))
        navigationItem.rightBarButtonItems = [edit, add, addGroup]
    }
    
    func configureUICollectionView(){
        collecionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collecionView)
        collecionView.backgroundColor = .darkGray
        collecionView.delegate = self
        collecionView.dataSource = self
        collecionView.register(ConversationCell.self, forCellWithReuseIdentifier: ConversationCell.reuseIdentifier)
        collecionView.allowsMultipleSelection = true
    }
    
    func configureUI(){
        configureNavigationBar()
        configureUICollectionView()
    }
    
    func isLoggedIn(){
        configureActivityIndicator()
        if Auth.auth().currentUser?.uid == nil {
            activityIndicator.stopAnimating()
            presentLoginScreen()
        }
        else {
            activityIndicator.stopAnimating()
            configureUI()
        }
    }
    
    @objc func createGroup(){
        let vc = CreateGroupController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setup(user: User, message: Message, indexPath: IndexPath){
        let cell = self.collecionView.cellForItem(at: indexPath) as! ConversationCell
        cell.nameLabel.text = user.firstName + " " + user.lastName
        cell.messageLabel.text = message.text
    
        let date = message.timestamp.dateValue()
        let time = Date().days(from: date) > 0 ? date.getFormattedDate(format: "MM/dd/yyyy") : date.getFormattedDate(format: "HH:mm")
        cell.timeLabel.text = time
        
        cell.profileImageView.image = UIImage(systemName: "person.fill")
        NetworkManager.shared.downloadImage(fromURL: user.profileImageUrl) { image in
             if image != nil {
                 DispatchQueue.main.async {
                     cell.profileImageView.image = image
                 }
             }
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
        let logout = UIAlertAction(title: "Logout", style: .default, handler: { (action) -> Void in
            do{
                try Auth.auth().signOut();
                
            } catch let logoutError {
                print(logoutError)
            }
            self.presentLoginScreen()
         })
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        dialogMessage.addAction(logout)
        dialogMessage.addAction(cancel)
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
        return recentMessages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collecionView.dequeueReusableCell(withReuseIdentifier: ConversationCell.reuseIdentifier, for: indexPath) as! ConversationCell
        cell.backgroundColor = .darkGray
        cell.delegate = self
        
        DatabaseManager.shared.fetchUser(withMessage: recentMessages[indexPath.row]) { user in
            self.setup(user: user, message: self.recentMessages[indexPath.row], indexPath: indexPath)
        }

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DatabaseManager.shared.fetchUser(withMessage: recentMessages[indexPath.row]) { user in
            let vc = ChatController()
            vc.user = user
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension ConversationViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
}


extension ConversationViewController: presentImageDelegate{
    func presentImage(image: UIImage) {
        let vc = ImageViewController()
        vc.imageView.image = image
        navigationController?.pushViewController(vc, animated: true)
    }
}

