//
//  PlaceInfo.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/27.
//

import Foundation

struct PlaceInfo {
  var id: String
  var location: LocationData
  var address: [String]
  var imageUrls: [String]
//  var icons: [Any]?
  var title: String
  var description: String
  var phone: String
//  var menu: [Any]?
  var category: String
//  var room: [Any]?
  var reviews: [Review]
}
