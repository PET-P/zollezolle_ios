//
//  MyInfoTabNavigationController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/08.
//

import UIKit

class MyInfoTabNavigationController: UINavigationController {
  
  let MyInfoMainVC: MyInfoMainViewController = {
    
    guard let MyInfoMainVC =
            MyInfoMainViewController.loadFromStoryboard()
            as? MyInfoMainViewController
    else {
      return MyInfoMainViewController()
    }
    return MyInfoMainVC
  }()

  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationBarHidden(true, animated: true)
    setRootViewController()
  }
  
  // MARK: - Custom
  
  func setTabBarItem() {
    self.tabBarItem = UITabBarItem(title: myInfoTabTitle,
                                   image: myInfoTabImage,
                                   selectedImage: nil)
  }
  
  private func setRootViewController() {
    self.viewControllers.append(MyInfoMainVC)
  }
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
