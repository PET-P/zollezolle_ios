//
//  LocationName.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/18.
//

import Foundation

enum LocationName: CaseIterable {
  
  typealias Coordinate = (latitude: Double, longitude: Double)
  
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
  
  var anchorPoint: Coordinate {
    
    // FIXME: ReverseGeoCoding 적용해보기
    /**
     각 지역의 시청, 도청으로 설정함
     */
    switch self {
      case .seoul:
        return (37.56665666626182, 126.9784119250907)
      case .sokcho:
        return (38.20701276339331, 128.59185414802673)
      case .gangneung:
        return (37.752080651577664, 128.87589662031974)
      case .yeosu:
        return (34.76042949174499, 127.66229310625941)
      case .gyeongju:
        return (35.85639766579005, 129.22480299760608)
      case .daegu:
        return (35.87144957195142, 128.6016636922418)
      case .jeju:
        return (33.489055392737775, 126.49840692638672)
    }
  }
}
