//
//  MoyaCacheable.swift
//  CISample
//
//  Created by David on 2020/10/20.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

protocol MoyaCacheable {
  typealias MoyaCacheablePolicy = URLRequest.CachePolicy
  var cachePolicy: MoyaCacheablePolicy { get }
}
