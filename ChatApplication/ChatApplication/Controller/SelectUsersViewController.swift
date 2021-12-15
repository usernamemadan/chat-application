//
//  SelectContactsViewController.swift
//  CustomCell
//
//  Created by Madan AR on 17/11/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

protocol createGroupDelegate: AnyObject{
    func createGroup(usersId: String, selectedUsers: [User])
}

class SelectUsersViewController: UIViewController {
    var users: [User] = []
    var tempUsers: [User] = []
    var collectionView: UICollectionView!
    var searchbar = UISearchBar()
    var showCheckBox = false
    weak var delgate: createGroupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        
        configureSearchbar()
        configureUICollectionView()
        
        if showCheckBox {
            configureNavigationBarButton()
        }
        
        getData()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.invalidateLayout()
    }
    
    func getData() {
        DatabaseManager.shared.getAllUsers { users in
            self.users = users
            self.tempUsers = users
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func configureNavigationBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(contactsSelected))
    }
    
    func configureUICollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout() )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: searchbar.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionView.backgroundColor = .colors.WAGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserInfoCell.self, forCellWithReuseIdentifier: UserInfoCell.reuseIdentifier)
    }
    
    func configureSearchbar() {
        searchbar.searchBarStyle = UISearchBar.Style.default
        searchbar.placeholder = " Search..."
        searchbar.isTranslucent = false
        searchbar.delegate = self
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        searchbar.backgroundColor = .black
        
        view.addSubview(searchbar)
        searchbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchbar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchbar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchbar.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }
    
    func getSelectedContacts() -> (String, [User]) {
        var usersId = ""
        var selectedUsers: [User] = []
        for row in 0..<collectionView.numberOfItems(inSection: 0){
            let indexPath = NSIndexPath(row:row, section:0)
            let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! UserInfoCell
            
            if cell.checkBox.isChecked == true {
                let user = users[indexPath.row]
                selectedUsers.append(user)
                usersId += user.uid
            }
        }
        return (usersId, selectedUsers)
    }
    
    
    @objc func contactsSelected() {
        let (usersId, selectedUsers) = getSelectedContacts()
        delgate?.createGroup(usersId: usersId, selectedUsers: selectedUsers)
    }
 
}

extension SelectUsersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserInfoCell.reuseIdentifier, for: indexPath) as! UserInfoCell
        cell.setup(user: users[indexPath.row])
        
        if showCheckBox{
            cell.profileImagePadding = 55
            cell.checkBox.isHidden = false
        }
        else{
            cell.profileImagePadding = 5
            cell.checkBox.isHidden = true
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ChatController()
        vc.user = users[indexPath.row]
        
        var vcArray = self.navigationController?.viewControllers
        vcArray!.removeLast()
        vcArray!.append(vc)
        self.navigationController?.setViewControllers(vcArray!, animated: false)
        
    }
}

extension SelectUsersViewController: UICollectionViewDelegateFlowLayout {
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

extension SelectUsersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        users = []
        if searchText == "" {
            users = tempUsers
        }
        else{
            for user in tempUsers{
                if user.firstName.lowercased().contains(searchText.lowercased()){
                    users.append(user)
                }
            }
        }
        self.collectionView.reloadData()
    }
    
}
