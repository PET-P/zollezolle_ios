//
//  MyNeighborhoodMainViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/09.
//

import UIKit
import NMapsMap

final class MapMainViewController: UIViewController, StoryboardInstantiable {
  
  // MARK: - Variable
  
  private let locationService: LocationService = LocationService.shared
  
  private var currentLocation: (latitude: Double, longitude: Double)? {
    didSet {
      
      guard let currentLocation = currentLocation else { return }
      
      locationOverlay?.location = NMGLatLng(lat: currentLocation.latitude, lng: currentLocation.longitude)
      
      let latlng = NMGLatLng(lat: currentLocation.latitude, lng: currentLocation.longitude)
      let cameraUpdate = NMFCameraUpdate(scrollTo: latlng)
      
      mapView.moveCamera(cameraUpdate)
    }
  }
  
  @IBOutlet weak var mapView: NMFMapView! {
    
    didSet {
      
      locationOverlay = mapView.locationOverlay
      mapView.logoAlign = .rightBottom
    }
  }
  
  var locationOverlay: NMFLocationOverlay? {
    
    /**
     오버레이 초기 값은 서울시청임
     */
    
    didSet {
      locationOverlay?.hidden = false
      
      locationOverlay?.icon = NMFOverlayImage(image: UIImage(named: "locationOverlayIcon") ?? UIImage(systemName: "circle.circle.fill")!)
      
      locationOverlay?.location = NMGLatLng(lat: LocationName.seoul.anchorPoint.latitude, lng: LocationName.seoul.anchorPoint.longitude)
    }
  }
  
  let mapDefautlZoomLevel: Double = 13
  
  
  @IBOutlet weak var locationSelectTextField: UITextField! {
    didSet {
      
      locationSelectTextField.delegate = self
      
      locationSelectTextField.superview!.layer.masksToBounds = true
      
      locationSelectTextField.superview!.layer.cornerRadius = 10
      
      locationSelectTextField.placeholder = " 지역 선택"
      
      locationSelectTextField.textAlignment = .center
      
      locationSelectTextField.inputView = locationPickerView
      locationSelectTextField.inputAccessoryView = locationPickerView.toolbar
      
      locationPickerView.reloadAllComponents()
      
      /**
      커서 지우기
       */
      locationSelectTextField.tintColor = .clear
      
    }
  }
  
  lazy var locationPickerView: ToolbarPickerView = {
    
    let pickerView = ToolbarPickerView()
    
    pickerView.dataSource = self
    pickerView.delegate = self
    pickerView.toolbarDelegate = self
    

    
    return pickerView
  }()
  
  @IBOutlet weak var filterScrollView: UIScrollView!
  
  @IBOutlet weak var currentLocationButton: UIButton!
  
  @IBOutlet weak var containerView: UIView!
  
  // MARK: - Properties
  
  @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
  
  let containerViewOriginalHeight: CGFloat = 240
  
  var containerViewMaximumHeight: CGFloat {
    
    get {
      
      view.frame.maxY - filterScrollView.frame.minY
    }
  }
  
  private var filterButtonStackView: UIStackView {
    get {
      
      let filterButtonStackView = filterScrollView.subviews.first as! UIStackView
      
      return filterButtonStackView
    }
  }
  /**
   근처장소모델리스트
   */
  
  var nearPlaceList: [SearchResultData] = [] {
    
    didSet {
      
      bottomSheetViewController?.nearPlaceList = nearPlaceList
      
      var markerList: [NMFMarker] = []

      /**
       SearchResultData 에 좌표값이 제대로 들어있어야 작동함
       - .location.coordinates << 요위치
       */

      nearPlaceList.forEach { resultData in

        let coordinate = resultData.location.coordinates

        guard coordinate.count == 2 else { return }

        let latiitude = coordinate[1]
        let longitude = coordinate[0]

        let marker = NMFMarker(position: NMGLatLng(lat: latiitude, lng: longitude))
        
        if let image = UIImage(named: resultData.category.ImageDescription) {
          marker.iconImage = NMFOverlayImage(image: image)
        }
        
        markerList.append(marker)
      }

      nearPlaceMarkerList = markerList
    }
  }
  
  
  var nearPlaceMarkerList: [NMFMarker] = [] {
    /**
    기존 마커는 맵뷰에서 지운다
     */
    willSet {
      nearPlaceMarkerList.forEach { marker in
        marker.mapView = nil
      }
    }
    
    /**
    새 마커를 맵뷰에 추가한다
     */
    didSet {
      nearPlaceMarkerList.forEach { marker in
        marker.mapView = mapView
      }
    }
  }
  
  var bottomSheetViewController: RecommendedPlaceViewController? {
    
    guard let vc = self.children.first! as? RecommendedPlaceViewController else { return nil }
    
    return vc
    
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    addObservers()
    
    setUpInitialUserLocation()
    
    setUpFilterScrollView()
    
    setUpFilterStackView()
    
    setUpContainerView()
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let vc = segue.destination as? RecommendedPlaceViewController {
      
      vc.mapMainVC = self
      vc.nearPlaceList = nearPlaceList
    }
    
  }
  
  // MARK: - IBAction
  
  @IBAction func didTapCurrentLocationButton(_ sender: Any) {
    
    locationService.updateCurrentLocation()
  }
  
  
  // MARK: - Customs
  
  func addObservers() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(onUpdateCurrentLocation(noti:)), name: LocationService.didUpateCurrentLocation, object: nil)
    
  }
  
  func setUpInitialUserLocation() {
    
    currentLocation = (locationService.currentLocation.latitude , locationService.currentLocation.longitude)
    
    guard let currentLocation = currentLocation else { return }
    
    fetchNearPlaces(with: (currentLocation.latitude, currentLocation.longitude))
  }
  
  
  /**
    스크롤 뷰 설정 메서드
   */
  private func setUpFilterScrollView() {
    
    filterScrollView.contentInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
    
    filterScrollView.showsHorizontalScrollIndicator = false
  }
  
  /**
   스크롤 뷰의 서브 뷰인 필터스택 뷰 설정 메서드
   */
  private func setUpFilterStackView() {
    
//    guard let filterButtonStack = filterButtonStackView else { fatalError(#function) }
    
    filterButtonStackView.backgroundColor = .clear
    filterButtonStackView.spacing = 8
    
    for filterType in MapTabFilterTypeButton.FilterType.allCases {
      
      let button = makeFilterButton(of: filterType)
      filterButtonStackView.addArrangedSubview(button)
    }
  }
  
  /**
    필터 버튼 생성 메서드
   */
  private func makeFilterButton(of filterType: MapTabFilterTypeButton.FilterType) -> MapTabFilterTypeButton {
    
    let button = MapTabFilterTypeButton()
    
    button.setTitle(filterType.rawValue, for: .normal)
    
    button.setTitleColor(UIColor.gray01, for: .normal)
    button.titleLabel?.font = UIFont.robotoRegular(size: 13)
    
    button.backgroundColor = .white
    
    button.layer.cornerRadius = 10
    
    button.layer.borderColor = UIColor.themePaleGreen.cgColor
    button.layer.borderWidth = 1
    
    button.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
    
    return button
  }

  // 모든 필터 버튼을 해제한다.
  private func deselectAllFilterButton() {
    
//    guard let stackView = filterButtonStackView else { return }
    
    for view in filterButtonStackView.arrangedSubviews {
      guard let button = view as? UIButton else { return }
      button.isSelected = false
    }
  }
  
  private func setUpContainerView() {
    
    setInitialContainerViewHeight()
  }
  
  // TODO: Container View 메서드로 분리해보기
  
  func setInitialContainerViewHeight() {
    
    // TabBarController Delegate Method 최초 호출 시에 필요
    guard let _ = containerView else { return }
    
    invalidateContainerViewHeightConstraint()
    
    containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: containerViewOriginalHeight)
    
    containerViewHeightConstraint?.isActive = true
  }
  
  func setTemporalContainerViewHeight(with constant: CGFloat) {
    
    invalidateContainerViewHeightConstraint()
    
    containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: constant)
    
    containerViewHeightConstraint?.isActive = true
  }
  
  func setMaximumContainerViewHeight() {
    
    invalidateContainerViewHeightConstraint()
    
//    let maximumHeight = view.frame.maxY - filterScrollView.frame.minY
    
    containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: containerViewMaximumHeight)
    
    containerViewHeightConstraint?.isActive = true
  }
  
  func setZeroContainerViewHeight() {
    
    invalidateContainerViewHeightConstraint()
    
    containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: CGFloat.zero)
    
    containerViewHeightConstraint?.isActive = true
  }
  
  func invalidateContainerViewHeightConstraint() {
    if let constraint = containerViewHeightConstraint {
      constraint.isActive = false
    }
  }

  @objc private func didTapFilterButton(sender: MapTabFilterTypeButton) {
    
    if sender.isSelected {
      sender.isSelected.toggle()
      return
    }
    
    deselectAllFilterButton()
    sender.isSelected.toggle()
  }
  
  func fetchNearPlaces(with coordinate: (latitude: Double, longitude: Double)) {
    
    APIService.shared.nearPlace(latitude: coordinate.latitude, longitude: coordinate.longitude) { [weak self](result) in
  
        guard let self = self else {return}
  
        switch result {
  
        case .success(let data):
    
          self.nearPlaceList = data

        case .failure(let error):
            print("error \(error)")
        }
    }
  }
  
  
  @objc func onUpdateCurrentLocation(noti: Notification) {
    
    guard let coordinate = noti.object as? (latitude: Double, longitude: Double) else { return }
    
    currentLocation = (coordinate.latitude, coordinate.longitude)
    
    guard let currentLocation = currentLocation else { return }
    
    fetchNearPlaces(with: (currentLocation.latitude, currentLocation.longitude))
  }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension MapMainViewController: UIPickerViewDataSource, UIPickerViewDelegate, ToolbarPickerViewDelegate  {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return LocationName.allCases.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return LocationName.allCases[row].description
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
//    let locationName = LocationName.allCases[row]
//
//    locationSelectTextField.placeholder = locationName.description
//
//    let (targetLatitude,targetLongitude) = locationName.anchorPoint
//
//    let cameraUpdate =  NMFCameraUpdate.init(position: NMFCameraPosition(NMGLatLng(lat: targetLatitude, lng: targetLongitude),
//                                                                              zoom: mapDefautlZoomLevel))
//
//    mapView.moveCamera(cameraUpdate) { [weak self] value in
//
//      /**
//      카메라의 이동이 사용자 방해없이 완료된 경우
//       */
//      if !value {
//
//        guard let self = self else { return }
//
//        self.fetchNearPlaces(with: (latitude: targetLatitude, longitude: targetLongitude))
//      }
//
//    }
//
//    locationSelectTextField.resignFirstResponder()
  }
  
  func didTapDone() {
    
    let selectedRowIndex = locationPickerView.selectedRow(inComponent: 0)
    
    guard (0 ..< LocationName.allCases.count).contains(selectedRowIndex) else { return }
    
    let (targetLatitude,targetLongitude) = LocationName.allCases[selectedRowIndex].anchorPoint
    
    let cameraUpdate =  NMFCameraUpdate.init(position: NMFCameraPosition(NMGLatLng(lat: targetLatitude, lng: targetLongitude),
                                                                              zoom: mapDefautlZoomLevel))
    
    mapView.moveCamera(cameraUpdate) { [weak self] value in
      /**
      카메라의 이동이 사용자 방해없이 완료된 경우
       */
      if !value {
        
        guard let self = self else { return }
        
        self.fetchNearPlaces(with: (latitude: targetLatitude, longitude: targetLongitude))
      }
    }
    
    locationSelectTextField.placeholder = LocationName.allCases[selectedRowIndex].description
    
    locationSelectTextField.resignFirstResponder()
  }
  
  func didTapCancel() {
    
    locationSelectTextField.resignFirstResponder()
  }
  

}

extension MapMainViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return false
  }
}
