//
//  LoginData.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/20.
//

import Foundation

struct User: Codable {
  let id: String
  let admin: Bool
  let email, nick, phone, accountType: String
  let pets: [Pet]?
  let createdAt, updatedAt: String
  let v: Int
  let accessToken, refreshToken: String
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case admin, email, nick, phone, accountType, pets, createdAt, updatedAt
    case v = "__v"
    case accessToken, refreshToken
  }
}

struct Pet: Codable {
  let age: Int?
  let size: String?
  let id, name, sex, type: String?
  let breed: String
  let weight: Double?
  let updatedAt, createdAt: String
  
  enum CodingKeys: String, CodingKey {
    case age, size
    case id = "_id"
    case name, sex, type, breed, weight, updatedAt, createdAt
  }
}
