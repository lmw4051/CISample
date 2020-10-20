//
//  PhotoDetailViewController.swift
//  CISample
//
//  Created by David on 2020/10/16.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import Moya
import MBProgressHUD

private let reuseIdentifier = "PhotoCell"

class PhotoDetailViewController: UICollectionViewController {
  // MARK: - Properties
  lazy var viewModel: PhotoViewModel = {
    return PhotoViewModel()
  }()
        
  // MARK: - Lifecycle
  init() {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureCollectionView()
    initVM()
  }
  
  // MARK: - Helpers
  func initVM() {
    viewModel.showAlertClosure = { [weak self] in
      DispatchQueue.main.async {
        if let message = self?.viewModel.alertMessage {
          self?.showAlert(message)
        }
      }
    }
    
    viewModel.updateLoadingStatus = { [weak self] in
      guard let self = self else { return }
      
      DispatchQueue.main.async {
        if self.viewModel.isLoading {
          MBProgressHUD.showAdded(to: self.view, animated: true)
        } else {
          MBProgressHUD.hide(for: self.view, animated: true)
        }
      }
    }
    
    viewModel.reloadCollectionViewClosure = { [weak self] in
      self?.collectionView.reloadData()
    }
    
    viewModel.initFetch()
  }
  
  func showAlert(_ message: String) {
    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  func configureCollectionView() {
    collectionView.backgroundColor = .white
    collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
    configureCollectionViewFlowLayout()
  }
  
  func configureCollectionViewFlowLayout() {
    let itemSpace: CGFloat = 0
    let columnCount: CGFloat = 4
    let inset: CGFloat = 0
    let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
    let width = floor((collectionView.bounds.width - itemSpace * (columnCount - 1) - inset * 2) / columnCount)
    flowLayout?.itemSize = CGSize(width: width, height: width)
    flowLayout?.estimatedItemSize = .zero
    flowLayout?.minimumInteritemSpacing = itemSpace
    flowLayout?.minimumLineSpacing = itemSpace
    flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
  }    
}

// MARK: - UICollectionViewDataSource
extension PhotoDetailViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfCells
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
    let cellVM = viewModel.getCellViewModel(at: indexPath)
    cell.photoCellVM = cellVM
    return cell
  }
}
