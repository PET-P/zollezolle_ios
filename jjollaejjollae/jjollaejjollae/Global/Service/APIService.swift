//
//  APIService.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/20.
//

import Foundation
import Moya

struct APIService {
  
  static let shared = APIService()
  
  let provider = MoyaProvider<APITarget>()
  
  func login(_ email: String, _ password: String,
             completion: @escaping (NetworkResult<LoginData>) -> (Void)) {
    let target = APITarget.login(email: email, password: password)
    judgeGenericResponse(target, completion: completion)
  }
  
  func email(_ email: String, completion: @escaping ((NetworkResult<Any>) -> (Void))) {
    let target = APITarget.email(email: email)
    judgeSimpleResponse(target, completion: completion)
  }
  
  func refreshToken(refreshToken: String, accessToken: String,
                    completion: @escaping ((NetworkResult<RefreshTokenData>) -> (Void))) {
    let target = APITarget.refreshToken(refreshToken: refreshToken, accessToken: accessToken)
    judgeGenericResponse(target, completion: completion)
  }
  
  func findPassword(email: String, completion: @escaping ((NetworkResult<Any>) -> (Void))) {
    let target = APITarget.findPassword(email: email)
    judgeSimpleResponse(target, completion: completion)
  }
  
  func tempPassword(email: String, code: String,
                    completion: @escaping ((NetworkResult<TempPasswordData>) -> (Void))) {
    let target = APITarget.tempPassword(email: email, code: code)
    judgeGenericResponse(target, completion: completion)
  }
  
  func signup(email: String, password: String, nick: String, phone: String,
              completion: @escaping ((NetworkResult<SignUpData>) -> (Void))) {
    let target = APITarget.signup(email: email, password: password, nick: nick, phone: phone)
    judgeGenericResponse(target, completion: completion)
  }
  
  func naver(authorization: String, completion: @escaping ((NetworkResult<Any>) -> (Void))){
    let target = APITarget.naver(authorization: authorization)
    judgeSimpleResponse(target, completion: completion)
  }
  
  func socialLogin(email: String, nick: String, phone: String, completion: @escaping ((NetworkResult<SignUpData>) -> (Void))) {
    let target = APITarget.socialLogin(email: email, nick: nick, phone: phone)
    judgeGenericResponse(target, completion: completion)
  }
  
  func patchPetInfo(userId: String, pets: PetInfos, completion: @escaping ((NetworkResult<LoginData>) -> (Void))) {
    let target = APITarget.patchPetInfo(userId: userId, pets: pets)
    judgeGenericResponse(target, completion: completion)
  }
  
}

extension APIService {
  func judgeGenericResponse<T: Codable>(_ target: APITarget,
                                        completion: @escaping ((NetworkResult<T>) -> Void)) {
    provider.request(target) { response in
      switch response {
      case .success(let result):
        do {
          let decoder = JSONDecoder()
          let body = try decoder.decode(GenericResponse<T>.self, from: result.data)
          print(body)
          if let data = body.data {
            completion(.success(data))
          }
        } catch {
          print("구조체를 확인하세요")
        }
      case .failure(let error):
        print("\(#function), error: \(error)")
        completion(.failure(error.response?.statusCode ?? -1))
      }
    }
  }
  
  func judgeSimpleResponse(_ target: APITarget,
                           completion: @escaping ((NetworkResult<Any>) -> Void)) {
    provider.request(target) { response in
      switch response {
      case .success(let result):
        do {
          let decoder = JSONDecoder()
          let body = try decoder.decode(SimpleResponse.self, from: result.data)
          completion(.success(body))
        } catch {
          print("구조체를 확인하세요")
          print(error.localizedDescription)
        }
      case .failure(let error):
        completion(.failure(error.response?.statusCode ?? -1))
      }
    }
  }
  
}
