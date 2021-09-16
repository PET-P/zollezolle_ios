//
//  SearchMapViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/29.
//

import UIKit
import NMapsMap

class SearchMapViewController: MapViewController {
  
  private(set) var dataList: [SearchResultInfo]?
  
  internal func setDataList(with data: [SearchResultInfo]) {
    self.dataList = data
  }
  
  @IBOutlet weak var mapInfoView: InfoView! {
    didSet {
      mapInfoView.setRounded(radius: 10)
    }
  }
  
  private var markers: [NMFMarker]?
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "제주도"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    mapView.touchDelegate = self
    setMarker()
    getInfoMessageWithHandler()
    mapExtent()
    mapInfoView.isHidden = true
    mapInfoView.isUserInteractionEnabled = true
    mapView.isRotateGestureEnabled = false
  }
  
  deinit {
    markers?.forEach({ (marker) in
      marker.mapView = nil
    })
  }
  
  private func setMarker() {
    var markers = [NMFMarker]()
    dataList?.forEach { info in
      let lat = info.coordinate.0
      let lng = info.coordinate.1
      let marker = NMFMarker(position: NMGLatLng(lat: lat, lng: lng))
      let imageName = info.sector.ImageDecription
      marker.iconImage = NMFOverlayImage(image: UIImage(named: imageName)!)
      markers.append(marker)
      marker.mapView = mapView
    }
    self.markers = markers
  }
  
  func getInfoMessageWithHandler() {
    var number = 0
    var oldMarker = NMFMarker()
    markers?.forEach { marker in
      marker.userInfo = ["tag": number]
      marker.userInfo.updateValue(dataList?[number] as Any, forKey: "data")
      marker.userInfo.updateValue(dataList?[number].sector.ImageDecription as Any, forKey: "pin")
      marker.userInfo.updateValue(dataList?[number].sector.selectedImageDescription as Any,
                                  forKey: "selectedPin")
      marker.touchHandler = {[weak self] (overlay: NMFOverlay) -> Bool in
        if self?.mapInfoView.isHidden == true {
          let data = marker.userInfo["data"] as? SearchResultInfo
          self?.mapInfoView.data = data
          marker.iconImage = NMFOverlayImage(
            image: (UIImage(named: marker.userInfo["selectedPin"] as? String ?? "defaultPin")!))
          oldMarker = marker
          self?.mapInfoView.isHidden = !(self?.mapInfoView.isHidden)!
        } else {
          if marker == oldMarker { //전에 쳣던거랑 같으면
            marker.iconImage = NMFOverlayImage(
              image: (UIImage(named: marker.userInfo["pin"] as? String ?? "defaultPin")!))
            self?.mapInfoView.isHidden = !(self?.mapInfoView.isHidden)!
          } else { //전에 쳤던거랑 다르면
            let data = marker.userInfo["data"] as? SearchResultInfo
            self?.mapInfoView.data = data
            oldMarker.iconImage = NMFOverlayImage(
              image: (UIImage(named: marker.userInfo["pin"] as? String ?? "defaultPin")!))
            marker.iconImage = NMFOverlayImage(
              image: (UIImage(named: marker.userInfo["selectedPin"] as? String ?? "defaultPin")!))
            oldMarker = marker
          }
        }
        return true
      }
      number += 1
    }
  }
  
  private func mapExtent() {
    guard let dataList = dataList else {
      return
    }
    // lat 중에 가장 큰것은 first, 가장 작은것은 last
    let latlist = dataList.sorted {
      return $0.coordinate.0 > $1.coordinate.0
    }
    // lng중에 가장 큰 것은 first, 가장 작은은 last
    let longlist = dataList.sorted {
      return $0.coordinate.1 > $1.coordinate.1
    }
    let minCoord: (Double, Double) = (latlist.last?.coordinate.0 ?? 0,
                                      longlist.last?.coordinate.1 ?? 0 )
    let maxCoord: (Double, Double) = (latlist.first?.coordinate.0 ?? 0 ,
                                      longlist.first?.coordinate.1 ?? 0)
    let distance = distanceBwtPoints(min: minCoord, max: maxCoord)
    let zoomLevel: Double = log2(Double(CGFloat(20088000.56607700 / distance)))
    let middleCoord: (Double, Double) = ((minCoord.0 + maxCoord.0) / 2,
                                         (minCoord.1 + maxCoord.1) / 2)
    let newCameraPosition = NMFCameraPosition(NMGLatLng(lat: middleCoord.0, lng: middleCoord.1), zoom: zoomLevel, tilt: 0, heading: 0)
    mapView.moveCamera(NMFCameraUpdate(position: newCameraPosition))
  }
  
  private func distanceBwtPoints(min: (Double, Double), max: (Double, Double)) -> Double {
    let minLocation: CLLocation = CLLocation(latitude: min.0, longitude: min.1)
    let maxLocation: CLLocation = CLLocation(latitude: max.0, longitude: max.1)
    let distance: CLLocationDistance = maxLocation.distance(from: minLocation)
    return distance 
  }
}

extension SearchMapViewController: NMFMapViewTouchDelegate {
  func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
    print(mapView.zoomLevel)
    markers?.forEach{ marker in
      marker.iconImage = NMFOverlayImage(
        image: (UIImage(named: marker.userInfo["pin"] as? String ?? "defaultPin")!))
    }
    mapInfoView.isHidden = !mapInfoView.isHidden
  }
}


