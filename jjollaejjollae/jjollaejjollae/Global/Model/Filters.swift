//
//  Filters.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/27.
//

import Foundation

protocol FilterType {
  associatedtype Key: Hashable
  
  var title: String {get}
  var type: [(key: Key, checked: Bool)] {get set}
}

struct accommodationType: FilterType {
  
  var title: String = "숙소유형"
  var type: [(key: Key, checked: Bool)] = []
  
  enum Key: String {
    case 복층
    case 독채
    case 풀빌라
    case 캠핑
    case 온돌
    case 카라반
    case 한옥
  }
}

struct DogAmenties: FilterType {
  var title: String = "반려동물 편의시설"
  var type: [(key: Key, checked: Bool)] = []
  
  enum Key: String {
    case 드라이룸
    case 샤워장
    case 스파
    case 놀이터
    case 실내수영장
    case 운동장
  }
}

struct PeopleAmenties: FilterType {
  var title: String = "편의시설"
  var type: [(key: Key, checked: Bool)] = []
  
  enum Key: String {
    case 개별바베큐
    case 수영장
    case 스파
    case 아침식사
    case 엘리베이터
    case 노래방
    case 피트니스
    case 주방
  }
}
