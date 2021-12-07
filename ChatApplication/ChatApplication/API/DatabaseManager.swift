//
//  DatabaseManager.swift
//  CustomCell
//
//  Created by Madan AR on 17/11/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

var listenerRef: ListenerRegistration?

struct DatabaseManager {
    static let shared = DatabaseManager()
    let db = Firestore.firestore()
    
    public func insertUser(with user: User) {
        db.collection("users").document(user.uid).setData(user.dictionary)
    }
    
    func addMessage(with message: Message) {
        db.collection("messages").addDocument(data: message.dictionary)
        db.collection("recent-messages").document(message.msgId).setData(message.dictionary)
    }
    
    func getMessages(messageId: String, completion: @escaping([Message]) -> Void) {
        var messages: [Message] = []
        db.collection("messages").whereField("msgId", isEqualTo: messageId).order(by: "timestamp").addSnapshotListener { snapshot, error in
            if error != nil{
                //use guard
                print(error!.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
            
            snapshot.documentChanges.forEach { change in
                
                if change.type == .added {
                   
                    let documentData = change.document.data()
                    let message = Message(dictionary: documentData)
                    DatabaseManager.shared.fetchUser(uid: message.fromId) { user in
                        message.sender = user
                        
                        guard let imageUrl = message.imageUrl else {
                            messages.append(message)
                            completion(messages)
                            return
                        }
                        
                        NetworkManager.shared.downloadImage(fromURL: imageUrl) { image in
                            if image != nil {
                                message.image = image
                                messages.append(message)
                                completion(messages)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getRecentMessages(completion: @escaping([Message]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        listenerRef = db.collection("recent-messages").order(by: "timestamp", descending: true).addSnapshotListener { snapshot, error in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
           
            guard let snapshot = snapshot else { return }
            var recentMessages: [Message] = []
          
            for document in snapshot.documents{
                let documentData = document.data()
                let message = Message(dictionary: documentData)
                if !message.msgId.contains(uid) { continue }
                recentMessages.append(message)
            }
            completion(recentMessages)
        }
    }
    
    func fetchUser(withMessage message: Message, completion:@escaping(User) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var otherUserId = ""
        
        if message.isGroupMessage{
            otherUserId = message.toId
        }
        else if message.fromId == uid {
            otherUserId = message.toId
        }
        else{
            otherUserId = message.fromId
        }

        db.collection("users").document(otherUserId).getDocument { snapshot, error in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
            guard let documentData = snapshot.data() else { return }
            
            let user = User(dictionary: documentData)
            completion(user)
        }
    }
    
    
    func fetchUsers(completion: @escaping([User]) -> Void){
        var users: [User] = []
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").whereField("uid", isNotEqualTo: uid).getDocuments { snapshot, error in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
        
            for document in snapshot.documents{
                let documentData = document.data()
                let user = User(dictionary: documentData)
                if !user.isGroup{
                    users.append(user)
                }

            }
            completion(users)
        }
    }
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void){
        db.collection("users").document(uid).getDocument { snapshot, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
            guard let documentData = snapshot.data() else { return }
            
            let user = User(dictionary: documentData)
            completion(user)
        }
    }
    
}



