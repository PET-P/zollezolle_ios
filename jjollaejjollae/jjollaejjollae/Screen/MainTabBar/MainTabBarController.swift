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
  
  let wishListTab: WishListNavigationController = {
    
    let wishListTabNavi = WishListNavigationController()
    
    wishListTabNavi.setTabBarItem()
    
    return wishListTabNavi
  }()
  
  let myInfoTab: MyInfoTabNavigationController = {
    let myInfoTabNavi = MyInfoTabNavigationController()
    
    myInfoTabNavi.setTabBarItem()
    
    return myInfoTabNavi
  }()
  
  // MARK: - Life Cycle

  override func viewDidLoad() {
    
    super.viewDidLoad()

    self.setViewControllers( [homeTab, mapTab, wishListTab, myInfoTab], animated: true)
    setTabBar()
  }
  
  func setTabBar() {
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
