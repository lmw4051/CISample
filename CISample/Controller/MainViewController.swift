//
//  MainViewController.swift
//  CISample
//
//  Created by David on 2020/10/16.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  // MARK: - Properties
  let topicLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .systemFont(ofSize: 20)
    label.text = "JSON Placeholder"
    return label
  }()
  
  let actionButton: UIButton = {
    let button = UIButton(type: .system)
    button.tintColor = .twitterBlue
    button.setTitle("Request API", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 20)
    button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  // MARK: - Helpers
  func configureUI() {
    view.addSubview(topicLabel)
    topicLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 128)
    topicLabel.centerX(inView: self.view)
    
    view.addSubview(actionButton)
    actionButton.center(inView: self.view)
  }
  
  // MARK: - Selectors
  @objc func actionButtonTapped() {
    let controller = PhotoDetailViewController()
    navigationController?.pushViewController(controller, animated: true)
  }
}
