//
//  UserSearchCell.swift
//  InstagramFirebase
//
//  Created by Yamadou Traore on 3/13/19.
//  Copyright © 2019 yamadou. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            usernameLabel.text = user?.username
            
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(separatorView)
        
        profileImageView.anchor(top: nil,
                                left: leftAnchor,
                                bottom: nil,
                                right: nil,
                                paddingTop: 0,
                                paddingLeft: 8,
                                paddingBottom: 0,
                                paddingRight: 0,
                                width: 50,
                                height: 50)
        
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 25
        
        usernameLabel.anchor(top: topAnchor,
                             left: profileImageView.rightAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             paddingTop: 0,
                             paddingLeft: 8,
                             paddingBottom: 0,
                             paddingRight: 0,
                             width: 0,
                             height: 0)
        
        separatorView.anchor(top: nil,
                             left: usernameLabel.leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
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
