//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by Yamadou Traore on 3/19/19.
//  Copyright © 2019 yamadou. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    let customAnimationPresentor = CustomAnimationPresentor()
    let customAnimationDismissor = CustomAnimationDismissor()
    
    let dismissButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "right_arrow_shadow"), for: .normal)
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    let capturePhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "capture_photo"), for: .normal)
        btn.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleCapturePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = self
        
        view.backgroundColor = UIColor.white
        
        setupCaptureSession()
        setupHUD()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func setupHUD() {
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil,
                                  left: nil,
                                  bottom: view.bottomAnchor,
                                  right: nil,
                                  paddingTop: 0,
                                  paddingLeft: 0,
                                  paddingBottom: -24,
                                  paddingRight: 0,
                                  width: 80,
                                  height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor,
                             left: nil,
                             bottom: nil,
                             right: view.rightAnchor,
                             paddingTop: 12,
                             paddingLeft: 0,
                             paddingBottom: 0,
                             paddingRight: 12,
                             width: 50,
                             height: 50)
    }
    
    let output = AVCapturePhotoOutput()
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        //1. setup inputs
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
        } catch let err {
            print("Could not setup camera input:", err)
        }
        
        //2. setup outputs
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        //3. setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        self.view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor,
                                left: view.leftAnchor,
                                bottom: view.bottomAnchor,
                                right: view.rightAnchor,
                                paddingTop: 0,
                                paddingLeft: 0,
                                paddingBottom: 0,
                                paddingRight: 0,
                                width: 0,
                                height: 0)
    }
}

extension CameraController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresentor
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismissor
    }
}
