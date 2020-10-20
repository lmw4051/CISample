//
//  RequestCachePlugin.swift
//  CISample
//
//  Created by David on 2020/10/21.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation
import Moya

public let kCacheStatusCode = 99999
final class RequestCachePlugin:PluginType{
    var url:String = ""
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        print("request")
        var request = request
        request.timeoutInterval = kRequestTimeoutInterval
//        request.cachePolicy = .useProtocolCachePolicy
        return request
    }
    func willSend(_ request: RequestType, target: TargetType) {
        print("willSend")
        url = "\(request)"
    }
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        print("didReceive")
        if case let .success(response) = result{
            if response.statusCode == 200{
                let cache = ZKCache.sharedInstance
                cache.deleteCacheWithKey(key: url)
                cache.saveCacheWithData(cachedData: response.data, key: url)
            }
        }
    }
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        print("process")
        let result = result
        switch result {
        case .success(let response):
            if response.statusCode != 200{
                return readCache(result)
            }else{
                return result
            }
        case .failure(_):
            return readCache(result)
        }
    }
    private func readCache(_ result: Result<Response, MoyaError>)->Result<Response, MoyaError>{
        if kShouldCache{
            let cache = ZKCache.sharedInstance
            let data = cache.fetchCachedDataWithKey(key: url)
            if let dataCata = data{
                let response = Response(statusCode: kCacheStatusCode, data: dataCata)
                return .success(response)
            }else{
                return result
            }
        }
        return result
    }
}

