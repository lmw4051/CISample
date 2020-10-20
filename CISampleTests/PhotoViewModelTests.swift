//
//  PhotoViewModelTests.swift
//  CISampleTests
//
//  Created by David on 2020/10/18.
//  Copyright © 2020 David. All rights reserved.
//

import XCTest
import Moya
@testable import CISample

class PhotoViewModelTests: XCTestCase {
  var sut: PhotoViewModel!
  var mockManager: MockNetWorkManager!
  
  override func setUp() {
    super.setUp()
    mockManager = MockNetWorkManager()
    sut = PhotoViewModel(networkManager: mockManager)
  }
  
  override func tearDown() {
    mockManager = nil
    sut = nil
    super.tearDown()
  }
  
  func test_getPhoto() {
    // given
    mockManager.completePhotos = [Photo]()
    
    // when
    sut.initFetch()
    
    // then
    XCTAssert(mockManager.isGetPhotoCalled)
  }
  
  func test_create_cellViewModel() {
    // given
    let photos = StubGenerator().stubPhotos()
    mockManager.completePhotos = photos
    let expect = XCTestExpectation(description: "reload closure triggered")
    sut.reloadCollectionViewClosure = {
      expect.fulfill()
    }
    
    // when
    sut.initFetch()
    mockManager.fetchSuccess()
    
    wait(for: [expect], timeout: 1.0)
    XCTAssertEqual(sut.numberOfCells, photos.count)
  }
  
  func test_loading_whenFetching() {
    // given
    var loadingStatus = false
    let expect = XCTestExpectation(description: "Loading status updated")
    sut.updateLoadingStatus = { [weak sut] in
      loadingStatus = sut!.isLoading
      expect.fulfill()
    }
    
    // when
    sut.initFetch()
    
    // then
    wait(for: [expect], timeout: 1.0)
    mockManager.fetchSuccess()
    XCTAssertFalse(loadingStatus)
  }
  
  func test_getCellViewModel() {
    // given
    goToFetchPhotoFinished()
    
    let indexPath = IndexPath(row: 1, section: 0)
    let testPhoto = mockManager.completePhotos[indexPath.row]
    
    // when
    let vm = sut.getCellViewModel(at: indexPath)
    
    // then
    XCTAssertEqual(vm.title, testPhoto.title)
  }
}

extension PhotoViewModelTests {
  private func goToFetchPhotoFinished() {
    mockManager.completePhotos = StubGenerator().stubPhotos()
    sut.initFetch()
    mockManager.fetchSuccess()
  }
}

class MockNetWorkManager: APIServiceProtocol {
  var isGetPhotoCalled = false
  var completePhotos: [Photo] = [Photo]()
  var completeClosure: ((Result<[Photo], MoyaError>) -> ())!
  
  func getPhoto(completion: @escaping (Result<[Photo], MoyaError>) -> Void) {
    isGetPhotoCalled = true
    completeClosure = completion
  }
  
  func fetchSuccess() {
    completeClosure(.success(completePhotos))
  }
  
  func fetchFail(error: MoyaError) {
    completeClosure(.failure(error))
  }
}

class StubGenerator {
  func stubPhotos() -> [Photo] {
    let path = Bundle.main.path(forResource: "content", ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path))
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let photos = try! decoder.decode([Photo].self, from: data)
    return photos
  }
}
