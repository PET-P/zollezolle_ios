//
//  DogInfo.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/14.
//

import UIKit

//id값이 없는 pet 정보
struct PetInfo {
  var name: String = ""
  var age: Int?
  var sex: Sex = .male
  var size: Size = .small
  var weight: Double?
  var type: String = "강아지"
  var breed: String?//후에 URL로 변경해아함
  var imageUrl: String?
  var imageData: Data?
  var isRepresent: Bool = false
}

