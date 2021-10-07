//
//  LoginManager.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/07.
//

import Foundation
import Security
import CryptoKit

struct LoginManager {
  
  static let shared = LoginManager()
  
  private init() { }
  
  private let defaults = UserDefaults.standard
  private let bundleName = "P.TEP.jjollaejjollae"
  
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
  
  func isPasswordVerified(password: String?, confirmation: String?) -> Int {
    guard let password = password else {
      return 2
    }
    guard let confirmation = confirmation else {
      return 3
    }
    if confirmation == "" {
      return 3
    }
    if password != confirmation {
      return 0
    } else {
      return 1
    }
  }
  
  func StringToSha256(string: String) -> String {
    let plainData: Data = string.data(using: .utf8)!
    let shaData = SHA256.hash(data: plainData)
    let shaString = shaData.compactMap {String(format: "%02x", $0)}.joined()
    return shaString
  }
  
  func saveToken(accessToken: String, refreshToken: String) {
    defaults.set(accessToken, forKey: "accessToken")
    defaults.set(refreshToken, forKey: "refreshToken")
  }
  
  func saveInKeychain(account: String, value: String) {
    // 키체인쿼리
    let keyChainQuery: NSDictionary = [
      kSecClass: kSecClassGenericPassword, //아이탬 클레스
      kSecAttrService: bundleName, //앱 번들 아이디
      kSecAttrAccount: account, //사용자 계정
      kSecValueData: value.data(using: .utf8, allowLossyConversion: false)! //저장할 값
    ]
    
    // 값 삭제
    SecItemDelete(keyChainQuery)
    
    // 새로운 키체인 아이템 등록
    let status: OSStatus = SecItemAdd(keyChainQuery, nil)
    assert(status == noErr, "토큰 값 저장에 실패")
    NSLog("status=\(status)")
  }
  
  func loadFromKeychain(account: String) -> String? {
    let keyChainQuery: NSDictionary = [
      kSecClass: kSecClassGenericPassword, //아이탬 클레스
      kSecAttrService: bundleName, //앱 번들 아이디
      kSecAttrAccount: account, //사용자 계정
      kSecReturnData: kCFBooleanTrue, // CFData으로 불러오라
      kSecMatchLimit: kSecMatchLimitOne // 중복되는 경우 한개만
    ]
    
    var dataTypeRef: AnyObject?
    let status = SecItemCopyMatching(keyChainQuery, &dataTypeRef)
    
    if status == errSecSuccess {
      let retrievedData = dataTypeRef as! Data
      let value = String(data: retrievedData, encoding: String.Encoding.utf8)
      return value
    } else {
      print("토큰 로드 실패, status = \(status)")
      return nil
    }
  }
  
  func deleteFromKeyChain(account: String) {
    let keyChainQuery: NSDictionary = [
      kSecClass: kSecClassGenericPassword, //아이탬 클레스
      kSecAttrService: bundleName, //앱 번들 아이디
      kSecAttrAccount: account, //사용자 계정
    ]
    
    let status = SecItemDelete(keyChainQuery)
    assert(status == noErr, "토큰 값 삭제에 실패했습니다")
    NSLog("status=\(status)")
  }
  
}

