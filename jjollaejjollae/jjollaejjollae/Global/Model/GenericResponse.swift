//
//  GenericResponse.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/20.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
  
  var success: Bool
  var message: String
  var data: T?
  
  enum CodingKeys: String, CodingKey {
    case success = "success"
    case message = "message"
    case data = "data"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    // body에 success가 없다면, fail이라고 생각한다.
    self.success = (try? container.decode(Bool.self, forKey: .success.self)) ?? false
    // body에 message가 없다면 빈 문자열을 빼준다.
    self.message = (try? container.decode(String.self, forKey: .message.self)) ?? " "
    // data 값이 없ㄷㅏ면 nil 반환
    self.data = (try? container.decode(T.self, forKey: .data.self)) ?? nil
  }
}
