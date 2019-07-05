//
//  CommentCell.swift
//  InstagramFirebase
//
//  Created by Yamadou Traore on 3/22/19.
//  Copyright © 2019 yamadou. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            
            let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSAttributedString(string: " " + comment.text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14) ]))
            
            textView.attributedText = attributedText
            
            profileImageView.loadImage(urlString: comment.user.profileImageUrl)
        }
    }
    
    var textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isSelectable = false 
        tv.isScrollEnabled = false
        return tv
    }()
    
    var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = UIColor.lightGray
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 20
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: nil,
                                left: leftAnchor,
                                bottom: nil,
                                right: nil,
                                paddingTop: 0,
                                paddingLeft: 8,
                                paddingBottom: 0,
                                paddingRight: 0,
                                width: 40,
                                height: 40)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(textView)
        textView.anchor(top: topAnchor,
                            left: profileImageView.rightAnchor,
                            bottom: bottomAnchor,
                            right: rightAnchor,
                            paddingTop: 0,
                            paddingLeft: 8,
                            paddingBottom: 0,
                            paddingRight: 8,
                            width: 0,
                            height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
