//
//  UIButton+Extension.swift
//  jjollaejjollae
//
//  Created by abc on 2021/07/30.
//

import UIKit

extension UIButton {
  func roundedButton(cornerRadius: CGFloat?){
    
    if let cornerRadius_ = cornerRadius {
      self.layer.cornerRadius = cornerRadius_
    } else {
      self.layer.cornerRadius = self.layer.frame.height / 2
    }
    self.layer.masksToBounds = true
  }
  func underLine(buttonString: String){
    let attributes: [NSAttributedString.Key : Any] = [
      .underlineStyle : NSUnderlineStyle.thick.rawValue,
      .foregroundColor : UIColor.gray03
    ]
    let attributeString = NSAttributedString(string: buttonString, attributes: attributes)
    self.setAttributedTitle(attributeString, for: .normal)
  }
}

extension UIButton {
  func setBackgroundColor(color: UIColor, stokeColor: UIColor, forState: UIControl.State) {
    self.clipsToBounds = true  // add this to maintain corner radius
//    self.setBorder(borderColor: stokeColor, borderWidth: 1)
    UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
    if let context = UIGraphicsGetCurrentContext() {
      context.setFillColor(color.cgColor)
      context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
      let colorImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      self.setBackgroundImage(colorImage, for: forState)
    }
  }
}
