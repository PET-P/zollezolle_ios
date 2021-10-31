//
//  PetData.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/08.
//

import Foundation
import CoreMedia

// id는 필수적이고 

struct PetData: Codable, Hashable {
  let id: String
  var sex: Sex
  var name: String?
  var type: String
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
    age = (try? value.decode(Int?.self, forKey: .age)) ?? 1
    breed = (try? value.decode(String?.self, forKey: .breed)) ?? ""
    weight = (try? value.decode(Double?.self, forKey: .weight)) ?? 0.0
    imageUrl = try? value.decode(String?.self, forKey: .imageUrl)
    isRepresent = (try? value.decode(Bool.self, forKey: .isRepresent)) ?? false
  }
}

enum Sex: String, Codable{
  case female = "여"
  case male = "남"
  case unknown
}

extension Sex {
  
  private enum CodingKeys: String, CodingKey {
    case female
    case male
    case unknown
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    guard let value = try? container.decode(String.self) else {
      self = .unknown
      return
    }
    self = Sex(rawValue: value) ?? .unknown
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .female:
      try container.encode("여", forKey: .female)
    case .male:
      try container.encode("남", forKey: .male)
    case .unknown:
      return
    }
  }
  
}

enum Size: String, Codable {
  case small = "소형"
  case middle = "중형"
  case big = "대형"
  case unknown
}

extension Size {
  private enum CodingKeys: String, CodingKey {
    case small
    case middle
    case big
    case unknown
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    guard let value = try? container.decode(String.self) else {
      self = .unknown
      return
    }
    self = Size(rawValue: value) ?? .unknown
  }
  
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .small:
      try container.encode("소형", forKey: .small)
    case .middle:
      try container.encode("중형", forKey: .middle)
    case .big:
      try container.encode("대형", forKey: .big)
    case .unknown:
      return
    }
  }
}
