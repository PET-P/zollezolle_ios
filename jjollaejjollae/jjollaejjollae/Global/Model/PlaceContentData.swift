//
//  PlaceContentData.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/08.
//

import Foundation

struct PlaceContentData: Codable {
  let location: LocationData
  let address: [String]
  let reviewPoint, reviewCount: Int
  let topReview: [String]
  let imagesID: [String]
  let types, petFacilities, facilities: [String]
  let icons: [String]
  let id, title, contentDescription, phone: String
  let room: [RoomData]
  let category: String
  let menu: [String]
  let createdAt, updatedAt: String
  let v: Int
  
  enum CodingKeys: String, CodingKey {
    case location, address, reviewPoint, reviewCount, topReview
    case imagesID = "imagesId"
    case types, petFacilities, facilities, icons
    case id = "_id"
    case title
    case contentDescription = "description"
    case phone, room, category, menu, createdAt, updatedAt
    case v = "__v"
  }
}
