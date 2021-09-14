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
      return defaults.array(forKey: key) as? [DogInfo] ?? []
    }
    set(new) {
      defaults.set(new, forKey: key)
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
