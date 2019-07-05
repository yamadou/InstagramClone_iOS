//
//  CommentInputAccessoryView.swift
//  InstagramFirebase
//
//  Created by Yamadou Traore on 4/5/19.
//  Copyright © 2019 yamadou. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didSubmit(comment: String)
}

class CommentInputAccessoryView: UIView {
    
    var delegate: CommentInputAccessoryViewDelegate?
    
    let submitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Submit", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return btn
    }()
    
    let commentTextView: CommentInputTextView = {
        let tv = CommentInputTextView()
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    func clearCommentTextField() {
        commentTextView.text = nil
        commentTextView.showPlaceholderLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        
        backgroundColor = UIColor.white
        
        addSubview(submitButton)
        submitButton.anchor(top: topAnchor,
                            left: nil,
                            bottom: safeAreaLayoutGuide.bottomAnchor,
                            right: rightAnchor,
                            paddingTop: 0,
                            paddingLeft: 0,
                            paddingBottom: 0,
                            paddingRight: 12,
                            width: 60,
                            height: 0)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor,
                                left: leftAnchor,
                                bottom: safeAreaLayoutGuide.bottomAnchor,
                                right: submitButton.leftAnchor,
                                paddingTop: 8,
                                paddingLeft: 0,
                                paddingBottom: -8,
                                paddingRight: 0,
                                width: 0,
                                height: 0)
        
        setupLineSeparatorView()
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero // let the OS determine the size of the container view
    }
    
    fileprivate func setupLineSeparatorView() {
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: topAnchor,
                                 left: leftAnchor,
                                 bottom: nil,
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
    
    @objc func handleSubmit() {
        guard let comment = commentTextView.text, !comment.isEmpty else { return }
        delegate?.didSubmit(comment: comment)
        clearCommentTextField()
    }
}
