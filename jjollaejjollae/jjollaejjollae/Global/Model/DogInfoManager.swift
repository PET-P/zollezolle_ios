//
//  DogInfoManager.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/11.
//

import Foundation

class DogInfoManager {
  
  private let defaults = UserDefaults.standard
  private let key = "dogInfo"
  
    
  var dogInfos: [DogInfo] {
    get {
      var dogInfoList: [DogInfo]?
      if let data = defaults.value(forKey: key) as? Data {
        dogInfoList = try? PropertyListDecoder().decode(Array<DogInfo>.self, from: data)
      }
      return dogInfoList ?? []
    }
    set(new) {
      print(new)
      defaults.setValue(try? PropertyListEncoder().encode(new), forKey: key)
      defaults.synchronize()
    }
  }
  
  func updateDogInfo(at index: Int, with dogInfo: DogInfo) {
    var tempDogInfos = dogInfos
    tempDogInfos[index] = dogInfo
    dogInfos = tempDogInfos
  }
  
  var isDogInfosEmpty: Bool {
    return dogInfos.isEmpty
  }
}
