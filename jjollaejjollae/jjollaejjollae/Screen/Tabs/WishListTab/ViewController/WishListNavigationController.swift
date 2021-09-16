//
//  WishListNavigationController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/08.
//

import UIKit

class WishListNavigationController: UINavigationController {
  
  let wishListMainVC: WishListMainViewController = {
    
    guard let wishListMainVC =
            WishListMainViewController.loadFromStoryboard(fileName: "WishListMain")
            as? WishListMainViewController
    else {
      return WishListMainViewController()
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
    
    self.tabBarItem = UITabBarItem(title: wishListTabTitle,
                                   image: wishListTabImage,
                                   selectedImage: nil)
  }
  
  private func setRootViewController() {
    
    self.viewControllers.append(wishListMainVC)
  }
}

// MARK: - Resources
extension WishListNavigationController {
  private var wishListTabTitle: String {
    return "위시리스트"
  }
  
  private var wishListTabImage: UIImage? {
    return UIImage(named: "WishListTab")
  }
}
