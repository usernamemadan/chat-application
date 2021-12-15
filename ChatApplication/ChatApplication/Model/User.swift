//
//  ChatAppUser.swift
//  CustomCell
//
//  Created by Madan AR on 17/11/21.
//

import Foundation
import Firebase


class User: NSObject {
    var uid: String
    var firstName: String
    var lastName: String
    var email: String
    var profileImageUrl: String
    var timestamp: Timestamp!
    var isGroup: Bool
    var recentMessage: Message?
    
    init(dictionary: [AnyHashable: Any]) {
        self.uid = dictionary["uid"] as! String
        self.firstName = dictionary["first_name"] as! String
        self.lastName = dictionary["last_name"] as! String
        self.email = dictionary["email"] as! String
        self.profileImageUrl = dictionary["profile_image_url"] as! String
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isGroup = dictionary["isGroup"] as! Bool
    }
    
    var dictionary: [String: Any] {
        return[
            "uid": uid,
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "profile_image_url": profileImageUrl,
            "timestamp": timestamp!,
            "isGroup": isGroup
        ]
    }
}
