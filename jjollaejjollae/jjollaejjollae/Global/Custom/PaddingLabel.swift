//
//  PaddingLabel.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/09.
//

import UIKit

//@IBDesignable
class PaddingLabel: UILabel {
  
  @IBInspectable var topInset: CGFloat = 5.0
  @IBInspectable var bottomInset: CGFloat = 5.0
  @IBInspectable var leftInset: CGFloat = 8.0
  @IBInspectable var rightInset: CGFloat = 8.0
  
  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    super.drawText(in: rect.inset(by: insets))
  }
  
  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
  }
}
