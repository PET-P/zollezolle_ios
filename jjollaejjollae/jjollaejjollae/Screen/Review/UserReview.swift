//
//  UserReview.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/30.
//

import Foundation
import UIKit
import SwiftyJSON

enum SatisfactionType: String, CaseIterable {
  
  case service
  case cleanliness
  case mood
  case location
  
  var description: String {
    switch self {
      case .service:
        return "서비스"
      case .cleanliness:
        return "청결도"
      case .mood:
        return "분위기"
      case .location:
        return "위치"
    }
  }
}

struct UserReview {
  
  var rating: Int
  
  var satisfactionList: [SatisfactionType]
  
  var reviewImages: [String]
  
  var reviewText: String
  
  var userId: String
  
  var placeId: String
  
  var category: String
  

}

extension UserReview {
  
  func toDict() -> [String: Any] {
    
    let dict: [String: Any] = [ "point" : self.rating,
                 "imagesUrl" : self.reviewImages,
                 "userId": self.userId,
                 "placeId": self.placeId,
                 "text" : self.reviewText,
                 "category": self.category ]
    
    return dict
  }
}
