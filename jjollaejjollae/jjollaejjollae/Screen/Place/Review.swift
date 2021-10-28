//
//  Review.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/27.
//

import Foundation

struct Review {
  var id: String
  var point: Int
  var imageURLs: [String]
  var text: String
  var createdAt: String
  var nickname: String
  
  var createdDate: Date {
    // DateFormatter 사용해서
    // createdAt 정제
    return Date()
  }
}
