//
//  LocationService.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/30.
//

import Foundation
import UIKit
import CoreLocation

final class LocationService: NSObject {
  
  typealias Coordinate = (longitude: Double, latitude: Double )
  
  static let shared = LocationService()
  
  private var locationManager = CLLocationManager()
  
  private(set) var currentLocation: Coordinate = (0, 0)
  
  override init() {
    super.init()
    
    locationManager.delegate = self
    
    updateCurrentLocation()
  }
  
  /**
   현재 위치를 반환한다
   */
  
  func updateCurrentLocation() {
    
    locationManager.startUpdatingLocation()
  }
  
}

extension LocationService: CLLocationManagerDelegate {
  
  private func checkUserLocationServicesAuthorization() {
    
    let authorizationStatus: CLAuthorizationStatus
    
    if #available(iOS 14.0, *) {
      
      authorizationStatus = locationManager.authorizationStatus // iOS 14 이상
      
    } else {
      
      authorizationStatus = CLLocationManager.authorizationStatus()
    }

    // iOS 위치 서비스 확인
    
    if CLLocationManager.locationServicesEnabled() {
        // 권한 상태 확인 및 권한 요청 가능
      checkCurrentLocationAuthorization(authorizationStatus)
    } else {
      
      print("iOS 위치 서비스 켜주세요")
    }

  }
  /**
   - 사용자 정의 함수
   - 사용자의 위치 서비스 권한 허용 허부 확인
   // 단, iOS 위치 서비스가 가능한지 확인
   */

  private func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
    
    switch authorizationStatus {
      
      case .notDetermined:
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization() // 앱을 사용하는 동안에 대한 위치 권한 요청
        locationManager.startUpdatingLocation() // 위치 접근 시작!! -> didUpdateLocation 실행
      
      case .restricted, .denied:
        print("denied, 설정으로 유도")
        
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        
      case .authorizedWhenInUse:
        
        locationManager.startUpdatingLocation() // 위치 접근 시작! -> didUpdateLocation 실행
        
      @unknown default:
        print("Default")
    }
    
    if #available(iOS 14.0, *) {
      // 정확도 체크 : 감소, 1시간 4번
      // 감소된 상태에서 제대로 동작하지 않는 앱들이 있다. (예: 미리 알림이 안갈 수 있다)
      let accuracyState = locationManager.accuracyAuthorization
      
      switch accuracyState {
        case .fullAccuracy:
          print("FULL")
        case .reducedAccuracy:
          print("REDUCE")
        @unknown default:
          print("DEFAULT")
      }
    }
    
  }
  
  //4. 사용자가 위치 허용을 한 경우 실행되는 메서드들
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    if let coordinate = locations.last?.coordinate {
      
      //10. 중요
      locationManager.stopUpdatingLocation()
      
      self.currentLocation = (coordinate.longitude, coordinate.latitude)
      
      NotificationCenter.default.post(name: Self.didUpateCurrentLocation, object: self.currentLocation)
      
    } else {
      
      print("Location CanNot Found")
    }
    
  }
  
  //5. 위치를 허용했지만 위치를 못가져오는 상황
  // 예: 비행기모드를 킨 경우
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(#function)
    
  }
  
  /**
   iOS 14 미만 : 앱이 위치 관리자를 생성하고, 승인 상태가 변경이 될때 대리자에게 승인 상태를 알려줌
   */

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    print(#function)
    checkUserLocationServicesAuthorization()
  }
  
  /**
  iOS 14 이상: 앱이 위치 관리자를 생성하고, 승인 상태가 변경이 될 때 대리자에게 승인 상태를 알려줌
   */

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    
    checkUserLocationServicesAuthorization()
  }
}

/**
 Notification.Name
 */
extension LocationService {
  
  static let didUpateCurrentLocation: Notification.Name = Notification.Name.init("didUpateCurrentLocation")
}
