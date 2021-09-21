//
//  APITarget.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/20.
//

import Foundation
import Moya

enum APITarget {
  case login(email: String, password: String) //로그인
  case email(email: String) //이메일 인증 (비밀번호)
  case signup(email: String, password: String, nick: String, phone: String) //로컬 회원가입
  case refreshToken(refreshToken: String, accessToken: String)//토큰 재발급
  case findPassword(email: String) //비밀번호 찾기
  case tempPassword(email: String, code: String) //임시비밀번호
}

extension APITarget: TargetType {
  var baseURL: URL {
    return URL(string: "http://49.50.173.104:80/api")!
  }
  
  var path: String {
    switch self {
    case .login:
      return "/auth"
    case .email:
      return "/auth/email"
    case .signup:
      return "/users"
    case .refreshToken:
      return "/auth"
    case .findPassword:
      return "/auth/password"
    case .tempPassword(let email, let code):
      return "/auth/password?email=\(email)&code=\(code)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .refreshToken, .tempPassword:
      return .get
    case .email, .login, .findPassword, .signup:
      return .post
    }
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    // task - 리퀘스트에 사용되는 파라미터 설정
    // 파라미터가 없을 때는 - .requestPlain
    // 파라미터 존재시에는 - .requestParameters(parameters: ["first_name": firstName, "last_name": lastName], encoding: JSONEncoding.default)
    switch self {
    case .email(let email):
      return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
      
    case .login(let email, let password):
      return .requestParameters(parameters: ["email": email, "password": password],
                                encoding: JSONEncoding.default)
      
    case .signup(let email, let password, let nick, let phone):
      return .requestParameters(parameters: ["email":email, "password":password, "nick":nick,
                                             "phone": phone], encoding: JSONEncoding.default)
    case .findPassword(let email):
      return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
    case .refreshToken(let refreshToken, let accessToken):
      return .requestParameters(parameters: ["refreshToken": refreshToken,
                                             "accessToken" : accessToken],
                                encoding: JSONEncoding.default)
    case .tempPassword(let email, let code):
      return .requestParameters(parameters: ["email": email, "code": code],
                                encoding: JSONEncoding.default)
    }
  }
  
  
  var validationType: ValidationType {
    return .successAndRedirectCodes
  }
  
  var headers: [String : String]? {
    switch self {
    case .login, .email, .findPassword, .tempPassword, .signup:
      return ["Content-Type" : "application/json"]
    case .refreshToken(let refreshToken, let accessToken):
      return ["Content-Type" : "application/json", "Refresh" : refreshToken,
              "Authorization" : accessToken]
    }
  }
  
  
}