//
//  LoginManager.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/07.
//

import Foundation

struct LoginManager {
  
  func isValidEmail(email: String) -> Bool {
    //이메일 유효성 확인 정규식
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
  }
  
  func isValidPassword(password: String) -> Bool {
    //password 유효성 확인 정규식
    let passwordreg = ("(?=.*[A-Za-z])(?=.*[0-9]).{8,20}")
    let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
    return passwordtesting.evaluate(with: password)
  }
  
  func isPasswordVerified(confirmation: String) -> Bool {
    return false
  }
  
}

