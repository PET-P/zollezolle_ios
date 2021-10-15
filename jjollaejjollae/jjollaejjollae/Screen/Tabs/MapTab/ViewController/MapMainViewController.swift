//
//  MyNeighborhoodMainViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/09.
//

import UIKit
import NMapsMap

class MapMainViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var mapView: NMFMapView!
  
  @IBOutlet weak var locationSelectButton: UIButton!
  
  @IBOutlet weak var filterScrollView: UIScrollView!
  
  @IBOutlet weak var containerView: UIView!
  
  // MARK: - Properties
  
  private var containerViewHeightConstraint: NSLayoutConstraint?
  
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
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    setUpLocationSelectButton()
    
    setUpFilterScrollView()
    
    setUpFilterStackView()
    
    setUpContainerView()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let vc = segue.destination as? RecommendedPlaceViewController {
      vc.mapMainVC = self
    }
    
  }
  
  // MARK: - Customs
  
  private func setUpLocationSelectButton() {
    
    locationSelectButton.layer.cornerRadius = 10
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
}

extension MapMainViewController: StoryboardInstantiable { }
