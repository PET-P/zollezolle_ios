//
//  UserManager.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/08.
//

import Foundation
import Metal

//MARK: - User의 정보를 알려주는 싱글톤 객체

class UserManager {
  
  static var shared = UserManager()
  
  static let didSetAppUserNotification = NSNotification.Name("didSetAppUserNotification")
  
  private init() { }
  
  /**
  위치 서비스
  - Author: 박우찬
   */
  var locationService = LocationService.shared
  
  //userid만 존재할때
  var userIdandToken: (userId: String?, token: String?)? {
    didSet {
      guard let userId  = userIdandToken?.userId else {return}
      guard let token  = userIdandToken?.token else {return}
      APIService.shared.readUser(token: token, userId: userId) { [weak self] (result) in
        switch result {
        case .success(let data):
          self?.appUser = data
        case .failure(let error):
          print(error)
        }
      }
    }
  }
  
  private var appUser: UserData? {
    didSet {
      NotificationCenter.default.post(name: UserManager.didSetAppUserNotification, object: nil)
    }
  }
  
  var isLogged: Bool {
    get {
      return appUser != nil
    }
  }
  
  //User를 직접 받을 수 있을때
  var userInfo: UserData? {
    get {
      return appUser
    }
    set {
      self.appUser = newValue
    }
  }
  
  func setNick(nick: String) {
    guard var appUser = appUser else {
      return
    }
    appUser.nick = nick
  }

  
  func deleteUser(){
    //전역변수 제거
    userIdandToken = nil
    appUser = nil
    //Keychain 제거
    LoginManager.shared.deleteFromKeyChain(account: "accessToken")
    LoginManager.shared.deleteFromKeyChain(account: "refreshToken")
  }
  
}
