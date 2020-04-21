//
//  message.swift
//  grocery-go
//
//  Created by Basil Arif on 2020-04-21.
//  Copyright © 2020 Basil Arif. All rights reserved.
//

import Firebase
import MessageKit
import FirebaseFirestore

struct message: MessageType {
    
    let id: String?
    let content: String
    let sentDate: Date
    let sender: SenderType
    
    var kind: MessageKind {
//        if let image = image {
//            return .photo(image)
//        } else {
//            return .text(content)
//        }
        return .text(content)
    }
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var image: UIImage? = nil
    var downloadURL: URL? = nil
    
    init(user: User, content: String) {
        sender = Sender(id: user.uid, displayName: "Basil")
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init(user: User, image: UIImage) {
        sender = Sender(id: user.uid, displayName: "Basil")
        self.image = image
        content = ""
        sentDate = Date()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let sentDate = data["created"] as? Date else {
            return nil
        }
        guard let senderID = data["senderID"] as? String else {
            return nil
        }
        guard let senderName = data["senderName"] as? String else {
            return nil
        }
        
        id = document.documentID
        
        self.sentDate = sentDate
        sender = Sender(id: senderID, displayName: senderName)
        
        if let content = data["content"] as? String {
            self.content = content
            downloadURL = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            content = ""
        } else {
            return nil
        }
    }
    
}

extension message: dataBaseRepresentation {
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "created": sentDate,
            "senderID": sender.senderId,
            "senderName": sender.displayName
        ]
        
        if let url = downloadURL {
            rep["url"] = url.absoluteString
        } else {
            rep["content"] = content
        }
        
        return rep
    }
    
}

extension message: Comparable {
    
    static func == (lhs: message, rhs: message) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: message, rhs: message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}

