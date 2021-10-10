//
//  PostData.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/07.
//

import Foundation


struct PostDatas: Codable {
  // 여기 영욱이가 한번 더 감싸주면 좋긴하겟다
}

struct PostData: Codable {
  var id: String
  var title: String
  var text: String
  var subContents: [ContentsData]
  var createdAt: String
  var updatedAt: String
  var v: Int
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case title, text, subContents, createdAt, updatedAt
    case v = "__v"
  }
}


