//
//  MyInfoTabNavigationController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/08.
//

import UIKit

class MyInfoTabNavigationController: UINavigationController {

  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationBarHidden(true, animated: true)
  }
  
  // MARK: - Custom
  
  func setTabBarItem() {
    self.tabBarItem = UITabBarItem(title: myInfoTabTitle,
                                   image: myInfoTabImage,
                                   selectedImage: nil)
  }
  
//  private func setRootViewController() {
//
//    self.viewControllers.append()
//  }
}

// MARK: - Resources
extension MyInfoTabNavigationController {
  private var myInfoTabTitle: String {
    return "내 정보"
  }
  
  private var myInfoTabImage: UIImage? {
    return UIImage(named: "MyInfoTab")
  }
}
