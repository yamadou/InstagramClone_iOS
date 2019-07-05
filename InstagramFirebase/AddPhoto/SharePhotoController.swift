//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Yamadou Traore on 3/8/19.
//  Copyright © 2019 yamadou. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 42
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    fileprivate func setupImageAndTextView() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             left: self.view.leftAnchor,
                             bottom: nil,
                             right: self.view.rightAnchor,
                             paddingTop: 0,
                             paddingLeft: 0,
                             paddingBottom: 0,
                             paddingRight: 0,
                             width: 0,
                             height: 100)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor,
                         left: containerView.leftAnchor,
                         bottom: containerView.bottomAnchor,
                         right: nil,
                         paddingTop: 8,
                         paddingLeft: 8,
                         paddingBottom: -8,
                         paddingRight: 0,
                         width: 84,
                         height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor,
                        left: imageView.rightAnchor,
                        bottom: containerView.bottomAnchor,
                        right: containerView.rightAnchor,
                        paddingTop: 0,
                        paddingLeft: 4,
                        paddingBottom: 0,
                        paddingRight: 0,
                        width: 0,
                        height: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextView()
    }
    
    @objc func handleShare() {
        guard let caption = textView.text, !caption.isEmpty else { return }
        guard let image = selectedImage else { return }
        
        guard let uploadData = image.jpegData(compressionQuality: 0) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (meta, err) in
            
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
        
                print("falied to upload post image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to fetch downloadURL:", err)
                    return
                }
                
                guard let profileImageUrl = downloadURL?.absoluteString else { return }
                print("Successfully uploaded post image:", profileImageUrl)
                
                self.saveToDataBaseWithImageUrl(imageUrl: profileImageUrl)
            })
        }
    }
    
    static let updateFeedNotification = NSNotification.Name("UpdateFeed")
    
    fileprivate func saveToDataBaseWithImageUrl(imageUrl: String) {
        guard let postImage = selectedImage else { return }
        guard let caption = textView.text else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        
        let values: [String : Any] = ["imageUrl": imageUrl,
                                      "caption": caption,
                                      "imageWidth": postImage.size.width,
                                      "imageHeight": postImage.size.height,
                                      "creationDate": Date().timeIntervalSince1970]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB:", err)
                return
            }
            
            print("Successfully saved post to DB")
            self.dismiss(animated: true, completion: nil)
            

            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotification, object: nil)
        }
    }
}

