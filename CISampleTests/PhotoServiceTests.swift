//
//  PhotoServiceTests.swift
//  CISampleTests
//
//  Created by David on 2020/10/18.
//  Copyright © 2020 David. All rights reserved.
//

import XCTest
import Moya
@testable import CISample

class PhotoServiceTests: XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testMoyaRequest() {
    let customEndpointClosure = { (target: PhotoService) -> Endpoint in
      return Endpoint(url: URL(target: target).absoluteString,
                      sampleResponseClosure: { .networkResponse(200, target.testSampleData) },
                      method: target.method,
                      task: target.task,
                      httpHeaderFields: target.headers)
    }
    
    let provider = MoyaProvider<PhotoService>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
    
    let expectation = self.expectation(description: "request")
    _ = provider.request(.photos) { result in
      expectation.fulfill()
    }
    self.waitForExpectations(timeout: 5.0, handler: nil)
  }
}
