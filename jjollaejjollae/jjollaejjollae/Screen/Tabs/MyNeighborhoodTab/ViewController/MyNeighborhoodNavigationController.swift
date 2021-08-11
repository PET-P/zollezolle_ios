//
//  MyNeighborhoodNavigationController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/08.
//

import UIKit

class MyNeighborhoodNavigationController: UINavigationController {
  
  // MARK: - Properties
  
  let myNeighborhoodMainVC: MyNeighborhoodMainViewController = {
    
    guard let myNeighborhoodMainVC =
            MyNeighborhoodMainViewController.loadFromStoryboard(fileName: "MyNeighborhoodMain")
            as? MyNeighborhoodMainViewController
    else {
        return MyNeighborhoodMainViewController()
    }
    
    return myNeighborhoodMainVC
  }()
  
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    
    super.viewDidLoad()
    setNavigationBarHidden(true, animated: true)
    setRootViewController()
  }
  
  // MARK: - Custom
  
  func setTabBarItem() {
    
    self.tabBarItem = UITabBarItem(title: myNeighborhoodTabTitle,
                                   image: myNeighborhoodTabImage,
                                   selectedImage: nil)
  }
  
  private func setRootViewController() {
    
    self.viewControllers.append(myNeighborhoodMainVC)
  }
}

extension MyNeighborhoodNavigationController {
  
  var myNeighborhoodTabTitle: String {
    
    return "내 주변"
  }

  var myNeighborhoodTabImage: UIImage? {
    
    return UIImage(named: "MyNeighborhoodTab")
  }
}
