//
//  HomeFeedController.swift
//  InstagramFirebase
//
//  Created by Yamadou Traore on 3/12/19.
//  Copyright © 2019 yamadou. All rights reserved.
//

import UIKit
import Firebase

class HomeFeedController: UICollectionViewController {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotification, object: nil)
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        setupNavigationItems()
        
        fetchAllPosts()
    }
    
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            
            userIdsDictionary.forEach({ (key, value) in
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    self.fetchPostsWithUser(user: user)
                })
            })
            
        }) { (err) in
            print("Failed to fetch following user ids:", err)
        }
    }
    
    var posts = [Post]()
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { user in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView?.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                Database.database().reference().child("likes").child(key).child(uid).observe(.value, with: { (snapshot) in
                    
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    
                    self.collectionView?.reloadData()
                    
                }, withCancel: { (err) in
                    print("Failed to fetch like info for post.", err)
                })
            })
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc func handleCamera() {
        let cameraController = CameraController()
        self.present(cameraController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.delegate = self
        
        if posts.count > 0 {
            cell.post = posts[indexPath.item]
        }
        
        return cell
    }
}

extension HomeFeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8 // username userprofileimageview
        height += view.frame.width // photoImageView
        height += 50
        height += 60 // for the caption
        
        return CGSize(width: view.frame.width, height: height)
    }
    
}

extension HomeFeedController: HomePostCellDelegate {
    
    func didTapComment(post: Post) {
        
        let commentController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentController.post = post
        navigationController?.pushViewController(commentController, animated: true)
    }
    
    func didTapLike(for cell: HomePostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        var post = posts[indexPath.item]
        
        guard let postId = post.id else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = [uid: post.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (err, _) in
            if let err = err {
                print("Failed to like post:", err)
                return
            }
            
            print("Successfully liked post.")
            
            post.hasLiked.toggle()
            self.posts[indexPath.item] = post
            
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
}
