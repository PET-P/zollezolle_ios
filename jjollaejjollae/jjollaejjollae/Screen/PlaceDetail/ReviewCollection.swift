//
//  ReviewCollection.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/28.
//

import Foundation

struct ReviewCollection: ReviewListDataType {

  var value: [Review]
  
  static let mock = ReviewCollection( value: generateMockReview(number: 10))
  
  static func generateMockReview(number: Int = 10) -> [Review] {
    
    var resultList = [Review]()
    
    guard number > 0 else { return resultList }
    
    for count in (1...number) {
      let id = count
      let point = (1...5).randomElement()
      let imageURLs = ""
      let text = ""
      let createdAt = ""
      let nickName = "mock"
      
      let review = Review(id: "\(id)", point: point!, imageURLs: [imageURLs], text: text, createdAt: createdAt, nickname: nickName)
      
      resultList.append(review)
    }
    
    return resultList
  }
}
