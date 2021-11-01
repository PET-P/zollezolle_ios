//
//  String+Extension.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/27.
//

import Foundation

extension String {
  
  //2021-05-09 형식으로 들어와야함
  func stringToDate() -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = NSTimeZone(name: "UTC")as TimeZone?
    
    let date: Date? = dateFormatter.date(from: self)
    return date
  }
  
  var isNotEmpty: Bool {
    return !self.isEmpty
  }
  
  /**
   
   "yyyy-MM-dd'T'HH:mm:ss.SSSZ" 에서
   "yyyy-MM-dd" 로 변환........
   
   - Author: 박우찬
   */
  
  func stringFromServerToDate(inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outputFormat: String = "yyyy-MM-dd" ) -> String {
    
    
    let serverDateformatter = DateFormatter()

    serverDateformatter.dateFormat = inputFormat
    
    guard let date = serverDateformatter.date(from: self) else { return "날짜를 불러오지 못했습니다" }

    let viewDateFormatter = DateFormatter()

    viewDateFormatter.dateFormat = outputFormat

    let result = viewDateFormatter.string(from: date)
    
    return result 
  }
  
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
  
  func appendedPostPositionTextForCategory() -> String {
    
    if self.isEmpty { return self }
    
    let lastText = self.last!
    
    let unicodeVal = UnicodeScalar(String(lastText))?.value
    
    guard let value = unicodeVal else { return self }
    
    if ( value < 0xAC00 || value > 0xD7A3 ) { return self }
    
    let last = (value - 0xAC00) % 28
    
    let appendingText = last > 0 ? "이": "가"
  
    return self + appendingText
  }

  
}
