//
//  UserManager.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/08.
//

import Foundation

//MARK: - User의 정보를 알려주는 싱글톤 객체

class UserManager {
  
  static var shared = UserManager()
  
  private init() { }
  
  //userid만 존재할때
  var userIdandToken: (userId: String?, token: String?)? {
    didSet {
      guard let userId  = userIdandToken?.userId else {return}
      guard let token  = userIdandToken?.token else {return}
      APIService.shared.readUser(token: token, userId: userId) { [weak self] (result) in
        switch result {
        case .success(let data):
          self?.AppUser = data
        case .failure(let error):
          print(error)
        }
      }
    }
  }
  
  private var AppUser: UserData?
  
  //User를 직접 받을 수 있을때
  var UserInfo: UserData? {
    get {
      return AppUser
    }
    set {
      self.AppUser = newValue
    }
  }
  
}