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
  
  @IBOutlet weak var infoView: InfoView!
  
  private var markers: [NMFMarker]?
  let infoWindow = NMFInfoWindow()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setMarker()
    getInfoMessageWithHandler()
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
      marker.touchHandler = {(overlay: NMFOverlay) -> Bool in
        print("마커 \(overlay.userInfo["tag"] ?? "tag") 터치됨 ")
        return false
      }
      number += 1
    })
    print("marker \(markers)")
  }
}

extension SearchMapViewController: NMFMapViewTouchDelegate {
  func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
    infoWindow.close()
    infoWindow.open(with: mapView)
  }
}

