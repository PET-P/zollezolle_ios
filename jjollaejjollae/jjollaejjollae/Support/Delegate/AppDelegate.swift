import UIKit
import NaverThirdPartyLogin
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var isLogged = false
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    var window: UIWindow?
    Thread.sleep(forTimeInterval: 1.0)
    if #available(iOS 13, *){
      
    } else {
      window = UIWindow()
      if !isLogged {
        guard let loginVC = LoginViewController.loadFromStoryboard() as? LoginViewController else {return false}
        window?.rootViewController = loginVC
      } else {
        window?.rootViewController = MainTabBarController()
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
    //kServiceAppUrlScheme
    instance?.serviceUrlScheme = kServiceAppUrlScheme
    //애플리케이션 등록 후 발급받은 클아이언트 아이디
    instance?.consumerKey = kConsumerKey
    //클라이언트 시크릿
    instance?.consumerSecret = kConsumerSecret
    //어플리케이션 이름
    instance?.appName = kServiceAppName
    //firebase
    FirebaseApp.configure()
    // 설정값 초기화
    UserDefaults.standard.register(defaults: ["alarm":true])
    
    return true
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
