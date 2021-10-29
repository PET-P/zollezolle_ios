//
//  UserReview.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/30.
//

import Foundation
import UIKit
import SwiftyJSON

struct UserReview {
  
  var rating: Int
  
  var satisfactionList: [SatisfactionType]
  
  var reviewImages: [UIImage]
  
  var reviewText: String
  
  var userId: String
  
  var placeId: String
  
  var category: String
  
  enum SatisfactionType: String, CaseIterable {
    
    case service = "서비스"
    case cleanliness = "청결도"
    case mood = "분위기"
    case location = "위치"
  }
}

extension UserReview {
  
  func toDict() -> [String: Any] {
    
    var dict : [String: Any] = [ "point" : self.rating,
                 "imagesUrl" : [],
                 "userId": self.userId,
                 "placeId": self.placeId,
                 "text" : self.reviewText,
                 "category": self.category ]
    
    return dict
  }
}
