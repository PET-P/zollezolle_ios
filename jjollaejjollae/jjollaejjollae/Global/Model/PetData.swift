//
//  PetData.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/08.
//

import Foundation

struct PetData: Codable {
  let id, name, sex, type, size: String
  let age: Int?
  let breed: String?
  let weight: Double?
  let imageUrl: String? //imageKey값
  
  enum CodingKeys: String, CodingKey {
    case age, size
    case id = "_id"
    case name, sex, type, breed, weight, imageUrl
  }
}
