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
  
  let myNeighborhoodTab: MyNeighborhoodNavigationController = {
    
    let myNeighborhoodTabNavi = MyNeighborhoodNavigationController()
    
    myNeighborhoodTabNavi.setTabBarItem()
    
    return myNeighborhoodTabNavi
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

    self.setViewControllers( [homeTab, myNeighborhoodTab, wishListTab, myInfoTab], animated: true)
    setTabBar()
  }
  
  func setTabBar() {
    self.tabBar.tintColor = UIColor.쫄래그린
    self.tabBar.isTranslucent = false
  }
}