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

class SelectContactsViewController: UIViewController {
    var users: [User] = []
    var tempUsers: [User] = []
    var collectionView: UICollectionView!
    var searchbar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureSearchbar()
        configureUICollectionView()
        
        DatabaseManager.shared.fetchUsers { users in
            self.users = users
            self.tempUsers = users
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    
    func configureUICollectionView(){
//        collecionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout() )
   //     collecionView.collectionViewLayout = UICollectionViewLayout()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: searchbar.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionView.backgroundColor = .darkGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserInfoCell.self, forCellWithReuseIdentifier: UserInfoCell.reuseIdentifier)
    }
    
    func configureSearchbar(){
        searchbar.searchBarStyle = UISearchBar.Style.default
        searchbar.placeholder = " Search..."
        searchbar.sizeToFit()
        searchbar.isTranslucent = false
        searchbar.backgroundImage = UIImage()
        searchbar.delegate = self
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchbar)
        searchbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchbar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchbar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchbar.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }
       
}

extension SelectContactsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserInfoCell.reuseIdentifier, for: indexPath) as! UserInfoCell

        cell.setup(user: users[indexPath.row])
        cell.backgroundColor = .darkGray
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

extension SelectContactsViewController: UICollectionViewDelegateFlowLayout{
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
extension SelectContactsViewController: UISearchBarDelegate{
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
