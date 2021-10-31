//
//  PlaceInfo.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/27.
//

import Foundation
import SwiftyJSON

struct PlaceInfo {
  
  typealias LocationData = [Double]
  
  var id: String
  var location: LocationData
  var address: String
  var imageURLs: [String]
//  var icons: [Any]?
  var title: String
  
  var description: String
  
  var phone: String
//  var menu: [Any]?
  var category: String
//  var room: [Any]?
  var reviewList: ReviewListDataType
  
  var reviewPoint: Int
  var reviewCount: Int
}

extension PlaceInfo {
  
  /**
  SwiftyJSON 을 활용한 생성자
  - Author: 박우찬
   */
  
  init(placeID: String, data: JSON) {
    
    let json = JSON(data)
    
    let address = json["address"].arrayValue.map {
      $0.stringValue
    }.joined(separator: " ")
    
    let title = json["title"].stringValue
    
    let imageURLs: [String] = json["imagesUrl"].arrayValue.map {
      $0.stringValue
    }
    
    let phone = json["phone"].stringValue
    
    let description = json["description"].stringValue
    
    let category = json["category"].stringValue
    
    let reviewPoint = json["reviewPoint"].intValue
    let reviewCount = json["reviewCount"].intValue
    
    let location: [Double] = json["location"]["coordinates"].arrayValue.map {
      $0.doubleValue
    }
    
    var reviewList: [Review] = []
    
    for reviewData in json["reviews"].arrayValue {
      
      let review = Review(with: reviewData)
      
      reviewList.append(review)
    }
    
    let reviewCollection: ReviewListDataType = ReviewCollection(value: reviewList)
    
    self.id = placeID
    self.address = address
    self.title = title
    self.imageURLs = imageURLs
    self.phone = phone
    self.description = description
    self.category = category
    self.reviewPoint = reviewPoint
    self.reviewCount = reviewCount
    self.location = location
    self.reviewList = reviewCollection
  }

}
