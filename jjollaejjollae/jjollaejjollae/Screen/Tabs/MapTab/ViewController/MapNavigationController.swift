//
//  MyNeighborhoodNavigationController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/08.
//

import UIKit

class MapNavigationController: UINavigationController {
  
  // MARK: - Properties
  
  let mapMainVC: MapMainViewController = {
    
    guard let mapMainVC =
            MapMainViewController.loadFromStoryboard()
            as? MapMainViewController
    else {
        return MapMainViewController()
    }
    
    return mapMainVC
  }()
  
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    
    super.viewDidLoad()
    setNavigationBarHidden(true, animated: true)
    setRootViewController()
  }
  
  // MARK: - Custom
  
  func setTabBarItem() {
    
    self.tabBarItem = UITabBarItem(title: mapTabTitle,
                                   image: mapTabImage,
                                   selectedImage: nil)
  }
  
  private func setRootViewController() {
    
    self.viewControllers.append(mapMainVC)
  }
}

extension MapNavigationController {
  
  var mapTabTitle: String {
    
    return "지도"
  }

  // TODO: SwiftGen Refactoring 필요
  private var mapTabImage: UIImage? {
    
    return UIImage(named: "MyNeighborhoodTab")
  }
}

