//
//  DogInfoManager.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/11.
//

import Foundation

struct DogInfo {
  var name: String
  var age: Int
  var gender: Gender
  var size: Size
  var weight: Int
  var type: String
  var imageURL: String
}

enum Gender: Int {
  case male = 0
  case female = 1
}

enum Size: Int {
  case small = 0
  case middle = 1
  case big = 2
}

class DogInfoManager {
  
}
