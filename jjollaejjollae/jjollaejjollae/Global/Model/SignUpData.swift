//
//  SignUp.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/20.
//

import Foundation

struct SignUpData: Codable {
  let id: String?
  let accessToken: String?
  let refreshToken: String?
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
  }
}


