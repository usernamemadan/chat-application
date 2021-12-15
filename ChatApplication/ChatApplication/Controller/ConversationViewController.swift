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
    var collectionView: UICollectionView!
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var recentUsers: [User] = []
    var profilePadding = 0
    var showCheckBox = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "chatApp"
        isLoggedIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DatabaseManager.shared.getRecentConversations { users in
            self.recentUsers = users
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        listenerRef?.remove()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.invalidateLayout()
    }
    
    
    //MARK: - actions
    @objc func logout() {
        showAlert(error: "Do you want to logout?")
    }
    
    @objc func selectContactTapped() {
        let VC = SelectUsersViewController()
        VC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func createGroup() {
        let vc = CreateGroupController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - helper functions
    
    func configureActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.colors.WALightGray
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = UIColor.colors.WALightGray2
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(selectContactTapped))
        let addGroup = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createGroup))
        navigationItem.rightBarButtonItems = [add, addGroup]
    }
    
    func configureUICollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionView.backgroundColor = UIColor.colors.WAGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ConversationCell.self, forCellWithReuseIdentifier: ConversationCell.reuseIdentifier)
    }
    
    func configureUI() {
        configureNavigationBar()
        configureUICollectionView()
    }
    
    func isLoggedIn() {
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
    
    
    func setup(user: User, message: Message?, indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ConversationCell
        cell?.nameLabel.text = user.firstName + " " + user.lastName
        
        cell?.profileImageView.image = UIImage(systemName: "person.fill")
        NetworkManager.shared.downloadImage(fromURL: user.profileImageUrl) { image in
            if image != nil {
                DispatchQueue.main.async {
                    cell?.profileImageView.image = image
                }
            }
        }
        
        guard let message = message else {
            cell?.messageLabel.text = " "
            cell?.timeLabel.text = " "
            return
        }
        
        cell?.messageLabel.text = message.text
        let date = message.timestamp.dateValue()
        let time = Date().calculateDays(from: date) > 0 ? date.getFormattedDate(format: "MM/dd/yyyy") : date.getFormattedDate(format: "HH:mm")
        cell?.timeLabel.text = time
    }
    
    
    func presentLoginScreen() {
        let loginVC = LoginViewController()
        loginVC.delegate = self
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func showAlert(error: String) {
        let dialogMessage = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
        let logout = UIAlertAction(title: "Logout", style: .default, handler: { (action) -> Void in
            do{
                try NetworkManager.shared.logUserOut()
            } catch let logoutError {
                print(logoutError)
            }
            
            DispatchQueue.main.async {
                self.presentLoginScreen()
            }
        })
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        dialogMessage.addAction(logout)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}


extension ConversationViewController: AuthenticationDelegate {
    func authenticationDidComplete() {
        configureUI()
    }
}


extension ConversationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConversationCell.reuseIdentifier, for: indexPath) as! ConversationCell
        cell.delegate = self
        let user = recentUsers[indexPath.row]
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.setup(user: user, message: user.recentMessage, indexPath: indexPath)
            }
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
        let chatVC = ChatController()
        chatVC.user = recentUsers[indexPath.row]
        navigationController?.pushViewController(chatVC, animated: true)
    }
}


extension ConversationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width , height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}


extension ConversationViewController: presentImageDelegate {
    func presentImage(image: UIImage) {
        let vc = ImageViewController()
        vc.imageView.image = image
        navigationController?.pushViewController(vc, animated: true)
    }
}

