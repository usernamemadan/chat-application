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
    var collecionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureUICollectionView()
        fetchUsers()
    }
    
    func configureUICollectionView(){
        collecionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collecionView)
        collecionView.backgroundColor = .systemGray
        collecionView.delegate = self
        collecionView.dataSource = self
        collecionView.register(UserInfoCell.self, forCellWithReuseIdentifier: UserInfoCell.reuseIdentifier)
    }
    

    func fetchUsers(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").whereField("uid", isNotEqualTo: uid).getDocuments { snapshot, error in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
        
            for document in snapshot.documents{
                let documentData = document.data()
                let values = ["uid": documentData["uid"], "first_name": documentData["first_name"], "last_name": documentData["last_name"], "email": documentData["email"], "profile_image_url": documentData["profile_image_url"], "timestamp": documentData["timestamp"] as! Timestamp] as [String : Any]
                
                let user = User(dictionary: values)
                self.users.append(user)
                DispatchQueue.main.async {
                    self.collecionView.reloadData()
                }
            }
        }
        
//        Database.database().reference().child("users").observe(.childAdded) { snapshot in
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                let user = User(dictionary: dictionary)
//                self.users.append(user)
//                DispatchQueue.main.async {
//                    self.collecionView.reloadData()
//                }
//            }
//        } withCancel: { error in
//            print(error.localizedDescription)
//        }
       
    }
}

extension SelectContactsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collecionView.dequeueReusableCell(withReuseIdentifier: UserInfoCell.reuseIdentifier, for: indexPath) as! UserInfoCell

        cell.setup(user: users[indexPath.row])
        cell.backgroundColor = .darkGray
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ChatController()
        vc.user = users[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
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
