//
//  AppDelegate.swift
//  jjollaejjollae
//
//  Created by abc on 2021/07/27.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var isLogged = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        var window: UIWindow?
        
      if #available(iOS 13.0, *){
            
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
            window?.makeKeyAndVisible()
        }
        
        return true
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
