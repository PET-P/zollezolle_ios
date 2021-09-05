//
//  BasicInfoView.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/09/05.
//

import UIKit
import NMapsMap
class DetailPlaceBasicInfoView: UIView {
  
  @IBOutlet weak var mapBackView: UIView!
  
  @IBOutlet weak var basicInformationTitleLabel: UILabel!
  
  @IBOutlet weak var phoneNumberLabel: UILabel!
  
  @IBOutlet weak var roadAddressLabel: UILabel!
  
  @IBOutlet weak var jibunAddressLabel: UILabel!
  
  
  // MARK: - Properties
  
  private var mapView: NMFMapView?
  
  // MARK: - Life Cycle
  
  override func awakeFromNib() {
    
    setUpMapView()
    
    setUpBasicInfoTitleLabel()
    
    // TODO: 내용을 변경해야한다. VC 에서 호출해주어야한다.
//    setUpPhoneNumberButton()
    
    setUpLayoutConstraints()
  }

  // MARK: - Custom Methods
  
  internal func setPhoneNumberLabelText(with phoneNumber: String?) {
    
    phoneNumberLabel.text = phoneNumber ?? "000-0000-0000"
    phoneNumberLabel.setUnderLine()
  }
  
  internal func setLocationLabelText(roadAddress: String?, jibunAddress: String?) {
    
    roadAddressLabel.text = roadAddress ?? "불러오기 실패"
    jibunAddressLabel.text = jibunAddress ?? "불러오기 실패"
  }
  
  private func setUpMapView() {
    let mapView = NMFMapView()
    
    mapBackView.addSubview(mapView)
    
    mapView.translatesAutoresizingMaskIntoConstraints = false
    
    // TODO: Need Snapkit Refactoring
    
    mapView.leadingAnchor.constraint(equalTo: mapBackView.leadingAnchor).isActive = true
    
    mapView.topAnchor.constraint(equalTo: mapBackView.topAnchor).isActive = true
    
    mapView.trailingAnchor.constraint(equalTo: mapBackView.trailingAnchor).isActive = true
    
    mapView.bottomAnchor.constraint(equalTo: mapBackView.bottomAnchor).isActive = true
    
    mapView.disableUserInteraction()
    
    mapView.isUserInteractionEnabled = false
    
    self.mapView = mapView
  }
  
  private func setUpBasicInfoTitleLabel() {
    
    let title = "기본정보"
    
    self.basicInformationTitleLabel.text = title
    
    self.basicInformationTitleLabel.font = UIFont.robotoBold(size: 20)
  }
  
  private func setUpPhoneNumberLabel() {
    
    phoneNumberLabel.setUnderLine()
  }
  
  private func setUpLayoutConstraints() {
    
    let heightConstraint = self.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
    
    heightConstraint.isActive = true
  }
}

// MARK: - NibInstantiatable
extension DetailPlaceBasicInfoView: NibInstantiatable { }

// MARK: - NMFMapView Extension
// TODO: 뷰 자체의 userInteraction 을 끄면되서 반드시 필요한지 고민해봐야한다.
extension NMFMapView {
  
  func disableUserInteraction() {
    
    self.allowsScrolling = false
    self.allowsZooming = false
    self.allowsTilting = false
    self.allowsTilting = false
  }
}
