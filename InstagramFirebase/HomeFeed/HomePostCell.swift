//
//  HomePostCell.swift
//  InstagramFirebase
//
//  Created by Yamadou Traore on 3/12/19.
//  Copyright © 2019 yamadou. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate {
    func didTapComment(post: Post)
    func didTapLike(for cell: HomePostCell)
}

class HomePostCell: UICollectionViewCell {
    
    var delegate: HomePostCellDelegate?
    
    var post: Post? {
        didSet {
            guard let postImageUrl = post?.imageUrl else { return }
            
            likeButton.setImage(post?.hasLiked == true
                ? UIImage(named: "like_selected")?.withRenderingMode(.alwaysOriginal)
                : UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
            photoImageView.loadImage(urlString: postImageUrl)
            
            userNameLabel.text = post?.user.username
            
            guard let profileImageUrl = post?.user.profileImageUrl else { return }
            userProfileImageView.loadImage(urlString: profileImageUrl)
            
            setupAttributedCaption()
        }
    }
    
    fileprivate func setupAttributedCaption() {
        guard let post = self.post else { return }
        
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        
        let timeAgoDisplay = post.creationDate.description
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        self.captionLabel.attributedText = attributedText
    }
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "John Doe"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let optionsButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("•••", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
    }()
    
    lazy var likeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleLike() {
        guard let post = post else { return }
        delegate?.didTapLike(for: self)
    }
    
    lazy var commentButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleComment() {
        guard let post = post else { return }
        delegate?.didTapComment(post: post)
    }
    
    let sendMessageButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let bookmarkButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(userProfileImageView)
        addSubview(photoImageView)
        addSubview(userNameLabel)
        addSubview(optionsButton)
        addSubview(captionLabel)
        
        userProfileImageView.anchor(top: topAnchor,
                                    left: leftAnchor,
                                    bottom: nil,
                                    right: nil,
                                    paddingTop: 8,
                                    paddingLeft: 8,
                                    paddingBottom: 0,
                                    paddingRight: 0,
                                    width: 40,
                                    height: 40)
        userProfileImageView.layer.cornerRadius = 20
        
        photoImageView.anchor(top: userProfileImageView.bottomAnchor,
                              left: leftAnchor,
                              bottom: nil,
                              right: rightAnchor,
                              paddingTop: 8,
                              paddingLeft: 0,
                              paddingBottom: 0,
                              paddingRight: 0,
                              width: 0,
                              height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        userNameLabel.anchor(top: topAnchor,
                             left: userProfileImageView.rightAnchor,
                             bottom: photoImageView.topAnchor,
                             right: optionsButton.leftAnchor,
                             paddingTop: 0,
                             paddingLeft: 8,
                             paddingBottom: 0,
                             paddingRight: 0,
                             width: 0,
                             height: 0)
        
        optionsButton.anchor(top: topAnchor,
                             left: nil,
                             bottom: photoImageView.topAnchor,
                             right: rightAnchor,
                             paddingTop: 0,
                             paddingLeft: 0,
                             paddingBottom: 0,
                             paddingRight: 0,
                             width: 50,
                             height: 50)
        
        setupActionButtons()
        
        captionLabel.anchor(top: likeButton.bottomAnchor,
                            left: leftAnchor,
                            bottom: bottomAnchor,
                            right: rightAnchor,
                            paddingTop: 0,
                            paddingLeft: 8,
                            paddingBottom: 0,
                            paddingRight: 8,
                            width: 0,
                            height: 0)
    }
    
    fileprivate func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
        
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: photoImageView.bottomAnchor,
                         left: leftAnchor,
                         bottom: nil,
                         right: nil,
                         paddingTop: 0,
                         paddingLeft: 4,
                         paddingBottom: 0,
                         paddingRight: 0,
                         width: 120,
                         height: 50)
        
        addSubview(bookmarkButton)
        bookmarkButton.anchor(top: photoImageView.bottomAnchor,
                              left: nil,
                              bottom: nil,
                              right: rightAnchor,
                              paddingTop: 0,
                              paddingLeft: 0,
                              paddingBottom: 0,
                              paddingRight: 0,
                              width: 40,
                              height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

