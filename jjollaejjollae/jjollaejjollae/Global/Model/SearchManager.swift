//
//  SearchManager.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/15.
//

import Foundation

struct SearchManager {
  private var recentSearchArray: [String] = ["제주도 풀빌라", "제주도"]
  private var starSearchArray: [String] = ["제주도", "속초 설악벨리"]
  private let defaults = UserDefaults.standard
  
  init() {
    saveSearchHistory(with: nil)
    getStarSearchArray()
  }
  
  // 10가 넘어가면 하나 빼고 다시 넣기
  mutating func saveSearchHistory(with content: String?) {
    if let content = content {
      if recentSearchArray.count > 9 {
        self.recentSearchArray.removeFirst()
        self.recentSearchArray.append(content)
      } else {
        self.recentSearchArray.append(content)
      }
    }
    defaults.set(recentSearchArray, forKey: "recentHistoryKey")
    NotificationCenter.default.post(name: Notification.Name("updateListNotification"), object: nil)
  }
  
  mutating func updateSearchHistory(with array: [String]?) {
    if let array = array {
      recentSearchArray = array
    }
    defaults.set(recentSearchArray, forKey: "recentHistoryKey")
  }
  
  mutating func getStarSearchArray() {
    //TODO: 인기 10개 서버에서 받아오기
    defaults.set(starSearchArray, forKey: "starSearchKey")
  }
  
  func retrieveSearchHistory() -> [String]{
    return defaults.array(forKey: "recentHistoryKey") as? [String] ?? []
  }
  
  func retrieveStarSearchArray() -> [String] {
    return defaults.array(forKey: "starSearchKey") as? [String] ?? []
  }
  
}
