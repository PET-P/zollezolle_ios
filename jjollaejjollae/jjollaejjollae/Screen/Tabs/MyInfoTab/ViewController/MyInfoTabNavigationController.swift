//
//  MyInfoTabNavigationController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/08.
//

import UIKit

class MyInfoTabNavigationController: UINavigationController {

  // MARK: - Properties
  
  private let myInfoMainVC: MyInfoMainViewController = {
    
    guard let myInfoMainVC = MyInfoMainViewController.loadFromStoryboard()
            as? MyInfoMainViewController
    else {
      return MyInfoMainViewController()
    }
    
    return myInfoMainVC
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

    self.viewControllers.append(myInfoMainVC)
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
