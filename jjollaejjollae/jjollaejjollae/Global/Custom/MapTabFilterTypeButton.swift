//
//  FilterTypeButton.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/09/19.
//

import UIKit

final class MapTabFilterTypeButton : UIButton
{
  // MARK: - Properties
  // figma defined value
  private let verticalPadding: CGFloat = 8
  private let horizontalPadding: CGFloat = 24
  
  override var intrinsicContentSize: CGSize {
    
    get {
      let baseSize = super.intrinsicContentSize

      return CGSize(width: baseSize.width + (horizontalPadding * 2),
                    height: baseSize.height + (verticalPadding * 2))
    }
  }
  
  internal var filterType: FilterType {
    return FilterType(rawValue: self.title(for: .normal)!)!
  }
  
  override var isSelected: Bool {
    didSet {
      let colorWhenSelected: UIColor = self.filterType == .위시리스트 ? .themeYellow : .themePaleGreen
      
      self.backgroundColor = isSelected ? colorWhenSelected : .white
    }
  }
  
  // MARK: - Initializers
  override init(frame: CGRect) {
    
    super.init(frame: frame)
    self.widthAnchor.constraint(greaterThanOrEqualToConstant: self.intrinsicContentSize.width).isActive = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MapTabFilterTypeButton {
  
  enum FilterType: String, CaseIterable {
    case 맛집
    case 관광지
    case 카페
    case 숙소
    case 위시리스트
  }
}
