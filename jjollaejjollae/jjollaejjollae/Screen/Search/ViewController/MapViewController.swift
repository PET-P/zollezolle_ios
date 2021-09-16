//
//  MapViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/01.
//

import UIKit
import NMapsMap

public let DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: 33.41663178725384,
                                                                 lng: 126.54812514934162),
                                                       zoom: 20,
                                                       tilt: 0,
                                                       heading: 0)


class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: NMFMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.barTintColor = UIColor.white
    let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 74, height: 23))
    navTitle.textAlignment = .center
    navTitle.font = .robotoBold(size: 20)
    navTitle.text = "제주도"
    navigationController?.navigationItem.titleView = navTitle
    mapView.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37,
                                     northEastLat: 44.35, northEastLng: 132)
    mapView.moveCamera(NMFCameraUpdate(position: DEFAULT_CAMERA_POSITION))
    mapView.minZoomLevel = 5.0
    mapView.maxZoomLevel = 18.0
    mapView.logoAlign = .rightTop
    mapView.gestureRecognizers?.forEach({ (gesture) in
      gesture.delaysTouchesEnded = false
    })
  }
  
}
