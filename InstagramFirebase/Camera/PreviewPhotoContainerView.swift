//
//  PreviewPhotoContainerView.swift
//  InstagramFirebase
//
//  Created by Yamadou Traore on 3/20/19.
//  Copyright © 2019 yamadou. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "cancel_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleCancel() {
        self.removeFromSuperview()
    }
    
    let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "save_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleSave() {
        guard let previewImage = previewImageView.image else { return }
        
        let library = PHPhotoLibrary.shared()
        
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success, err) in
            if let err = err {
                print("Failed to save image to photo library:", err)
                return
            }
            
            print("Successfully saved image to library")
            
            DispatchQueue.main.async {
                let savedLabel = UILabel()
                savedLabel.text = "Saved Successfully"
                savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                savedLabel.textAlignment = .center
                savedLabel.textColor = UIColor.white
                savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                
                self.addSubview(savedLabel)
                // when animating things in & out of the view using frame is easier
                savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                savedLabel.numberOfLines = 0
                savedLabel.center = self.center
                
                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    
                    savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    
                }, completion: { (completed) in
                    
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        
                        savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLabel.alpha = 0
                        
                    }, completion: { (_) in
                        
                        savedLabel.removeFromSuperview()
                    })
                })
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.yellow
        
        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor,
                                left: leftAnchor,
                                bottom: bottomAnchor,
                                right: rightAnchor,
                                paddingTop: 0,
                                paddingLeft: 0,
                                paddingBottom: 0,
                                paddingRight: 0,
                                width: 0,
                                height: 0)
        
        addSubview(cancelButton)
        cancelButton.anchor(top: topAnchor,
                            left: leftAnchor,
                            bottom: nil,
                            right: nil,
                            paddingTop: 12,
                            paddingLeft: 12,
                            paddingBottom: 0,
                            paddingRight: 0,
                            width: 50,
                            height: 50)
        
        addSubview(saveButton)
        saveButton.anchor(top: nil,
                          left: leftAnchor,
                          bottom: bottomAnchor,
                          right: nil,
                          paddingTop: 0,
                          paddingLeft: 24,
                          paddingBottom: -24,
                          paddingRight: 0,
                          width: 50,
                          height: 50)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
