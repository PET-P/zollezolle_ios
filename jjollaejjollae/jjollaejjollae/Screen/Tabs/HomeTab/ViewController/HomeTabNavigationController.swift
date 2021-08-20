//
//  HomeTabNavigationController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/07.
//

import UIKit

// TODO: 이 프로토콜 적절한 파일로 옮기기
protocol Storyboardable: AnyObject {
  
  static func loadFromStoryboard() -> UIViewController
}

extension Storyboardable {
  
  /// 우리 팀은 Storyboard 의 작명규칙을
  /// ViewController 를 제외한 이름으로 정하기로 결정했다.
  static var fileName: String {
    
    let className = String(describing: self)
    
    // "ViewController".count is 14
    return String(className.prefix(className.count - 14))
  }
  
  static var storyboardIdentifier: String {
    
    return String(describing: self)
  }
  
  static func loadFromStoryboard() -> UIViewController {
    
    let storyboard = UIStoryboard(name: Self.fileName, bundle: nil)
    
    let homeMainVC = storyboard.instantiateViewController(identifier: Self.storyboardIdentifier)
    
    return homeMainVC
  }
}

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
