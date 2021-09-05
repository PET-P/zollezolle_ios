//
//  DetailPlaceProtocols.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/23.
//


/// Detail-Accomodations 에서 UI 구성을 위해 사용하는 모델 타입

import UIKit

protocol DetailPlaceType {
  
  var name: String { get }                // 장소 이름
  var location: String {get}              // 도로명 주소
  var averageRating: Float { get }        // 평균 평점 (단위: 별)
  var reviews: [ReviewType]? { get }      // 리뷰
  var customInfo: String? { get }         // 장소 관련자가 직접 입력하는 장소 소개
  var basicInfo: BasicInfoType { get }    // 장소 기본 정보
}

protocol ReviewType {
  
  var userID: String { get }
  var rating: Float { get }
  var date: Date { get }
  
  // TODO: UIImage 를 안지게 할 수 있는 방법이 있을까?
  // 모델은 UI에 대해서 몰라야 한다.
  var images: [UIImage] { get }
}

protocol BasicInfoType {
  // TODO: 좌표가 필요한가? 주소명만 가지고 있으면 되지 않을까?
  // TODO: 그렇다면 location 은 계산속성으로 구현
  var coordination: String { get }
  var phoneNumber: String { get }
}

struct TestDetailPlace: DetailPlaceType {
  
  var name: String
  
  var location: String {
    return basicInfo.coordination
  }
  
  var averageRating: Float
  
  var reviews: [ReviewType]?
  
  var customInfo: String?
  
  var basicInfo: BasicInfoType
}

struct TestReview: ReviewType {
  
  var userID: String
  
  var rating: Float
  
  var date: Date
  
  var images: [UIImage]
}

struct TestBasicInfo: BasicInfoType {
  
  var coordination: String
  
  var phoneNumber: String
}
