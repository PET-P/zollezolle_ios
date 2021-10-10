//
//  LoginData.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/20.
//

import Foundation

struct UserData: Codable {
  let id: String
  let admin: Bool
  let email, nick, accountType: String
  let phone: String?
  let representPet: String?
  var pets: [PetData]
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case admin, email, nick, phone, accountType, pets
    case representPet = "repPetId"
  }
}


