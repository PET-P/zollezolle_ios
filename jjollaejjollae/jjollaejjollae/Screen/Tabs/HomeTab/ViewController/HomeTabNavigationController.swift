//
//  HomeTabNavigationController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/07.
//

import UIKit

// TODO: 이 프로토콜 적절한 파일로 옮기기
//protocol Storyboardable: AnyObject {
//
//  static func loadFromStoryboard(fileName: String) -> UIViewController
//}

class HomeTabNavigationController: UINavigationController {
  
  // MARK: - Properties
  
  private let homeMainVC: HomeMainViewController = {
    
    guard let homeMainVieController =
            HomeMainViewController.loadFromStoryboard()
            as? HomeMainViewController
    else {
      return HomeMainViewController()
    }
    
    return homeMainVieController
  }()
  
  // TODO: 필요한 화면 팩토리 구성
  
  private let placeDetailVC: () -> () = {
    
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    setNavigationBarHidden(true, animated: true)
    setRootViewController()
    
    initialSetup()
  }
  
  // MARK: - Custom
  private func initialSetup() {
    // TODO: 강아지 정보입력 체크
    
  }

  func setTabBarItem() {
    self.tabBarItem = UITabBarItem(title: homeTabTitle, image: HomeTabImage, selectedImage: nil)
  }
  
  private func setRootViewController() {
    self.viewControllers.append(homeMainVC)
  }
}

// MARK: - Resources

extension HomeTabNavigationController {
  var homeTabTitle: String {
    return "홈"
  }
  
  var HomeTabImage: UIImage? {
    let image = UIImage(named: "HomeTab")
    return image
  }
}
