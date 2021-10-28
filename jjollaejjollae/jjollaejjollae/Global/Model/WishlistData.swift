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
  var id, userId: String
  var folder: [FolderData]
  let createdAt, updatedAt: String
  let v: Int
  
  enum CodingKeys: String, CodingKey {
    case total, totalCount, folderCount
    case id = "_id"
    case folder, createdAt, updatedAt, userId
    case v = "__v"
  }
}




