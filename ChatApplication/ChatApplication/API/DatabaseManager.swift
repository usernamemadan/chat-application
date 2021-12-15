//
//  DatabaseManager.swift
//  CustomCell
//
//  Created by Madan AR on 17/11/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import UIKit

var listenerRef: ListenerRegistration?

struct DatabaseManager {
    static let shared = DatabaseManager()
    let db = Firestore.firestore()
    
    
    public func addUser(with user: User) {
        db.collection("users").document(user.uid).setData(user.dictionary)
    }
    
    
    func addMessage(with message: Message, currentUser: User, otherUser: User) {
        currentUser.timestamp = Timestamp(date: Date())
        otherUser.timestamp = Timestamp(date: Date())
        db.collection("messages").addDocument(data: message.dictionary)
        db.collection("users").document(currentUser.uid).collection("recent-users").document(otherUser.uid).setData(otherUser.dictionary)
        db.collection("users").document(otherUser.uid).collection("recent-users").document(currentUser.uid).setData(currentUser.dictionary)
        
        if message.isGroupMessage {
            getGroupMembers(groupId: otherUser.uid) { users in
                for user in users {
                    db.collection("users").document(user.uid).collection("recent-users").document(otherUser.uid).setData(otherUser.dictionary)
                    db.collection("users").document(otherUser.uid).collection("recent-users").document(user.uid).setData(user.dictionary)
                }
            }
        }
    }
    
    func getGroupMembers(groupId: String, completion: @escaping([User]) -> Void) {
        db.collection("users").document(groupId).collection("recent-users").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            guard error == nil else { return }
            
            guard let snapshot = snapshot else { return }
            var groupMembers: [User] = []
            for document in snapshot.documents{
                let documentData = document.data()
                let user = User(dictionary: documentData)
                groupMembers.append(user)
            }
            completion(groupMembers)
        }
    }
    
    
    func addGroupUsers(group: User, users: [User]) {
        for user in users {
            db.collection("users").document(user.uid).collection("recent-users").document(group.uid).setData(group.dictionary)
            db.collection("users").document(group.uid).collection("recent-users").document(user.uid).setData(user.dictionary)
        }
    }
    
    func fetchMessages(messageId: String, completion: @escaping([Message]) -> Void) {
        var messages: [Message] = []
        db.collection("messages").whereField("msgId", isEqualTo: messageId).order(by: "timestamp").addSnapshotListener { snapshot, error in
           
            
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
            
            snapshot.documentChanges.forEach({ change in
                if change.type == .added{
                    let documentData = change.document.data()
                    let message = Message(dictionary: documentData)
                    messages.append(message)
                }
            })
                    
            completion(messages)
        }
    }
    
    
    func getConversations(messageId: String, completion: @escaping([Message]) -> Void){
        fetchMessages(messageId: messageId) { messages in
            for message in messages {
                DatabaseManager.shared.fetchUser(uid: message.fromId) { user in
                    message.sender = user
                    completion(messages)
                }
            }
        }
    }
    
    
    func getRecentConversations(completion: @escaping([User]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        listenerRef = db.collection("users").document(uid).collection("recent-users").order(by: "timestamp", descending: true).addSnapshotListener { snapshot, error in
            if error != nil{
                return
            }
            
            guard let snapshot = snapshot else { return }
            var users: [User] = []
            for document in snapshot.documents{
                let documentData = document.data()
                let user = User(dictionary: documentData)
                users.append(user)
                fetchRecentMessage(for: user) { message in
                    user.recentMessage = message
                    completion(users)
                }
            }
        }
    }
    
    
    func getAllUsers(completion: @escaping([User]) -> Void){
        var users: [User] = []
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").whereField("isGroup", isEqualTo: false).whereField("uid", isNotEqualTo: uid).getDocuments { snapshot, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
            
            for document in snapshot.documents{
                let documentData = document.data()
                let user = User(dictionary: documentData)
                users.append(user)
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
    
    
    func computeMessageId(user: User) -> String {
        guard let uid = Auth.auth().currentUser?.uid else { return "" }
        if user.isGroup == true {
            return user.uid
        }
        
        let toId = user.uid
        return uid > toId ? uid+toId : toId+uid
    }
    
    
    func fetchRecentMessage(for user: User, completion: @escaping(Message?) -> Void) {
        let msgId = computeMessageId(user: user)
        
        db.collection("messages").whereField("msgId", isEqualTo: msgId).order(by: "timestamp", descending: true).limit(to: 1).getDocuments { snapshot, error in
            
            guard error == nil else { return }
            guard let snapshot = snapshot else { return }
            
            var message: Message?
            for document in snapshot.documents{
                let documentData = document.data()
                message = Message(dictionary: documentData)
            }
            completion(message)
        }
    }
    

}



