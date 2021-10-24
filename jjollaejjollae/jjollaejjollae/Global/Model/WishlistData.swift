//
//  WishlistData.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/08.
//

import Foundation

struct WishlistData: Codable {
  var total: [String]
  var totalCount: Int
  var folderCount: Int
  var id, userID: String
  var folder: [FolderData]
  let createdAt, updatedAt: String
  let v: Int
  
  enum CodingKeys: String, CodingKey {
    case total, totalCount, folderCount
    case id = "_id"
    case userID = "userId"
    case folder, createdAt, updatedAt
    case v = "__v"
  }
}




