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
}
