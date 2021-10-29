//
//  MainTabBarController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/07.
//

import UIKit

class MainTabBarController: UITabBarController {
  
  // MARK: - Properties
  
  let homeTab: HomeTabNavigationController = {
    
    let homeTabNavi = HomeTabNavigationController()
    
    homeTabNavi.setTabBarItem()
    
    return homeTabNavi
  }()
  
  let mapTab: MapNavigationController = {
    
    let mapTabNavi = MapNavigationController()
    
    mapTabNavi.setTabBarItem()
    
    return mapTabNavi
  }()
  
  let wishlistTab: WishlistNavigationController = {
    
    let wishlistTabNavi = WishlistNavigationController()
    
    wishlistTabNavi.setTabBarItem()
    
    return wishlistTabNavi
  }()
  
  let myInfoTab: MyInfoTabNavigationController = {
    let myInfoTabNavi = MyInfoTabNavigationController()
    
    myInfoTabNavi.setTabBarItem()
    
    return myInfoTabNavi
  }()
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    self.setViewControllers( [homeTab, mapTab, wishlistTab, myInfoTab], animated: true)
    setTabBar()
  }
  
  func setTabBar() {
    if #available(iOS 15.0, *) {
      let appearance = UITabBarAppearance()
      appearance.configureWithOpaqueBackground()
      appearance.backgroundColor = .white
      
      self.tabBar.standardAppearance = appearance
      self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
    }
    self.tabBar.tintColor = UIColor.themeGreen
    self.tabBar.isTranslucent = false
  }
}

extension MainTabBarController {
  
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    
    if item.title == mapTab.mapTabTitle {
      
      mapTab.mapMainVC.setInitialContainerViewHeight()
    }
  }
}
