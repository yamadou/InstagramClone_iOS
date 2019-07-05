//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Yamadou Traore on 3/6/19.
//  Copyright © 2019 yamadou. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    let logoContainerView: UIView = {
        let view = UIView()
        
        let logoImageView = UIImageView(image: UIImage(named: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = UIColor.rgb(red: 140, green: 204, blue: 244)
        
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal)
        
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        btn.isEnabled = false
        
        return btn
    }()
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (data, err) in
            
            if let err = err {
                print("Failed to sign in with email:", err)
                return
            }
            
            print("Successfully logged back in with user:", data?.user.uid ?? "")
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            
            mainTabBarController.setupViewControllers()
            
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    let dontHaveAccountButton: UIButton = {
        let btn = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        
        attributedTitle.append(NSAttributedString(string: "Sign up",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
        
        btn.setAttributedTitle(attributedTitle, for: .normal)
        
        btn.addTarget(self, action: #selector(handleDontHaveAccount), for: .touchUpInside)
        return btn
    }()
    
    @objc  func handleDontHaveAccount() {
        let signUpController = SignUpViewController()
        navigationController?.pushViewController(signUpController, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: self.view.topAnchor,
                                 left: self.view.leftAnchor,
                                 bottom: nil,
                                 right: self.view.rightAnchor,
                                 paddingTop: 0,
                                 paddingLeft: 0,
                                 paddingBottom: 0,
                                 paddingRight: 0,
                                 width: 0,
                                 height: 150)
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil,
                            left: self.view.leftAnchor,
                            bottom: self.view.bottomAnchor,
                            right: self.view.rightAnchor,
                            paddingTop: 0,
                            paddingLeft: 0,
                            paddingBottom: 0,
                            paddingRight: 0,
                            width: 0,
                            height: 80)
        
        setupInputFields()
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor,
                         left: self.view.leftAnchor,
                         bottom: nil, right: self.view.rightAnchor,
                         paddingTop: 40,
                         paddingLeft: 40,
                         paddingBottom: 0,
                         paddingRight: 40,
                         width: 0,
                         height: 140)
    }
}
