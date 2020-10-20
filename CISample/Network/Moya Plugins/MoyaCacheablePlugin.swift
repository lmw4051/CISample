//
//  MoyaCacheablePlugin.swift
//  CISample
//
//  Created by David on 2020/10/20.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation
import Moya

final class MoyaCacheablePlugin: PluginType {
  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    if let moyaCachableProtocol = target as? MoyaCacheable {
      var cachableRequest = request
      cachableRequest.cachePolicy = moyaCachableProtocol.cachePolicy
      return cachableRequest
    }
    return request
  }
}
