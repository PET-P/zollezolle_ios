//
//  FolderData.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/08.
//

import Foundation

struct FolderData: Codable {
  var regions: [String]
  var count: Int
  var contents: [PlaceContentData]
  var id, name: String
  let startDate, endDate, updatedAt, createdAt: String
  
  enum CodingKeys: String, CodingKey {
    case regions, count, contents
    case id = "_id"
    case name, startDate, endDate, updatedAt, createdAt
  }
}