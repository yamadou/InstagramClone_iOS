//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Yamadou Traore on 3/5/19.
//  Copyright © 2019 yamadou. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeader: UICollectionViewCell {
    
    var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            
            usernameLabel.text = user?.username
            
            setupEditFollowButton()
        }
    }
    
    fileprivate func setupEditFollowButton() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            editProfileFollowButton.setTitle("Edit", for: .normal)
        } else {
            
            // check if following
            let ref =  Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                } else {
                    self.setupFollowStyle()
                }
                
            }) { (err) in
                print("Failed to check if following:", err)
            }
        }
    }
    
    @objc func handleEditProfileOrFollow() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        guard let userId = user?.uid else { return }
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
           // unfollow
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue { (err, ref) in
                if let err = err {
                    print("Falied to unfollow user:", err)
                    return
                }
                
                print("Successfully unfollowed user:", self.user?.username ?? "")
                
                self.setupFollowStyle()
            }
            
        } else {
            // follow
             let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
            
            let values = [userId: 1]
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to follow user:", err)
                    return
                }
                
                print("Successfully followed user: ", self.user?.username ?? "")
                
                self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                self.editProfileFollowButton.backgroundColor = UIColor.white
                self.editProfileFollowButton.setTitleColor(UIColor.black, for: .normal)
            }
        }
    }
    
    fileprivate func setupFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        self.editProfileFollowButton.setTitleColor(UIColor.white, for: .normal)
        self.editProfileFollowButton.layer.borderColor = UIColor.init(white: 0, alpha: 0.2).cgColor
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        return iv
    }()
    
    lazy var gridButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "grid"), for: .normal)
        btn.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleChangeToGridView() {
        gridButton.tintColor = UIColor.mainBlue
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToGridView()
    }
    
    lazy var listButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "list"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        btn.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleChangeToListView() {
        listButton.tintColor = UIColor.mainBlue
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToListView()
    }
    
    let bookmarkButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "ribbon"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Edit Profile", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 3
        btn.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor,
                                left: self.leftAnchor,
                                bottom: nil,
                                right: nil,
                                paddingTop: 12,
                                paddingLeft: 12,
                                paddingBottom: 0,
                                paddingRight: 0,
                                width: 80,
                                height: 80)
        
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        
        setupBottomToolbar()
        
        self.addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor,
                             left: self.leftAnchor,
                             bottom: gridButton.topAnchor,
                             right: self.rightAnchor,
                             paddingTop: 4,
                             paddingLeft: 12,
                             paddingBottom: 0,
                             paddingRight: 12,
                             width: 0,
                             height: 0)
        
        setupUserStatsView()
        
        self.addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postLabel.bottomAnchor,
                                 left: postLabel.leftAnchor,
                                 bottom: nil,
                                 right: followingLabel.rightAnchor,
                                 paddingTop: 2,
                                 paddingLeft: 0,
                                 paddingBottom: 0,
                                 paddingRight: 0,
                                 width: 0,
                                 height: 34)
    }
    
    fileprivate func setupUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        
        stackView.distribution = .fillEqually
        
        self.addSubview(stackView)
        stackView.anchor(top: self.topAnchor,
                         left: profileImageView.rightAnchor,
                         bottom: nil,
                         right: self.rightAnchor,
                         paddingTop: 12,
                         paddingLeft: 12,
                         paddingBottom: 0,
                         paddingRight: 12,
                         width: 0,
                         height: 50)
    }
    
    fileprivate func setupBottomToolbar() {
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        self.addSubview(stackView)
        self.addSubview(topDividerView)
        self.addSubview(bottomDividerView)
        
        stackView.anchor(top: nil,
                         left: self.leftAnchor,
                         bottom: self.bottomAnchor,
                         right: self.rightAnchor,
                         paddingTop: 0,
                         paddingLeft: 0,
                         paddingBottom: 0,
                         paddingRight: 0,
                         width: 0,
                         height: 50)
        
        topDividerView.anchor(top: stackView.topAnchor,
                              left: self.leftAnchor,
                              bottom: nil,
                              right: self.rightAnchor,
                              paddingTop: 0,
                              paddingLeft: 0,
                              paddingBottom: 0,
                              paddingRight: 0,
                              width: 0,
                              height: 0.5)
        
        bottomDividerView.anchor(top: stackView.bottomAnchor,
                              left: self.leftAnchor,
                              bottom: nil,
                              right: self.rightAnchor,
                              paddingTop: 0,
                              paddingLeft: 0,
                              paddingBottom: 0,
                              paddingRight: 0,
                              width: 0,
                              height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
