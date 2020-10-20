//
//  NetworkManager.swift
//  CISample
//
//  Created by David on 2020/10/18.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation
import Moya

protocol APIServiceProtocol {
  func getPhoto(completion: @escaping (Result<[Photo], MoyaError>) -> Void)
}

struct NetworkManager: APIServiceProtocol {
  private let provider: MoyaProvider<PhotoService>
  
  init(provider: MoyaProvider<PhotoService> = MoyaProvider<PhotoService>(plugins: [MoyaCacheablePlugin(), RequestCachePlugin()])) {
    self.provider = provider
  }
  
  func getPhoto(completion: @escaping (Result<[Photo], MoyaError>) -> Void) {
    provider.request(.photos) { result in
      switch result {
      case .success(let response):
        do {
          let photos = try response.map([Photo].self)
          completion(.success(photos))
        } catch let error {
          completion(.failure(error as! MoyaError))
        }
      case .failure(let error):        
        completion(.failure(error))
      }
    }
  }
}
