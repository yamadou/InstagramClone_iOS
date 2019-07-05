//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Yamadou Traore on 3/1/19.
//  Copyright © 2019 yamadou. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    let plusPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return btn
    }()
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
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
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && usernameTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    let signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign up", for: .normal)
        btn.backgroundColor = UIColor.rgb(red: 140, green: 204, blue: 244)
        
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal)
        
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        btn.isEnabled = false
        
        return btn
    }()
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, email.characters.count > 0 else { return }
        guard let username = usernameTextField.text, username.characters.count > 0 else { return }
        guard let password = passwordTextField.text, password.characters.count > 0 else { return }
    
        Auth.auth().createUser(withEmail: email, password: password, completion: { (data: AuthDataResult?, error: Error?) in
        
            if let err = error {
                print("Failed to create user:", err)
                return
            }
            print("Successfully created user:", data?.user.uid)
            
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            
            let filename = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            storageRef.putData(uploadData, metadata: nil, completion: {(metadata, err) in
                
                if let err = err {
                    print("Failed to upload profile image:", err)
                    return
                }
                
                storageRef.downloadURL(completion: { (downloadURL, err) in
                    if let err = err {
                        print("Failed to fetch downloadURL:", err)
                        return
                    }
                    
                    guard let profileImageUrl = downloadURL?.absoluteString else { return }
                    
                    print("Successfully uploaded profile image:", profileImageUrl)
                    
                    guard let uid = data?.user.uid else { return }
                    
                    let dictionaryValues = ["username": username, "profileImageUrl": downloadURL?.absoluteString]
                    let values = [uid: dictionaryValues]
                    
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print("Failed to save user info into db:", err)
                        }
                        
                        print("Successfully saved user info to db")
                        
                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                        
                        mainTabBarController.setupViewControllers()
                        
                        self.dismiss(animated: false, completion: nil)
                    })

                })
                
            })
        })
    }
    
    let alreadyHaveAccountButton: UIButton = {
        let btn = UIButton(type: .system)

        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])

        attributedTitle.append(NSAttributedString(string: "Login",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))

        btn.setAttributedTitle(attributedTitle, for: .normal)

        btn.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleAlreadyHaveAccount() {
        navigationController?.popViewController(animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(plusPhotoButton)
   
        plusPhotoButton.anchor(top: view.topAnchor,
                               left: nil,
                               bottom: nil,
                               right: nil,
                               paddingTop: 40,
                               paddingLeft: 0,
                               paddingBottom: 0,
                               paddingRight: 0,
                               width: 140,
                               height: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil,
                                     left: self.view.leftAnchor,
                                     bottom: self.view.bottomAnchor,
                                     right: self.view.rightAnchor,
                                     paddingTop: 0,
                                     paddingLeft: 0,
                                     paddingBottom: 0,
                                     paddingRight: 0,
                                     width: 0,
                                     height: 80)
    }
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,
                                                       usernameTextField,
                                                       passwordTextField,
                                                       signUpButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: nil,
                         right: view.rightAnchor,
                         paddingTop: 20,
                         paddingLeft: 40,
                         paddingBottom: 0,
                         paddingRight: 40,
                         width: 0,
                         height: 200)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
}

