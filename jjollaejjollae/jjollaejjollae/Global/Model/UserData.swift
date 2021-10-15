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
  var email, nick: String
  var accountType: AccountType
  var phone: String?
  let representPet: String?
  var pets: [PetData]
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case admin, email, nick, phone, accountType, pets
    case representPet = "repPetId"
  }
}

enum AccountType: String, Codable {
  case local
  case social
  case unknown
}
extension AccountType {
  init(from decoder: Decoder) throws {
    guard let value = try? decoder.singleValueContainer().decode(String.self) else {
      self = .unknown
      return
    }
    self = AccountType(rawValue: value) ?? .unknown
  }
}

