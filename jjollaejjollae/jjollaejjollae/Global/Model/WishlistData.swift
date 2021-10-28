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
  var folder: [SimpleFolderData]
  let createdAt, updatedAt: String
  let v: Int
  
  enum CodingKeys: String, CodingKey {
    case total, totalCount, folderCount
    case id = "_id"
    case folder, createdAt, updatedAt, userId
    case v = "__v"
  }
}

extension WishlistData {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    total = (try? container.decode([String].self, forKey: .total)) ?? []
    id = (try? container.decode(String.self, forKey: .id)) ?? "1"
    totalCount = (try? container.decode(Int.self, forKey: .totalCount)) ?? 0
    folderCount = (try? container.decode(Int.self, forKey: .folderCount)) ?? 0
    userId = (try? container.decode(String.self, forKey: .userId)) ?? "1"
    updatedAt = (try? container.decode(String.self, forKey: .updatedAt)) ?? ""
    createdAt = (try? container.decode(String.self, forKey: .createdAt)) ?? ""
    v = (try? container.decode(Int.self, forKey: .v)) ?? 0
    folder = (try? container.decode([SimpleFolderData].self, forKey: .folder)) ?? []
  }
}

struct SimpleFolderData: Codable {
  var regions: [String]
  var count: Int
  var id, name: String
  var contents: [String]?
  var startDate, endDate, updatedAt, createdAt: String?
  
  enum CodingKeys: String, CodingKey {
    case regions, count
    case id = "_id"
    case name, startDate, endDate, updatedAt, createdAt, contents
  }
}




