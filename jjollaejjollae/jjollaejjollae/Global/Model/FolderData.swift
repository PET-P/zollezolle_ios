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
  var id, name: String
  var contents: [SearchResultData]?
  var startDate, endDate, updatedAt, createdAt: String?
  
  enum CodingKeys: String, CodingKey {
    case regions, count
    case id = "_id"
    case name, startDate, endDate, updatedAt, createdAt, contents
  }
}
extension FolderData {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = (try? container.decode(String.self, forKey: .id)) ?? "1"
    name = (try? container.decode(String.self, forKey: .name)) ?? "나만의 위시리스트"
    count =  (try? container.decode(Int.self, forKey: .count)) ?? 0
    regions = (try? container.decode([String].self, forKey: .regions)) ?? []
    contents = (try? container.decode([SearchResultData].self, forKey: .contents)) ?? []
    startDate = (try? container.decode(String.self, forKey: .startDate)) ?? ""
    endDate = (try? container.decode(String.self, forKey: .endDate)) ?? ""
    updatedAt = (try? container.decode(String.self, forKey: .updatedAt)) ?? ""
    createdAt = (try? container.decode(String.self, forKey: .createdAt)) ?? ""
    
  }
}

