//
//  SelectedViewController.swift
//  WheelOfFate
//
//  Created by Logan Melton on 6/5/23.
//

import UIKit

class SelectedViewController: UIViewController {
  var selectedView: SelectedView!
  var selected: String!
  var message: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    style()
    layout()
  }
  
  convenience init(selected: String, message: String) {
    self.init()
    self.selected = selected
    self.message = message
  }
}

extension SelectedViewController {
  func style() {
    selectedView = SelectedView()
    selectedView.translatesAutoresizingMaskIntoConstraints = false
    selectedView.selectedLabel.text = selected
    selectedView.messageLabel.text = message
    selectedView.startOverButton.addTarget(self, action: #selector(startOverBooped), for: .touchUpInside)
  }
  
  func layout() {
    view.addSubview(selectedView)
    NSLayoutConstraint.activate([
      selectedView.topAnchor.constraint(equalTo: view.topAnchor),
      selectedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      selectedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      selectedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

extension SelectedViewController {
  @objc
  func startOverBooped() {
    self.dismiss(animated: true)
  }
}

