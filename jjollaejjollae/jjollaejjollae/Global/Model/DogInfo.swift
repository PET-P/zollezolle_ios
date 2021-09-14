//
//  DogInfo.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/14.
//

import UIKit


struct DogInfo {
  var name: String?
  var age: String?
  var gender: Gender = .male
  var size: Size = .small
  var weight: String?
  var type: String = "강아지"
  var typeName: String?
  var imageURL: UIImage? //후에 URL로 변경해아함
  
  enum Gender: Int {
    case female = 0
    case male = 1
  }

  enum Size: String {
    case small = "소형"
    case middle = "중형"
    case big = "대형"
  }
}
