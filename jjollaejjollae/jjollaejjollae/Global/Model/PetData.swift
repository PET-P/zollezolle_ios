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
  var isRepresent: Bool
  
  enum CodingKeys: String, CodingKey {
    case age, size
    case id = "_id"
    case name, sex, type, breed, weight, imageUrl, isRepresent
  }
}

extension PetData {
  init(from decoder: Decoder) throws {
    let value = try decoder.container(keyedBy: CodingKeys.self)
    id = (try? value.decode(String.self, forKey: .id)) ?? "1"
    sex = (try? value.decode(Sex.self, forKey: .sex)) ?? Sex.male
    size = (try? value.decode(Size.self, forKey: .size)) ?? Size.small
    name = (try? value.decode(String.self, forKey: .name)) ?? "쫄래쫄래1"
    type = (try? value.decode(String.self, forKey: .type)) ?? "강아지"
    age = try? value.decode(Int.self, forKey: .age)
    breed = try? value.decode(String.self, forKey: .breed)
    weight = try? value.decode(Double.self, forKey: .weight)
    imageUrl = try? value.decode(String.self, forKey: .imageUrl)
    isRepresent = (try? value.decode(Bool.self, forKey: .isRepresent)) ?? false
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
