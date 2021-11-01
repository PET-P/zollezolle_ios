//
//  TotalReview.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/11/01.
//

import Foundation
import SwiftyJSON

struct TotalPlaceReview {
  
  var reviews: [PlaceReview]
  
  let numOfTotalReview: Int
  
  let avgPoint: Float
  
  init(with json: JSON) {
    numOfTotalReview = json["totalReview"].intValue
    avgPoint = json["avgPoint"].floatValue

    self.reviews = json["reviews"].arrayValue.map {
      
      PlaceReview(with: $0)
    }
  }
}

struct PlaceReview {
  
  let id: String
  
  let point: Int
  
  let imagesURL: [String]
  
  let satisfactionList: [SatisfactionType]
  
  let description: String
  
  let userId: String
  
  let userNick: String
  
  let numOfLikes: Int
  
  var isLike: Bool
  
  let createdAt: String
  
  init(with json: JSON) {
    
    userNick = json["user"]["nick"].stringValue
    userId = json["user"]["_id"].stringValue
    
    var satisfactionList = [SatisfactionType]()
    
    /**
     FIXME: FlatMap 적용해보기
     */
    for satisfactionString in json["satisfaction"].arrayValue {
      
      if let satisfaction = SatisfactionType(rawValue: satisfactionString.stringValue) {
        satisfactionList.append( satisfaction )
      }
      
    }
    
    self.satisfactionList = satisfactionList
    
    self.point = json["point"].intValue
    self.description = json["text"].stringValue
    self.numOfLikes = json["likeCnt"].intValue
    self.id = json["_id"].stringValue
    
    self.isLike = json["isLike"].boolValue
    
    self.imagesURL = json["imagesUrl"].arrayValue.map { $0.stringValue }
    
    self.createdAt = json["createdAt"].stringValue
  }
}
