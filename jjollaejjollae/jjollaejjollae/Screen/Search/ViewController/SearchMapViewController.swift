//
//  SearchMapViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/29.
//

import UIKit
import NMapsMap

class SearchMapViewController: MapViewController {
  
  private(set) var dataList: [SearchResultData]?
  
  internal func setDataList(with data: [SearchResultData]) {
    self.dataList = data
  }
  
  @IBOutlet weak var mapInfoView: InfoView! {
    didSet {
      mapInfoView.setRounded(radius: 10)
    }
  }
  @IBOutlet weak var navBar: UINavigationBar!
  
  @IBAction func didTapXButton(_ sender: UIBarButtonItem) {
    //TODO 여기서 통신,데이터 전달 모두일어나야함
    self.dismiss(animated: true, completion: nil)
  }
  
  private var markers: [NMFMarker]?
  override func viewDidLoad() {
    super.viewDidLoad()
    navBar.topItem?.title = "지도로 보기"
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
    mapInfoView.setCallerVC(viewController: self)
  }
  
  deinit {
    markers?.forEach({ (marker) in
      marker.mapView = nil
    })
  }
  
  
  private func setMarker() {
    var markers = [NMFMarker]()
    dataList?.forEach { info in
      let lat = (info.location.coordinates[1])
      let lng = (info.location.coordinates[0])
      let marker = NMFMarker(position: NMGLatLng(lat: lat, lng: lng))
      let imageName = info.category.ImageDescription
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
      marker.userInfo.updateValue(dataList?[number].category.ImageDescription as Any, forKey: "pin")
      marker.userInfo.updateValue(dataList?[number].category.selectedImageDescription as Any,
                                  forKey: "selectedPin")
      marker.touchHandler = {[weak self] (overlay: NMFOverlay) -> Bool in
        if self?.mapInfoView.isHidden == true {
          let data = marker.userInfo["data"] as? SearchResultData
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
            let data = marker.userInfo["data"] as? SearchResultData
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
    guard let dataList = dataList, dataList.count != 0 else {
      return
    }
    // lat 중에 가장 큰것은 first, 가장 작은것은 last
    let latlist = dataList.sorted {
      return $0.location.coordinates.last! > $1.location.coordinates.last!
    }
    // lng중에 가장 큰 것은 first, 가장 작은은 last
    let longlist = dataList.sorted {
      return $0.location.coordinates.first! > $1.location.coordinates.first!
    }
    let minCoord: (Double, Double) = (latlist.last!.location.coordinates.last!, longlist.last!.location.coordinates.first!)
    let maxCoord: (Double, Double) = (latlist.first!.location.coordinates.last!, longlist.first!.location.coordinates.first!)
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


