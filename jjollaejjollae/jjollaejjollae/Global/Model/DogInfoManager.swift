//
//  DogInfoManager.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/11.
//

import Foundation

struct DogInfo {
  var name: String?
  var age: Int?
  var gender: Gender
  var size: Size
  var weight: Int?
  var type: String?
  var imageURL: String?
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
  
  private let defaults = UserDefaults.standard
  private let key = "dogInfo"
  private var dogInfos: [DogInfo]?
  
  func saveDogInfo(with dogInfos: [DogInfo]) {
    defaults.set(dogInfos, forKey: key)
    self.dogInfos = dogInfos
  }
  
  func getDogInfo() -> [DogInfo] {
    return getFromUserDefaults(for: key)
  }
  
  func updateDogInfo(at index: Int, with dogInfo: DogInfo) {
    if var dogInfos = self.dogInfos {
      dogInfos[index] = dogInfo
      defaults.set(dogInfos, forKey: key)
    } else {
      return
    }
  }
  
  private func getFromUserDefaults(for key: String) -> [DogInfo] {
    return defaults.array(forKey: key) as? [DogInfo] ?? []
  }
}
