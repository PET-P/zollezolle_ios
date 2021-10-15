//
//  RequestLogginPlugin.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/14.
//

import Foundation
import Moya
import SwiftUI

final class RequestLogginPlugin: PluginType {
  func willSend(_ request: RequestType, target: TargetType) {
    guard let httpRequest = request.request else {
      print("😂invalid Request😂")
      return
    }
    
    let url = httpRequest.description
    let method = httpRequest.httpMethod ?? "unknown method🥲"
    
    var log = " --> \(method) \(url)\n"
    log.append("API: \(target)\n")
    if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
      log.append("header: \(headers)\n")
    }
    
    if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
      log.append("\(bodyString)\n")
    }
    log.append("--> END")
    print(log)
  }

}
