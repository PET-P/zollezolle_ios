//
//  SearchManager.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/15.
//

import Foundation

class SearchManager {
  
  static let shared = SearchManager()
  
  private var recentSearchArray: [String] = []
  private var starSearchArray: [String] = ["제주도", "속초 설악벨리"]
  private let defaults = UserDefaults.standard
  
  private init() {
    recentSearchArray = getFromUserDefaults(for: searchKey.recentHistoryKey.rawValue)
    starSearchArray = getFromUserDefaults(for: searchKey.starSearchKey.rawValue)
  }
  
  // 10가 넘어가면 하나 빼고 다시 넣기
  func saveSearchHistory(with content: String?) {
    if let content = content {
      if recentSearchArray.count > 9 {
        self.recentSearchArray.removeFirst()
        self.recentSearchArray.append(content)
      } else {
        self.recentSearchArray.append(content)
      }
    }
    defaults.set(recentSearchArray, forKey: searchKey.recentHistoryKey.rawValue)
    NotificationCenter.default.post(name: Notification.Name("updateListNotification"), object: nil)
  }
  
  func updateSearchHistory(with array: [String]?) {
    if let array = array {
      recentSearchArray = array
    }
    defaults.set(recentSearchArray, forKey: searchKey.recentHistoryKey.rawValue)
  }
  
  private func getStarSearchArray() {
    //TODO: 인기 10개 서버에서 받아오기
    defaults.set(starSearchArray, forKey: searchKey.starSearchKey.rawValue)
  }
  
  func retrieveSearchHistory() -> [String]{
    return recentSearchArray
  }
  
  private func getFromUserDefaults(for key: String) -> [String] {
    return defaults.array(forKey: "\(key)") as? [String] ?? []
  }
  
  func retrieveStarSearchArray() -> [String] {
    return starSearchArray
  }
  
}

extension SearchManager {
  enum searchKey: String {
    case recentHistoryKey
    case starSearchKey
  }
}
