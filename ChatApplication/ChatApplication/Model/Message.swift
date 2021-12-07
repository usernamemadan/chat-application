//
//  Message.swift
//  CustomCell
//
//  Created by Madan AR on 21/11/21.
//

import Foundation
import Firebase


class Message: NSObject {
    var msgId: String
    var fromId: String
    var toId: String
    var text: String
    var timestamp: Timestamp!
    var imageUrl: String?
    var isGroupMessage: Bool
    var image: UIImage?
    
    init(dictionary: [AnyHashable: Any]) {
        self.msgId = dictionary["msgId"] as! String
        self.fromId = dictionary["fromId"] as! String
        self.toId = dictionary["toId"] as! String
        self.text = dictionary["text"] as! String
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.imageUrl = dictionary["imageUrl"] as? String
        self.isGroupMessage = dictionary["isGroupMessage"] as! Bool
    }
    
    var dictionary: [String: Any] {
        return[
            "msgId": msgId,
            "fromId": fromId,
            "toId": toId,
            "text": text,
            "timestamp": timestamp!,
            "imageUrl": imageUrl,
            "isGroupMessage": isGroupMessage
        ]
    }
}
