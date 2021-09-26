//
//  DogInfo.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/14.
//

import UIKit


struct PetInfos: Codable {
  var pets: [PetInfo]
}

struct PetInfo: Codable {
  var name: String = ""
  var age: Int?
  var sex: Gender = .male
  var size: Size = .small
  var weight: Double?
  var type: String = "강아지"
  var breed: String?//후에 URL로 변경해아함
//  var imageData: Data?
}

enum Gender: String, Codable{
  case female = "여"
  case male = "남"
}

enum Size: String, Codable {
  case small = "소형"
  case middle = "중형"
  case big = "대형"
}
