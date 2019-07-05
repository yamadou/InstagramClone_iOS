//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Yamadou Traore on 3/2/19.
//  Copyright © 2019 yamadou. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.delegate = self
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: false, completion: nil)
            }
            return
        }
        
        setupViewControllers()
        
        // modify tab bar item insets
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    func setupViewControllers() {
        // home
        let homeNavController = templateNavController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_unselected")!, rootViewController: HomeFeedController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // search
        let searchController = UserSearchController(collectionViewLayout: UICollectionViewFlowLayout())
        let searchNavController = templateNavController(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!, rootViewController: searchController)
        
        /// plus
        let plusNavController = templateNavController(unselectedImage:  UIImage(named: "plus_unselected")!, selectedImage:  UIImage(named: "plus_unselected")!)
        
        //like
        let likeNavController = templateNavController(unselectedImage:  UIImage(named: "like_unselected")!, selectedImage:  UIImage(named: "like_selected")!)
        
        // user profile
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let userProfilenavController = templateNavController(unselectedImage: UIImage(named: "profile_unselected")!, selectedImage: UIImage(named: "profile_selected")!, rootViewController: userProfileController)
        
        tabBar.tintColor = UIColor.black
        
        viewControllers = [homeNavController,
                           searchNavController,
                           plusNavController,
                           likeNavController,
                           userProfilenavController]
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        
        return navController
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            self.present(navController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
}
