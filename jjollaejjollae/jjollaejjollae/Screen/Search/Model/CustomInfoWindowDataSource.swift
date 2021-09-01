//
//  CustomInfoWindowDataSource.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/01.
//

import UIKit
import NMapsMap

class CustomInfoWindowDataSource:NSObject, NMFOverlayImageDataSource {
  var rootView: InfoView!
  
  func view(with overlay: NMFOverlay) -> UIView {
    //NMFInfoWindow가 있으면 이거쓰고 없으면 rootView가져다써라
    guard let infoWindow = overlay as? NMFInfoWindow else {
      return rootView}
    //rootView가 nil 이면 만들어라!
    if rootView == nil {
      rootView = InfoView()
    }
    
    if infoWindow.marker != nil {
      let data = infoWindow.marker?.userInfo["data"] as? SearchResultInfo
      rootView.addressLabel.text = data?.location
      rootView.locationNameLabel.text = data?.name
      rootView.starPointLabel.text = "\(data?.points ?? 0)"
      rootView.locationImageView.image = UIImage(named: "IMG_4930")
      if data?.like == true {
        rootView.heartButton.setImage(UIImage(named: "pinkLike"), for: .normal)
      } else {
        rootView.heartButton.setImage(UIImage(named: "grayLike"), for: .normal)}
      } else {
        let data = infoWindow.marker?.userInfo["data"] as? SearchResultInfo
        rootView.addressLabel.text = data?.location
        rootView.locationNameLabel.text = data?.name
        rootView.starPointLabel.text = "\(data?.points ?? 0)"
        rootView.locationImageView.image = UIImage(named: "IMG_4930")
        if data?.like == true {
          rootView.heartButton.setImage(UIImage(named: "pinkLike"), for: .normal)
        } else {
          rootView.heartButton.setImage(UIImage(named: "grayLike"), for: .normal)
        }
      }
    let width = rootView.locationImageView.frame.size.width
    rootView.frame = CGRect(x: 0, y: 0, width: width, height: 160)
    rootView.layoutIfNeeded()
    return rootView
  }
}
