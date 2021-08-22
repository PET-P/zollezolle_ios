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
        self.recentSearchArray.removeLast()
        self.recentSearchArray.insert(content, at: 0)
      } else {
        self.recentSearchArray.insert(content, at: 0)
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

struct SearchResultInfo {
  var id: Int = 1 //여기는 다다를예정
  var name: String = "아지멍카페"
  var location: String?
  var type: String?
  var points: Double? = 4.9
  var numbers: Int? = 52
  var like: Bool = false
  var days: Int?
  var prices: Int?
}

class ModelController: NSObject {
  var accommoList = [SearchResultInfo(id: 0, name: "애월코지하우스", location: "제주 애월읍", type: nil, points: 4.7, numbers: 102, days: 1, prices: 85000), SearchResultInfo(id: 1, name: "아지멍카페", location: nil, type: "커피/브런치", points: 4.9, numbers: 52, days: nil, prices: nil), SearchResultInfo(id: 2, name: "애월코지하우스", location: "제주 애월읍", type: nil, points: 4.7, numbers: 102, days: 1, prices: 85000), SearchResultInfo(id: 3, name: "애월코지하우스", location: "제주 애월읍", type: nil, points: 4.7, numbers: 102, days: 1, prices: 85000), SearchResultInfo(id: 666, name: "아지멍카페", location: nil, type: "커피/브런치", points: 4.9, numbers: 52, days: nil, prices: nil), SearchResultInfo(id: 333, name: "아지멍카페", location: nil, type: "커피/브런치", points: 4.9, numbers: 52, days: nil, prices: nil), SearchResultInfo(id: 99), SearchResultInfo(id: 12, name: "애월코지하우스", location: "제주 애월읍", type: nil, points: 4.7, numbers: 102, days: 1, prices: 85000), SearchResultInfo(id: 37, name: "아지멍카페", location: nil, type: "커피/브런치", points: 4.9, numbers: 52, days: nil, prices: nil), SearchResultInfo(id: 1123123, name: "아지멍카페", location: nil, type: "커피/브런치", points: 4.9, numbers: 52, days: nil, prices: nil)]
  var cafeList = [SearchResultInfo(id: 0, name: "여기는 카페"), SearchResultInfo(id: 1), SearchResultInfo(id: 2), SearchResultInfo(id: 3), SearchResultInfo(id: 666), SearchResultInfo(id: 333), SearchResultInfo(id: 99), SearchResultInfo(id: 12), SearchResultInfo(id: 37), SearchResultInfo(id: 1123123)]
  var landmarkList = [SearchResultInfo(id: 0, name: "여기는 관광지"), SearchResultInfo(id: 1), SearchResultInfo(id: 2), SearchResultInfo(id: 3), SearchResultInfo(id: 666), SearchResultInfo(id: 333), SearchResultInfo(id: 99), SearchResultInfo(id: 12), SearchResultInfo(id: 37), SearchResultInfo(id: 1123123)]
  var restaurantList = [SearchResultInfo(id: 0, name: "여기는 맛집"), SearchResultInfo(id: 1), SearchResultInfo(id: 2), SearchResultInfo(id: 3), SearchResultInfo(id: 666), SearchResultInfo(id: 333), SearchResultInfo(id: 99), SearchResultInfo(id: 12), SearchResultInfo(id: 37), SearchResultInfo(id: 1123123)]
}
