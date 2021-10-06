//
//  AppDelegate.swift
//  jjollaejjollae
//
//  Created by abc on 2021/07/27.
//

import UIKit
import NaverThirdPartyLogin
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import Amplify
import AmplifyPlugins
import AWSS3

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var isLogged = false
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    var window: UIWindow?
    
    if #available(iOS 13, *){
      
    } else {
      window = UIWindow()
      let storyboard = UIStoryboard(name: "LoginView", bundle: nil)
      if !isLogged {
        guard let loginVC = storyboard.instantiateViewController(identifier: "LoginView") as? LoginViewController else {return false}
        window?.rootViewController = loginVC
      } else {
        //TODO: 여기다가 homeVC에 대한 내용 작성
        guard let homeVC = storyboard.instantiateViewController(identifier: "homeView") as? LoginViewController else {return false}
        window?.rootViewController = homeVC
      }
      window?.overrideUserInterfaceStyle = .light
      window?.makeKeyAndVisible()
    }
    
    KakaoSDKCommon.initSDK(appKey: "c0bb56afacd533b59ed80a295f4c5835")
    
    
    let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    //네이버앱에서 인증활성화
    instance?.isNaverAppOauthEnable = true
    //사파리에서 인증활정화
    instance?.isInAppOauthEnable = true
    //새로모드에서만 가능하게 만들기
    instance?.isOnlyPortraitSupportedInIphone()
    
    //네아로 설정
    //처음 정해준 urlscheme
    instance?.serviceUrlScheme = "thirdparty20samplegame"
    //애플리케이션 등록 후 발급받은 클아이언트 아이디
    instance?.consumerKey = "jyvqXeaVOVmV"
    //클라이언트 시크릿
    instance?.consumerSecret = "527300A0_COq1_XV33cf"
    //어플리케이션 이름
    instance?.appName = "네이버 아이디로 로그인"
    //amazon s3
    configureAmplify()
    
    return true
  }
  
  func configureAmplify() {
    do {
      //storage
      try Amplify.add(plugin: AWSCognitoAuthPlugin())
      try Amplify.add(plugin: AWSS3StoragePlugin())
      try Amplify.configure()
      print("Successfully configured Amplify 😀")
    } catch {
      print("Could not configuare Amplify \(error)")
    }
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if (AuthApi.isKakaoTalkLoginUrl(url)) {
      return AuthController.handleOpenUrl(url: url)
    } else if NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options) != nil {
      return true
    } else {
      return false
    }
  }
  
  func application(_ application: UIApplication,
                  handleEventsForBackgroundURLSession identifier: String,
                  completionHandler: @escaping () -> Void) {
   
       //provide the completionHandler to the TransferUtility to support background transfers.
       AWSS3TransferUtility.interceptApplication(application,
           handleEventsForBackgroundURLSession: identifier,
           completionHandler: completionHandler)
   }
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
  
}
