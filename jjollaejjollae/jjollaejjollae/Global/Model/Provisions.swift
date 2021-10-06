//
//  Provisions.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/06.
//

import Foundation

enum Provisions: Int, CustomStringConvertible{
  var description: String {
    switch self{
    case .Terms:
      return "이용약관"
    case .Privacy:
      return "개인정보 처리방침"
    }
  }
  
  case Terms
  case Privacy

}

extension Provisions {
  var contents: String {
    switch self{
    case .Terms:
      return "여기에 이용약관을 써놓는다..."
    case .Privacy:
      return "여기에 개인정보처리방침을 써놓는다...."
    }
  }
}
