//
//  UserProfileCell.swift
//  InstagramFirebase
//
//  Created by Yamadou Traore on 3/11/19.
//  Copyright © 2019 yamadou. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            
            photoImageView.loadImage(urlString: imageUrl)
        }
    }
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = UIColor.lightGray.withAlphaComponent(0.20)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor,
                              left: leftAnchor,
                              bottom: bottomAnchor,
                              right: rightAnchor,
                              paddingTop: 0,
                              paddingLeft: 0,
                              paddingBottom: 0,
                              paddingRight: 0,
                              width: 0,
                              height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
