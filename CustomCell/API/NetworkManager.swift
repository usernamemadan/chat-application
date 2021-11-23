//
//  NetworkManager.swift
//  CustomCell
//
//  Created by Madan AR on 15/11/21.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseStorage

struct NetworkManager {
    static let shared = NetworkManager()
    
    let urlString = ""
    var uid: String? {
        get {
           return Auth.auth().currentUser?.uid
        }
    }
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func SignUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func uploadImage(imageData: Data, completion:@escaping(() -> Void)) {
        let uuid = NSUUID().uuidString
        Storage.storage().reference().child("Profile Images").child(uuid).putData(imageData, metadata: nil) { _, error in
            guard error == nil else { return }
            Storage.storage().reference().child("Profile Images").child(uuid).downloadURL { url, error in
                guard let url = url, error == nil else { return }
                let urlString = url.absoluteString
                UserDefaults.standard.set(urlString, forKey: "url")
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func downloadImage(fromURL urlString: String, completion: @escaping(UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            let image = UIImage(data: data)
            completion(image)
        }
        task.resume()
    }
    

    
}
