//
//  Post.swift
//  InstagramFirebase
//
//  Created by Yamadou Traore on 3/11/19.
//  Copyright © 2019 yamadou. All rights reserved.
//

import Foundation

struct Post {
    var id: String?
    
    let user: User
    let imageUrl: String
    let caption: String
    let creationDate: Date
    
    var hasLiked: Bool = false
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
