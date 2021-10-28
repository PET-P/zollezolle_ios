//
//  APITarget.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/20.
//

import Foundation
import Moya

enum APIEnvironment: String {
  case base = "https://api.zollezolle.me/api"
  case naverURL = "https://openapi.naver.com/v1/nid/me"
}


enum APITarget {
  case login(email: String, password: String) //로그인
  case email(email: String) //이메일 인증 (비밀번호)
  case signup(email: String, password: String, nick: String, phone: String) //로컬 회원가입
  case refreshToken(refreshToken: String, accessToken: String)//토큰 재발급
  case findPassword(email: String) //비밀번호 찾기
  case tempPassword(email: String) //임시비밀번호
  case naver(authorization: String)
  case socialLogin(email: String, nick: String, phone: String, accountType: String)
  case createPet(token: String, userId: String, name: String, age: Int?, sex: String, size: String, weight: Double?, type: String, breed: String?, imageUrl: String?, isRepresent: Bool)
  case readPets(token: String, userId: String)
  case patchPetInfo(token: String, userId: String, petId: String, pets: [PetData])
  
  case search(token: String, keyword: String, page: Int)
  case noLoginSearch(keyword: String, page: Int)
  case nearPlace(lat: Double, lng: Double)
  
  case getFilterPlace(region: String, category: CategoryType, filter: String, page: Int)
  
  case readAllPosts
  case readPost(postId: String)
  
  case readWishlist(token: String, userId: String)
  case createWishlistFolder(userId: String, folder: [String: Any])
  case patchFolder(token: String, userId: String, folderId: String, name: String, startDate: String?, endDate: String?)
  
  case deleteFolder(token: String, userId: String, folderId: String)
  case readFolder(token: String, userId: String, folderId: String)
  
  case readUser(token: String, userId: String)
  case deleteUser(token: String, userId: String)
  case readAllUsers
  case patchMyInfo(token: String, userId: String)
  
  case readReview(token: String, userId: String)
  case readPlaceReview(token: String, placeId: String)
  case noLoginReadReview(placeId: String)
  case deleteReview(reviewId: String)
  
  //담기 추가
  case addPlaceInFolder(token: String, userId: String, placeId: String, folderId: String)
  //담기 삭제
  case deletePlaceInFolder(token: String, userId: String, folderId: String, placeId: String)
//  case fetchPlaceInfo(placeID: )
}

extension APITarget: TargetType {
  
  var baseURL: URL {
    switch self {
    case .naver:
      return URL(string: APIEnvironment.naverURL.rawValue)!
    default:
      return URL(string: APIEnvironment.base.rawValue)!
    }
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
    case .tempPassword:
      return "/auth/password"
    case .naver:
      return ""
    case .socialLogin:
      return "/auth/social"
    case .patchPetInfo(_, let userId, let petId, _):
      return "/users/\(userId)/pets/\(petId)"
    case .search, .noLoginSearch:
      return "/search"
    case .readAllPosts:
      return "/posts"
    case .readPost(let postId):
      return "/posts/\(postId)"
    case .readWishlist(_, let userId):
      return "/wishlist/\(userId)"
    case .createWishlistFolder:
      return "/wishlist"
    case .patchFolder(_, let userId,_, _, _, _), .deleteFolder(_, let userId, _):
      return "/wishlist/\(userId)"
    case .readFolder(_, let userId, _):
      return "/wishlist/folder/\(userId)"
    case .addPlaceInFolder:
      return "/wishlist/folder"
    case .readUser(_, let userId):
      return "/users/\(userId)"
    case .readAllUsers:
      return "/users"
    case .createPet(_, let userId, _, _, _, _, _, _, _, _, _), .readPets(_, let userId):
      return "/users/\(userId)/pets"
    case .patchMyInfo(_, let userId):
      return "/users/\(userId)"
    case .deleteUser(_, let userId):
      return "/users/\(userId)"
    case .readReview(_, _), .noLoginReadReview(_), .readPlaceReview(_, _):
      return "/reviews"
    case .deleteReview(let reviewId):
      return "/reviews/\(reviewId)"
    case .deletePlaceInFolder(_, let userId, _,_):
      return "/wishlist/folder/\(userId)"
    case .nearPlace:
      return "/places/near"
    case .getFilterPlace:
      return "/places"
      
//    case .fetchPlaceInfo:
//      return
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .refreshToken, .tempPassword, .naver, .search, .noLoginSearch, .readAllPosts, .readPost, .readWishlist, .readFolder, .readUser, .readAllUsers, .readPets, .readReview, .readPlaceReview, .noLoginReadReview, .nearPlace, .getFilterPlace:
      return .get
    case .email, .login, .findPassword, .signup, .socialLogin, .addPlaceInFolder, .createPet, .createWishlistFolder:
      return .post
    case .patchPetInfo, .patchFolder, .patchMyInfo:
      return .patch
    case .deleteFolder, .deleteUser, .deleteReview, .deletePlaceInFolder:
      return .delete
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
    case .naver, .readAllPosts, .readPost, .readWishlist, .refreshToken, .readUser, .readAllUsers, .readPets, .patchMyInfo, .deleteUser, .deleteReview:
      return .requestPlain
    case .socialLogin(let email, let nick, let phone, let accountType):
      return .requestParameters(parameters: ["email": email, "nick": nick, "phone": phone, "accountType": accountType], encoding: JSONEncoding.default)
    case .createPet(_, _, let name, let age, let sex, let size, let weight, let type, let breed, let imageUrl, let isRepresent):
      return .requestParameters(parameters: ["name": name, "age": age, "sex": sex, "size": size, "weight": weight , "type": type, "breed": breed, "imageUrl": imageUrl, "isRepresent": isRepresent], encoding: JSONEncoding.default)
    case .tempPassword(let email):
      return .requestParameters(parameters: ["email": email], encoding: URLEncoding.queryString)
    case .patchPetInfo(_, _, _, let pets):
      return .requestParameters(parameters: ["pets": pets], encoding: JSONEncoding.default)
      
    case .createWishlistFolder(let userId, let folder):
      return .requestParameters(parameters: ["userId": userId, "folder": folder], encoding: JSONEncoding.default)
    case .patchFolder(_, _, let folderId, let name, let startDate, let endDate):
      return .requestCompositeParameters(bodyParameters: ["name": name, "startDate": startDate, "endDate": endDate], bodyEncoding: JSONEncoding.default, urlParameters: ["folderId": folderId])
    case .readFolder(_, _, let folderId), .deleteFolder(_, _, let folderId):
      return .requestParameters(parameters: ["folderId": folderId], encoding: URLEncoding.queryString)
    case .addPlaceInFolder(_, let userId, let placeId, let folderId):
      return .requestParameters(parameters: ["userId": userId, "placeId": placeId, "folderId": folderId], encoding: JSONEncoding.default)
    case .deletePlaceInFolder(_, _, let folderId, let placeId):
      return .requestParameters(parameters: ["folderId": folderId, "placeId": placeId], encoding: URLEncoding.queryString)
      
    case .search(_, let keyword, let page), .noLoginSearch(let keyword, let page ):
      return .requestParameters(parameters: ["keyword": keyword, "page": page], encoding: URLEncoding.queryString)
    case .nearPlace(let lat, let lng):
      return .requestParameters(parameters: ["latitude": lat, "longitude": lng], encoding: URLEncoding.queryString)
    case .readReview(_, let userId):
      return .requestParameters(parameters: ["userId": userId], encoding: URLEncoding.queryString)
    case .readPlaceReview(_, let placeId), .noLoginReadReview(let placeId):
      return .requestParameters(parameters: ["placeId": placeId], encoding: URLEncoding.queryString)
    case .getFilterPlace(let region,let category,let filter, let page):
      return .requestParameters(parameters: ["region": region, "category": category.rawValue, "filter": filter, "page": page], encoding: URLEncoding.queryString)
    }
  }
    
  var validationType: ValidationType {
    return .successAndRedirectCodes
  }
  
  var headers: [String : String]? {
    switch self {
    case .login, .email, .findPassword, .tempPassword, .signup, .socialLogin, .patchPetInfo, .readAllPosts, .readPost,  .readAllUsers, .noLoginSearch, .noLoginReadReview, .deleteReview, .nearPlace, .createWishlistFolder, .getFilterPlace:
      return ["Content-Type" : "application/json"]
    case .refreshToken(let refreshToken, let accessToken):
      return ["Content-Type" : "application/json", "Refresh" : refreshToken,
              "Authorization" : "Bearer \(accessToken)"]
    case .readUser(let token, _), .deleteUser(let token, _), .patchMyInfo(let token, _), .createPet(let token, _, _, _, _, _, _, _, _, _, _), .readPets(let token, _), .readFolder(let token,_,_), .search(let token, _, _), .readReview(let token, _), .readPlaceReview(let token, _), .readWishlist(let token, _), .addPlaceInFolder(let token, _, _, _), .patchFolder(let token, _, _, _, _, _), .deleteFolder(let token, _, _), .deletePlaceInFolder(let token, _, _, _):
      return ["Content-Type" : "application/json", "Authorization" : "Bearer \(token)"]
    case .naver(let authorization):
      return ["Authorization": authorization]
    }
  }
  
  
}
