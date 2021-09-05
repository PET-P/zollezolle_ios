//
//  UILabel+Extension.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/07.
//

import UIKit

extension UILabel {
  
  func titleStyle(text: String) {
      self.text = "\(text)"
      self.font = UIFont.robotoBold(size: 30)
      self.textColor = UIColor.쥐색38
  }
  
  func setLineSpacing(spacing: CGFloat) {
    
    if let text = self.text {
      let attributedString = NSMutableAttributedString(string: text)
      let style = NSMutableParagraphStyle()
      
      style.lineSpacing = spacing
      attributedString.addAttributes([.paragraphStyle: style], range: NSRange(location: 0, length: attributedString.length))
      
      self.attributedText = attributedString
      
      print(self.attributedText)
    }
  }
}
