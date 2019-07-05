//
//  CommentController.swift
//  InstagramFirebase
//
//  Created by Yamadou Traore on 3/21/19.
//  Copyright © 2019 yamadou. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController {
    
    var post: Post?
    
    let cellId = "cellId"
    
    let commentTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter Comment"
        return textfield
    }()
    
    lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        
        collectionView.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        
//        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        
        fetchComments()
    }
    
    var comments = [Comment]()
    fileprivate func fetchComments() {
        guard let postId = self.post?.id else { return }
        
        let ref = Database.database().reference().child("comments").child(postId)
        
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            guard let uid = dictionary["uid"] as? String else { return }
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
            
                var comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
            
                self.collectionView?.reloadData()
            })
            
            
        }) { (err) in
            print(" Failed to observe comments")
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.resignFirstResponder()
        tabBarController?.tabBar.isHidden = false
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
}

// Mark: - UICollectionViewDataSource
extension CommentsController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        
        cell.comment = comments[indexPath.item]
        
        return cell
    }
}


// Mark: - UICollectionViewDelegate - UICollectionViewDelegateFlowLayout
extension CommentsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - CommentInputAccessoryViewDelegate
extension CommentsController: CommentInputAccessoryViewDelegate {
    func didSubmit(comment: String) {
        guard let postId = post?.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values: [String: Any] = [
            "text": comment,
            "creationDate": Date().timeIntervalSince1970,
            "uid": uid
        ]
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to insert comment:", err)
                return
            }
            
            self.commentTextField.text = ""
            print("Successfully inserted comment.")
        }
    }
}



