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
  
  /**
  레이블의 줄 간격을 설정한다
   - Author : 우찬
   - Note : AttributedText 가 우선순위를 가질 때 효과가 적용된다.
   */
  func setLineSpacing(spacing: CGFloat) {
    
    if let text = self.text {
      let attributedString = NSMutableAttributedString(string: text)
      let style = NSMutableParagraphStyle()
      
      style.lineSpacing = spacing
      attributedString.addAttributes([.paragraphStyle: style], range: NSRange(location: 0, length: attributedString.length))
      
      self.attributedText = attributedString
    }
  }
  
  /**
   레이블의 자간을 설정한다
   - Author : 우찬
   - Note : AttributedText 가 우선순위를 가질 때 효과가 적용된다.
   */
  func setKern(value: NSNumber) {
    
    if let text = self.text {
      
      let attributedString = NSMutableAttributedString(string: text)
      
      attributedString.addAttributes([.kern: value], range: NSRange(location: 0, length: attributedString.length))
      
      self.attributedText = attributedString
    }
  }
  
  func setUnderLine() {
    if let text = self.text {
      
      let attributedString = NSMutableAttributedString(string: text)
      
      attributedString.addAttributes([.underlineStyle : NSUnderlineStyle.single], range: NSRange(location: 0, length: attributedString.length))
      
      self.attributedText = attributedString
    }
  }
}
