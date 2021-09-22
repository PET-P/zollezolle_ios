//
//  NetworkResult.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/20.
//

import Foundation

enum NetworkResult<T> {
  case success(T)
  case failure(Int)
}
