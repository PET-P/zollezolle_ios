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

enum sectorType: String {
  case accommodation
  case cafe
  case landmark
  case restaurant
}

extension sectorType {
  var ImageDescription: String {
//    switch self {
//    case .accommodation:
//      return "\(self.rawValue)Pin"
//    case .cafe:
//      return "\(self.rawValue)Pin"
//    case .landmark:
//      return "\(self.rawValue)Pin"
//    case .restaurant:
//      return "\(self.rawValue)Pin"
//    }
    return "\(self.rawValue)Pin"
  }
  
  var selectedImageDescription: String {
    return "\(self.ImageDescription)Select"
  }
  
  var wishImageDescription: String {
    return "\(self.rawValue)Wish"
  }
  
  var selectedWishImageDescription: String {
    return "\(self.wishImageDescription)Select"
  }
}

struct SearchResultInfo {
  var id: Int = 1 //여기는 다다를예정
  var sector: sectorType
  var name: String = "아지멍카페"
  var location: String?
  var type: String?
  var points: Double? = 4.9
  var numbers: Int? = 52
  var like: Bool = false
  var days: Int?
  var prices: Int?
  var coordinate: (Double, Double)
}
//33.40614574885367, 126.44407420606885
//33.45396467876801, 126.62250815524442
//33.37028990621459, 126.6005931315723
//33.33681539828487, 126.48195577546937

//33.20332246996189, 126.27162176088024
//33.557625145656985, 126.79332133931995
//33.32381351706008, 126.84402360014019
//33.35279578591668, 126.18489420947724

class ModelController: NSObject {
  var accommoList = [SearchResultInfo(id: 0, sector: .accommodation, name: "애월코지하우스", location: "제주 애월읍", type: nil, points: 4.7, numbers: 102, days: 1, prices: 85000, coordinate: (33.40614574885367, 126.44407420606885)), SearchResultInfo(id: 1, sector: .accommodation, name: "아지멍카페", location: nil, type: "커피/브런치", points: 4.9, numbers: 52, days: nil, prices: nil, coordinate: (33.45396467876801, 126.62250815524442)), SearchResultInfo(id: 2, sector: .accommodation, name: "애월코지하우스", location: "제주 애월읍", type: nil, points: 4.7, numbers: 102, days: 1, prices: 85000, coordinate: (33.37028990621459, 126.6005931315723)), SearchResultInfo(id: 3, sector: .accommodation, name: "애월코지하우스", location: "제주 애월읍", type: nil, points: 4.7, numbers: 102, days: 1, prices: 85000, coordinate: (33.33681539828487, 126.48195577546937))]
  var cafeList = [SearchResultInfo(id: 0, sector: .cafe, name: "여기는 카페", coordinate: (37.58677761710804, 37.58677761710804)), SearchResultInfo(id: 1, sector: .cafe, coordinate: (37.58677761710804, 37.58677761710804)), SearchResultInfo(id: 2, sector: .cafe, coordinate: (37.58677761710804, 37.58677761710804)), SearchResultInfo(id: 3, sector: .cafe, coordinate: (37.58677761710804, 37.58677761710804))]
  var landmarkList = [SearchResultInfo(id: 0, sector: .landmark, name: "여기는 관광지", coordinate: (37.58677761710804, 37.58677761710804)), SearchResultInfo(id: 1, sector: .landmark, coordinate: (37.58677761710804, 37.58677761710804)), SearchResultInfo(id: 2, sector: .landmark, coordinate: (37.58677761710804, 37.58677761710804)), SearchResultInfo(id: 3, sector: .landmark, coordinate: (37.58677761710804, 37.58677761710804))]
  var restaurantList = [SearchResultInfo(id: 0, sector: .restaurant, name: "여기는 맛집", coordinate: (37.58677761710804, 37.58677761710804)), SearchResultInfo(id: 1, sector: .restaurant, coordinate: (37.58677761710804, 37.58677761710804)), SearchResultInfo(id: 2, sector: .restaurant, coordinate: (37.58677761710804, 37.58677761710804)), SearchResultInfo(id: 3, sector: .restaurant, coordinate: (37.58677761710804, 37.58677761710804))]
}
