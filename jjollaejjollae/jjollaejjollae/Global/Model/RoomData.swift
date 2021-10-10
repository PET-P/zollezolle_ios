//
//  RoomData.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/08.
//

import Foundation

struct RoomData: Codable {
  let petFacilities, facilities, icons: [String]
  let id, name: String
  let price: Int
  let createdAt, updatedAt: String
  
  enum CodingKeys: String, CodingKey {
    case petFacilities, facilities, icons
    case id = "_id"
    case name, price, createdAt, updatedAt
  }
}
