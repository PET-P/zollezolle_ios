//
//  Category.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/21.
//

import Foundation

enum CategoryType: String, Codable {
  case accommodation = "숙소"
  case cafe = "카페"
  case landmark = "명소"
  case restaurant = "식당"
  case unknown
}

extension CategoryType {

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    guard let value = try? container.decode(String.self) else {
      self = .unknown
      return
    }
    self = CategoryType(rawValue: value) ?? .unknown
  }

  var ImageDescription: String {
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
