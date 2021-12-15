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
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func SignUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func logUserOut() throws {
        try Auth.auth().signOut()
    }
    
    func uploadImage(image: UIImage, path: String, completion: @escaping (String) -> Void) {
        guard let imageData = image.pngData() else { return }
        let uuid = NSUUID().uuidString
            
        Storage.storage().reference().child(path).child(uuid).putData(imageData, metadata: nil) { _, error in
            guard error == nil else { return }
            
            Storage.storage().reference().child(path).child(uuid).downloadURL { url, error in
                guard let url = url, error == nil else { return }
                let urlString = url.absoluteString
                completion(urlString)
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

