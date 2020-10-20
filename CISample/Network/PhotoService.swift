//
//  PhotoService.swift
//  CISample
//
//  Created by David on 2020/10/15.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation
import Moya

public enum PhotoService {
  case photos
}

extension PhotoService: TargetType {
  public var baseURL: URL {
    return URL(string: "https://jsonplaceholder.typicode.com")!
  }
  
  public var path: String {
    switch self {
    case .photos: return "/photos"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .photos: return .get
    }
  }
  
  public var sampleData: Data {
    return Data()
  }
  
  public var task: Task {
    switch self {
    case .photos: return .requestPlain
    }
  }
  
  public var headers: [String : String]? {
    return ["Content-type": "application/json"]
  }
  
  public var validationType: ValidationType {
    return .successCodes
  }
}

extension PhotoService {
  var testSampleData: Data {
    switch self {
    case .photos:
      return "".data(using: String.Encoding.utf8)!
    }
  }
}

extension PhotoService: MoyaCacheable {
  var cachePolicy: MoyaCacheablePolicy {
    switch self {
    case .photos:
      return .returnCacheDataElseLoad    
    }
  }
}
