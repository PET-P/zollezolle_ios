//
//  Review.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/27.
//

import Foundation
import SwiftyJSON

struct Review {
  
  var id: String
  var point: Int
  var imageURLs: [String]
  var text: String
  var createdAt: String
  var nickname: String
}

extension Review {
  
  /**
  SwiftyJSON 을 활용한 생성자
  - Author: 박우찬
   */
  
  init(with json: JSON) {
    
    let id = json["_id"].stringValue
    let point = json["point"].intValue
    let imageURLs = json["imagesUrl"].arrayValue.map {
      $0.stringValue
    }
    let text = json["text"].stringValue
    let createdAt = json["createdAt"].stringValue
    let nickname = json["nick"].stringValue
    
    self.id = id
    self.point = point
    self.imageURLs = imageURLs
    self.text = text
    self.createdAt = createdAt
    self.nickname = nickname
  }
}
