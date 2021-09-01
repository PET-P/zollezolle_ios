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
  
  var customInfoWindowDataSource = CustomInfoWindowDataSource()
  
  internal func setDataList(with data: [SearchResultInfo]) {
    self.dataList = data
  }
  
  private var markers: [NMFMarker]?
  let infoWindow = NMFInfoWindow()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setMarker()
    getInfoMessageWithHandler()
    infoWindow.anchor = CGPoint(x: 0, y: 1)
    infoWindow.dataSource = customInfoWindowDataSource
    infoWindow.offsetX = -40
    infoWindow.offsetY = -5
    infoWindow.touchHandler = {
      [weak self] (overlay: NMFOverlay) -> Bool in
      self?.infoWindow.close()
      return true
    }
    mapView.isRotateGestureEnabled = false
  }
  
  private func setMarker() {
    var markers = [NMFMarker]()
    dataList?.forEach({ info in
      guard let lat = info.coordinate?.0, let lng = info.coordinate?.1 else {
        return}
      let marker = NMFMarker(position: NMGLatLng(lat: lat, lng: lng))
      let imageName = info.sector.ImageDecription
      marker.iconImage = NMFOverlayImage(image: UIImage(named: imageName)!)
      markers.append(marker)
      marker.mapView = mapView
    })
    self.markers = markers
  }
  
  
  func getInfoMessageWithHandler() {
    var number = 0
    markers?.forEach({ marker in
      marker.userInfo = ["tag": number]
      marker.userInfo.updateValue(dataList?[number], forKey: "data")
      marker.touchHandler = {[weak self] (overlay: NMFOverlay) -> Bool in
        if marker.infoWindow == nil {
          self?.infoWindow.open(with: marker)
        } else {
          self?.infoWindow.close()
        }
        print("마커 \(overlay.userInfo["tag"] ?? "tag") 터치됨 ")
        return true
      }
      number += 1
    })
    print("marker \(markers)")
  }
}



