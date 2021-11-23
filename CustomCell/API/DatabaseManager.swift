//
//  DatabaseManager.swift
//  CustomCell
//
//  Created by Madan AR on 17/11/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


struct DatabaseManager {
    static let shared = DatabaseManager()
    let db = Firestore.firestore()
    
    public func insertUser(with user: User) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).setData(user.dictionary)
    }
    
    func addMessage(with message: Message) {
        db.collection("messages").addDocument(data: message.dictionary)
    }
    
    
    func getMessages(messageId: String, completion:@escaping([Message]) -> Void){
        var messages: [Message] = []
        db.collection("messages").whereField("msgId", isEqualTo: messageId).order(by: "timestamp").addSnapshotListener { snapshot, error in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
           
            snapshot.documentChanges.forEach { change in
            
                if change.type == .added{
                    let documentData = change.document.data()
                    let values = ["msgId": documentData["msgId"], "fromId": documentData["fromId"], "toId": documentData["toId"], "text": documentData["text"],"timestamp": documentData["timestamp"] as! Timestamp] as [String : Any]
                    let message = Message(dictionary: values)
                    messages.append(message)
                    completion(messages)
                }
            }
        }
    }
    
}



