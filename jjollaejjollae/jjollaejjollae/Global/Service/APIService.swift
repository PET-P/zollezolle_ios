//
//  APIService.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/20.
//

import Foundation
import Moya
import UIKit
import Kingfisher
import SwiftyJSON

struct APIService { 
  
  static let shared = APIService()
  
  let provider = MoyaProvider<APITarget>()
  
  func login(_ email: String, _ password: String,
             completion: @escaping (NetworkResult<SignUpData>) -> (Void)) {
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
  
  func tempPassword(email: String,
                    completion: @escaping ((NetworkResult<Any>) -> (Void))) {
    let target = APITarget.tempPassword(email: email)
    judgeSimpleResponse(target, completion: completion)
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
  
  func socialLogin(email: String, nick: String, phone: String, accountType: AccountType, completion: @escaping ((NetworkResult<SignUpData>) -> (Void))) {
    let target = APITarget.socialLogin(email: email, nick: nick, phone: phone, accountType: accountType.rawValue)
    judgeGenericResponse(target, completion: completion)
  }
  
  func patchPetInfo(token: String, userId: String, petId: String, pets: [PetData], completion: @escaping ((NetworkResult<UserData>) -> (Void))) {
    let target = APITarget.patchPetInfo(token: token, userId: userId, petId: petId, pets: pets)
    judgeGenericResponse(target, completion: completion)
  }
  
  func search(token: String, keyword: String, page: Int, completion: @escaping((NetworkResult<SearchData>) -> (Void))) {
    let target = APITarget.search(token: token, keyword: keyword, page: page)
    judgeGenericResponse(target, completion: completion)
  }

  func search(keyword: String, page: Int, completion: @escaping((NetworkResult<SearchData>) -> (Void))) {
    let target = APITarget.noLoginSearch(keyword: keyword, page: page)
    judgeGenericResponse(target, completion: completion)
  }
  
  func nearPlace(latitude: Double, longitude: Double, completion: @escaping((NetworkResult<[SearchResultData]>) -> (Void))) {
    let target = APITarget.nearPlace(lat: latitude, lng: longitude)
    judgeGenericResponse(target, completion: completion)
  }
  
  func readAllPosts(completion: @escaping((NetworkResult<[PostData]>) -> (Void))) {
    let target = APITarget.readAllPosts
    judgeGenericResponse(target, completion: completion)
  }
  
  func readPost(postId: String, completion: @escaping((NetworkResult<PostData>) -> (Void))) {
    let target = APITarget.readPost(postId: postId)
    judgeGenericResponse(target, completion: completion)
  }
  
  func readWishlist(userId: String, token: String, completion: @escaping((NetworkResult<WishlistData>) -> (Void))) {
    let target = APITarget.readWishlist(token: token, userId: userId)
    judgeGenericResponse(target, completion: completion)
  }
  
  func createWishlistFolder(userId: String, folder: [String: Any], completion: @escaping((NetworkResult<WishlistData>) -> (Void))) {
    let target = APITarget.createWishlistFolder(userId: userId, folder: folder)
    judgeGenericResponse(target, completion: completion)
  }
  
  func patchFolder(token: String, userId: String, folderId: String, name: String, startDate: String, endDate: String, completion: @escaping((NetworkResult<WishlistData>) -> (Void))) {
    let target = APITarget.patchFolder(token: token, userId: userId, folderId: folderId, name: name, startDate: startDate, endDate: endDate)
    judgeGenericResponse(target, completion: completion)
  }
  
  func deleteFolder(token: String, userId: String, folderId: String, completion: @escaping((NetworkResult<WishlistData>) -> (Void))) {
    let target = APITarget.deleteFolder(token: token, userId: userId, folderId: folderId)
    judgeGenericResponse(target, completion: completion)
  }
  
  func readFolder(token: String, userId: String, folderId: String, completion: @escaping((NetworkResult<FolderData>) -> (Void))) {
    let target = APITarget.readFolder(token: token, userId: userId, folderId: folderId)
    judgeGenericResponse(target, completion: completion)
  }
  
  func addPlaceInFolder(token: String, userId: String, placeId: String, folderId: String, completion: @escaping((NetworkResult<WishlistData>) -> (Void))) {
    let target = APITarget.addPlaceInFolder(token: token, userId: userId, placeId: placeId, folderId: folderId)
    judgeGenericResponse(target, completion: completion)
  }
  
  func deletePlaceInFolder(token: String, userId: String, folderId: String?, placeId: String, completion: @escaping((NetworkResult<WishlistData>) -> (Void))) {
    if let folderId = folderId {
      let target = APITarget.deletePlaceInFolder(token: token, userId: userId, folderId: folderId, placeId: placeId)
      judgeGenericResponse(target, completion: completion)
    } else {
      let target = APITarget.deletePlaceInEntireFolder(token: token, userId: userId, placeId: placeId)
      judgeGenericResponse(target, completion: completion)
    }
  }
  
  func readUser(token: String, userId: String, completion: @escaping((NetworkResult<UserData>) -> (Void))) {
    let target = APITarget.readUser(token: token, userId: userId)
    judgeGenericResponse(target, completion: completion)
  }
  
  func readAllUsers(completion: @escaping((NetworkResult<[UserData]>) -> (Void))) {
    let target = APITarget.readAllUsers
    judgeGenericResponse(target, completion: completion)
  }
  
  func createPet(token: String, userId: String, name: String, age: Int?, sex: Sex, size: Size, weight: Double?, type: String, breed: String?, imageUrl: String?, isRepresent: Bool, completion: @escaping((NetworkResult<PetData>) -> (Void))) {
    let target = APITarget.createPet(token: token, userId: userId, name: name, age: age, sex: sex.rawValue, size: size.rawValue, weight: weight, type: type, breed: breed, imageUrl: imageUrl, isRepresent: isRepresent)
    judgeGenericResponse(target, completion: completion)
  }
  
  func readPets(token: String, userId: String, completion: @escaping((NetworkResult<[PetData]>) -> (Void))) {
    let target = APITarget.readPets(token: token, userId: userId)
    judgeGenericResponse(target, completion: completion)
  }
  
  func deleteUser(token: String, userId: String, completion: @escaping((NetworkResult<Any>) -> (Void))) {
    let target = APITarget.deleteUser(token: token, userId: userId)
    judgeSimpleResponse(target, completion: completion)
  }
  
  func readReview(token: String, userId: String, completion: (@escaping(NetworkResult<UserReviewData>) -> (Void))) {
    let target =  APITarget.readReview(token: token, userId: userId)
    judgeGenericResponse(target, completion: completion)
  }
  
  func deleteReview(token: String, reviewId: String, completion: @escaping((NetworkResult<Any>) -> (Void))) {
    let target = APITarget.deleteReview(token: token, reviewId: reviewId)
    judgeSimpleResponse(target, completion: completion)
  }
  
  func getFilterPlace(region: String, category: CategoryType, filter: String, page: Int, completion: @escaping((NetworkResult<[SearchResultData]>) -> (Void))) {
    let target = APITarget.getFilterPlace(region: region, category: category, filter: filter, page: page)
    judgeGenericResponse(target, completion: completion)
  }
  
  /**
   - Author : 박우찬
   */
  func fetchPlaceInfo(placeId: String, completion: @escaping((NetworkResult<JSON>) -> (Void))) {
    
    let target = APITarget.fetchPlaceInfo(placeID: placeId)
    
    judgeGenericResponse(target, completion: completion)
  }
  
  /**
   - Author : 박우찬
   */
  func createReview(token: String, userReview: UserReview, completion: @escaping ((NetworkResult<Any>) -> (Void))) {
    
    let target = APITarget.createReview(token: token, userReview: userReview.toDict())
    
    judgeSimpleResponse(target, completion: completion)
  }
  
  
  func patchUser(token: String, userId: String, nick: String?, phone: String?, password: String?, completion: @escaping((NetworkResult<JSON>) -> (Void))) {
    let target = APITarget.patchUser(token: token, userId: userId, nick: nick, phone: phone, password: password)
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

