//
//  searchData.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/20.
//

import Foundation

struct SearchData: Codable {
  let region: String
  let result: [SearchResultData]
}

struct SearchResultData: Codable {
  let id: String
  let address: [String]
  let location: LocationData
  let title: String
  let category: CategoryType
  let reviewCount: Int
  let reviewPoint: Double?
  var isWish: Bool?
  let imagesUrl: [String]
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case address, title, category, reviewCount, reviewPoint, isWish, location, imagesUrl
  }
}

extension SearchResultData {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = (try? container.decode(String.self, forKey: .id)) ?? "1"
    address = (try? container.decode([String].self, forKey: .address)) ?? []
    title = (try? container.decode(String.self, forKey: .title)) ?? "쫄래쫄래가 불러오지 못했어요"
    category = (try? container.decode(CategoryType.self, forKey: .category)) ?? CategoryType.unknown
    reviewCount = (try? container.decode(Int.self, forKey: .reviewCount)) ?? 0
    reviewPoint = (try? container.decode(Double.self, forKey: .reviewPoint)) ?? 0.0
    isWish = (try? container.decode(Bool.self, forKey: .isWish)) ?? false
    location  = (try? container.decode(LocationData.self, forKey: .location)) ?? LocationData(type: "Point", coordinates: [127, 36])
    imagesUrl = (try? container.decode([String].self, forKey: .imagesUrl)) ?? []
  }
}
