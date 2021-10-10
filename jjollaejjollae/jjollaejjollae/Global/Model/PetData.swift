//
//  PetData.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/08.
//

import Foundation

// id는 필수적이고 

struct PetData: Codable {
  let id: String
  var sex: Sex
  var name, type: String
  var size: Size
  var age: Int?
  var breed: String?
  var weight: Double?
  var imageUrl: String? //imageKey값
  
  enum CodingKeys: String, CodingKey {
    case age, size
    case id = "_id"
    case name, sex, type, breed, weight, imageUrl
  }
  
}

enum Sex: String, Codable{
  case female = "여"
  case male = "남"
}

enum Size: String, Codable {
  case small = "소형"
  case middle = "중형"
  case big = "대형"
}
