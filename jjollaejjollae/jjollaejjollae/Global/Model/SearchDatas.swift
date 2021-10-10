//
//  SearchData.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/07.
//

import Foundation

struct SearchDatas: Codable {
  var searchDatas: [SearchData]
}

struct SearchData: Codable {
  var address: [String]
  var reviewPoint: Int
  var reviewCount: Int
  var id: String
  var title: String
  var category: String
  
  enum CodingKeys: String, CodingKey {
    case address, reviewPoint, reviewCount
    case id = "_id"
    case title, category
  }
}
