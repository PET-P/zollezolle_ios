//
//  ContentsData.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/09.
//

import Foundation

struct ContentsData: Codable {
  var id: String
  var subTitle: String
  var subText: String
  var createdAt: String
  var updatedAt: String
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case subTitle, subText, createdAt, updatedAt
  }
}
