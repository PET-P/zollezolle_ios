//
//  UserReviewData.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/20.
//

import Foundation

struct UserReviewData: Codable {
  let totalReview, totalLike: Int
  let reviews: [ReviewData]
}

struct ReviewData: Codable {
  let id: String
  let point: Int
  let imagesURL: [String]
  let satisfaction: [String]
  let userID, createdAt: String
  let place: SimplePlaceData
  let text: String
  let likeCnt: [Int]
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case point
    case imagesURL = "imagesUrl"
    case satisfaction
    case userID = "userId"
    case createdAt, place, likeCnt, text
  }
}

struct SimplePlaceData: Codable {
  let id, title: String
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case title
  }
}
