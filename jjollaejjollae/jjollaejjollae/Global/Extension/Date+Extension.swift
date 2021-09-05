//
//  Date+Extension.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/02.
//

import Foundation

extension Date {
    func datePickerToString() -> String {
        //date -> String
        let formatter = DateFormatter()
        let format = "yyyy-MM-dd"
        formatter.dateFormat = format
        let dateString = formatter.string(from: self)
        
        return dateString
    }
    
    func weekDay() -> String {
        //해당 날짜에 대한 요일 구하기
        let weekDay: [String] = ["일", "월", "화", "수", "목", "금", "토"]
        let cal = Calendar(identifier: .gregorian)
        let now = self
        let comps = cal.dateComponents([.weekday], from: now)
        if let days = comps.weekday {
            return weekDay[days-1]
        } else {
            return "잘못된 날짜"
        }
    }
  
  func dateForCalendar() -> String {
    let formatter = DateFormatter()
    let format = "MM.dd"
    formatter.dateFormat = format
    let dateString = formatter.string(from: self)
    return "\(dateString) (\(self.weekDay()))"
  }
    
  func dateForSeachResult() -> String {
    let formatter = DateFormatter()
    let format = "M월 dd일"
    formatter.dateFormat = format
    let dateString = formatter.string(from: self)
    return "\(dateString) (\(self.weekDay()))"
  }
  
  var firstDayOfTheMonth: Date {
    get {
      Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
  }
}
