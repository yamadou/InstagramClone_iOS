//
//  FirebaseUtils.swift
//  InstagramFirebase
//
//  Created by Yamadou Traore on 3/13/19.
//  Copyright © 2019 yamadou. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    static func fetchUserWithUID(uid: String, completion: @escaping(User) -> Void) {
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            
            let user = User(uid: uid, dictionary: userDictionary)
            
            completion(user)
            
        }) { (err) in
            print("Failed to fetch user for posts:", err)
        }
    }
}
