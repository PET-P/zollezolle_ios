//
//  SettingManager.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/20.
//

import Foundation

final class SettingManager {
  static let shared = SettingManager()
  private init() {}
  
  private let defaults = UserDefaults.standard
  
  var alarmControl : Bool {
    get{
      return defaults.bool(forKey: "alarm")
    }
    set {
      defaults.set(newValue, forKey: "alarm")
    }
  }
  
}
