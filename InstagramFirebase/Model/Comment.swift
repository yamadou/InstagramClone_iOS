//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Yamadou Traore on 3/22/19.
//  Copyright © 2019 yamadou. All rights reserved.
//

import UIKit
struct Comment {
    let user: User
    let text: String
    let uid: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
