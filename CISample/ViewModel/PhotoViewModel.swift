//
//  PhotoViewModel.swift
//  CISample
//
//  Created by David on 2020/10/18.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation
import Moya

class PhotoViewModel {
  // MARK: - Properties
  let networkManager: APIServiceProtocol
  private var photos = [Photo]()
  
  private var cellVMs = [PhotoCellViewModel]() {
    didSet {
      self.reloadCollectionViewClosure?()
    }
  }
  
  var isLoading: Bool = false {
    didSet {
      self.updateLoadingStatus?()
    }
  }
  
  var alertMessage: String? {
    didSet {
      self.showAlertClosure?()
    }
  }
  
  var numberOfCells: Int {
    return cellVMs.count
  }
  
  var reloadCollectionViewClosure: (() -> ())?
  var updateLoadingStatus: (() -> ())?
  var showAlertClosure: (() -> ())?
  
  init(networkManager: APIServiceProtocol = NetworkManager()) {
    self.networkManager = networkManager
  }
  
  // MARK: - Helpers
  func initFetch() {
    self.isLoading = true
    
    networkManager.getPhoto { [weak self] result in
      guard let self = self else { return }
      self.isLoading = false
      
      switch result {
      case .success(let photos):
        
        self.fetchePhoto(photos: photos)
      case .failure(let error):
        print("Network error: \(error.localizedDescription)")
        self.alertMessage = error.localizedDescription
      }
    }
  }
  
  private func fetchePhoto(photos: [Photo]) {
    self.photos = photos
    var viewModels = [PhotoCellViewModel]()
    for photo in photos {
      viewModels.append(createCellViewModel(photo: photo))
    }
    self.cellVMs = viewModels
  }
  
  private func createCellViewModel(photo: Photo) -> PhotoCellViewModel {
    let idStr = String(photo.id)
    return PhotoCellViewModel(idStr: idStr,
                              title: photo.title,
                              thumbnailUrl: photo.thumbnailUrl)
  }
  
  func getCellViewModel(at indexPath: IndexPath) -> PhotoCellViewModel {
    return cellVMs[indexPath.row]
  }
}

struct PhotoCellViewModel {
  let idStr: String
  let title: String
  let thumbnailUrl: String
}
