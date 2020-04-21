//
//  channel.swift
//  grocery-go
//
//  Created by Basil Arif on 2020-04-21.
//  Copyright © 2020 Basil Arif. All rights reserved.
//


import Firebase

struct channel {
    
    let id: String?
    let name: String
    
    init(name: String) {
        id = nil
        self.name = name
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let name = data["name"] as? String else {
            return nil
        }
        
        id = document.documentID
        self.name = name
    }
    
}

extension channel: dataBaseRepresentation {
    
    var representation: [String : Any] {
        var rep = ["name": name]
        
        if let id = id {
            rep["id"] = id
        }
        
        return rep
    }
    
}

extension channel: Comparable {
    
    static func == (lhs: channel, rhs: channel) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: channel, rhs: channel) -> Bool {
        return lhs.name < rhs.name
    }
    
}
