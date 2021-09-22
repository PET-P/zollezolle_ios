//
//  WishListNavigationController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/08.
//

import UIKit

class WishlistNavigationController: UINavigationController {
  
  let wishlistMainVC: WishlistMainViewController = {
    
    guard let wishListMainVC =
            WishlistMainViewController.loadFromStoryboard(fileName: "WishlistMain")
            as? WishlistMainViewController
    else {
      return WishlistMainViewController()
    }
    
    return wishListMainVC
  }()
  
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    setNavigationBarHidden(true, animated: true)
    setRootViewController()
  }
  
  // MARK: - Custom
  
  func setTabBarItem() {
    
    self.tabBarItem = UITabBarItem(title: wishlistTabTitle,
                                   image: wishlistTabImage,
                                   selectedImage: nil)
  }
  
  private func setRootViewController() {
    
    self.viewControllers.append(wishlistMainVC)
  }
}

// MARK: - Resources
extension WishlistNavigationController {
  private var wishlistTabTitle: String {
    return "위시리스트"
  }
  
  private var wishlistTabImage: UIImage? {
    return UIImage(named: "WishListTab")
  }
}
