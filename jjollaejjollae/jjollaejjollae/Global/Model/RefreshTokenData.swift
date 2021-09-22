//
//  RefreshTokenData.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/20.
//

import Foundation

struct RefreshTokenData: Codable {
  let success: Bool?
  let message: String?
  let data : TokenData?
}

struct TokenData: Codable {
  let accessToken: String?
}
