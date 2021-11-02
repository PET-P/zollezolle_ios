//
//  SceneDelegate.swift
//  jjollaejjollae
//
//  Created by abc on 2021/07/27.
//

import UIKit
import KakaoSDKAuth
import NaverThirdPartyLogin

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  //for test
  var isLogged: Bool = false
  var waitingGroup = DispatchGroup()
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    
    
    //인터넷연결 오류시 발생하는 것
    guard DeviceManager.shared.networkStatus == true else{
      let attributedString =
      NSAttributedString(string: "인터넷 연결 오류",
                         attributes: [NSAttributedString.Key.font: UIFont.robotoBold(size: 20),
                                      NSAttributedString.Key.foregroundColor: UIColor.themeGreen])
      let AlertController = UIAlertController(title: "",
                                              message: nil,
                                              preferredStyle: .alert)
      AlertController.setValue(attributedString, forKey: "attributedTitle")
      let mainTabBarController = MainTabBarController()
      self.window?.rootViewController = mainTabBarController
      self.window?.makeKeyAndVisible()
      mainTabBarController.present(AlertController, animated: true, completion: nil)
      return
    }
    
 
    
    
//
//    let navigationController = UINavigationController()
//
//    let loginViewController = LoginViewController.loadFromStoryboard()
//
//    navigationController.viewControllers = [loginViewController]
//
//    navigationController.navigationBar.isHidden = true
//
//    self.window?.rootViewController = navigationController
//    self.window?.makeKeyAndVisible()
    
    if let accessToken = LoginManager.shared.loadFromKeychain(account: "accessToken"),
       let refreshToken = LoginManager.shared.loadFromKeychain(account: "refreshToken") {
      APIService.shared.refreshToken(refreshToken: refreshToken,
                                     accessToken: accessToken) { [weak self] (result) in
        switch result {

        case .success(let data):

          if let newAccessToken = data.accessToken {
            if let newRefreshToken = data.refreshToken { // access, refresh 둘다 발급
              LoginManager.shared.deleteFromKeyChain(account: "accessToken")
              LoginManager.shared.deleteFromKeyChain(account: "refreshToken")
              LoginManager.shared.saveInKeychain(account: newAccessToken, value: "accessToken")
              LoginManager.shared.saveInKeychain(account: newRefreshToken, value: "refreshToken")
              UserManager.shared.userIdandToken = (data.userId, newAccessToken)
              
            } else { //access 만 발급
              LoginManager.shared.deleteFromKeyChain(account: "accessToken")
              LoginManager.shared.saveInKeychain(account: newAccessToken, value: "accessToken")
              UserManager.shared.userIdandToken = (data.userId, newAccessToken)
            }
          } else { // access, refresh 모두 유효
            UserManager.shared.userIdandToken = (data.userId, accessToken)
          }
          
          let mainTabBar = MainTabBarController()

          self?.window?.rootViewController = mainTabBar
          self?.window?.makeKeyAndVisible()

        case .failure(let error):

            let navigationController = UINavigationController()

            LoginManager.shared.deleteFromKeyChain(account: "accessToken")
            LoginManager.shared.deleteFromKeyChain(account: "refreshToken")
            
            let loginViewController = LoginViewController.loadFromStoryboard()

            navigationController.viewControllers = [loginViewController]

            navigationController.navigationBar.isHidden = true

            self?.window?.rootViewController = navigationController
            self?.window?.makeKeyAndVisible()
          }
        }

      }
    else {
      
      if let accessToken = LoginManager.shared.loadFromKeychain(account: "accessToken") {
        LoginManager.shared.deleteFromKeyChain(account: "accessToken")
      }
      if let refreshToken = LoginManager.shared.loadFromKeychain(account: "refreshToken") {
        LoginManager.shared.deleteFromKeyChain(account: "refreshToken")
      }

      let navigationController = UINavigationController()

      let loginViewController = LoginViewController.loadFromStoryboard()

      navigationController.viewControllers = [loginViewController]

      navigationController.navigationBar.isHidden = true

      self.window?.rootViewController = navigationController
      self.window?.makeKeyAndVisible()
    }
  }
  
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    NaverThirdPartyLoginConnection
      .getSharedInstance()?
      .receiveAccessToken(URLContexts.first?.url)
    
    if let url = URLContexts.first?.url {
      if (AuthApi.isKakaoTalkLoginUrl(url)) {
        _ = AuthController.handleOpenUrl(url: url)
      }
    }
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
    
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    
  }
  
}

