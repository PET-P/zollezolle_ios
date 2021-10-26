//
//  LocationName.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/18.
//

import Foundation

enum LocationName: CaseIterable {
  case seoul
  case sokcho
  case gangneung
  case yeosu
  case gyeongju
  case daegu
  case jeju
  
  var description: String {
    
    switch self {
      case .seoul:
        return "서울"
      case .sokcho:
        return "속초"
      case .gangneung:
        return "강릉"
      case .yeosu:
        return "여수"
      case .gyeongju:
        return "경주"
      case .daegu:
        return "대구"
      case .jeju:
        return "제주"
    }
  }
}
