//
//  PhotoCell.swift
//  CISample
//
//  Created by David on 2020/10/16.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
  // MARK: - Properties
  var photoCellVM: PhotoCellViewModel? {
    didSet {
      idLabel.text = photoCellVM?.idStr
      titleLabel.text = photoCellVM?.title
      thumbnailImageView.sd_setImage(with: URL(string: photoCellVM?.thumbnailUrl ?? ""))
    }
  }
  
  // MARK: - UI Properties
  private lazy var thumbnailImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    return iv
  }()
  
  private let idLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .systemFont(ofSize: 20)
    label.textAlignment = .center
    return label
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .systemFont(ofSize: 16)
    label.textAlignment = .center
    label.lineBreakMode = .byTruncatingTail
    return label
  }()
   
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(thumbnailImageView)
    thumbnailImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    
    let stack = UIStackView(arrangedSubviews: [idLabel, titleLabel])
    stack.axis = .vertical
    stack.distribution = .fillEqually
    stack.spacing = 4
    
    addSubview(stack)
    stack.center(inView: self)
    stack.anchor(left: leftAnchor, right: rightAnchor,
                 paddingLeft: 8, paddingRight: 8)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
