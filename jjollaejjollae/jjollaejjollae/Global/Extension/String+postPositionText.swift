//
//  String+postPositionText.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/18.
//

import Foundation

extension String {
  
  func appendedPostPositionText() -> String {
    
    if self.isEmpty { return self }
    
    let lastText = self.last!
    
    let unicodeVal = UnicodeScalar(String(lastText))?.value
    
    guard let value = unicodeVal else { return self }
    
    if ( value < 0xAC00 || value > 0xD7A3 ) { return self }
    
    let last = (value - 0xAC00) % 28
    
    let appendingText = last > 0 ? "이랑": "랑"
    
    return self + appendingText
  }
}
