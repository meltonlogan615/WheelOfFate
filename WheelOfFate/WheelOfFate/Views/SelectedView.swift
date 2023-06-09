//
//  SelectedView.swift
//  WheelOfFate
//
//  Created by Logan Melton on 6/5/23.
//

import UIKit

class SelectedView: UIView {

  var blurredBG: UIVisualEffectView!
  var borderView: UIView!
  var messageLabel: UILabel!
  var selectedLabel: UILabel!
  var spinAgainButton: UIButton!
  var uploadNewFileButton: UIButton!
  var buttonStack: UIStackView!

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    style()
    layout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension SelectedView {
  func style() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .clear

    let bgFilter = UIBlurEffect(style: .regular)
    blurredBG = UIVisualEffectView(effect: bgFilter)
    blurredBG.translatesAutoresizingMaskIntoConstraints = false

    borderView = UIView()
    borderView.translatesAutoresizingMaskIntoConstraints = false
    borderView.layer.borderWidth = 12
    borderView.layer.borderColor = UIColor.label.cgColor
    borderView.layer.cornerRadius = 8
    borderView.clipsToBounds = true
    borderView.backgroundColor = .systemPink

    messageLabel = UILabel()
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.font = .systemFont(ofSize: 40, weight: .medium)
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center

    selectedLabel = UILabel()
    selectedLabel.translatesAutoresizingMaskIntoConstraints = false
    selectedLabel.font = .systemFont(ofSize: 64, weight: .bold)
    selectedLabel.numberOfLines = 0
    selectedLabel.textAlignment = .center

    spinAgainButton = UIButton()
    spinAgainButton.translatesAutoresizingMaskIntoConstraints = false
    spinAgainButton.setTitle("Spin Again", for: [])

    uploadNewFileButton = UIButton()
    uploadNewFileButton.translatesAutoresizingMaskIntoConstraints = false
    uploadNewFileButton.setTitle("Upload A New File", for: [])

    buttonStack = UIStackView(arrangedSubviews: [spinAgainButton, uploadNewFileButton])
    buttonStack.translatesAutoresizingMaskIntoConstraints = false
    buttonStack.axis = .horizontal
    buttonStack.distribution = .fillEqually
  }

  func layout() {
    addSubview(blurredBG)
    NSLayoutConstraint.activate([
      blurredBG.topAnchor.constraint(equalTo: topAnchor),
      blurredBG.leadingAnchor.constraint(equalTo: leadingAnchor),
      blurredBG.trailingAnchor.constraint(equalTo: trailingAnchor),
      blurredBG.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])

    let multiplier = CGFloat(36)
    addSubview(borderView)
    NSLayoutConstraint.activate([
      borderView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: multiplier),
      borderView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: multiplier),
      trailingAnchor.constraint(equalToSystemSpacingAfter: borderView.trailingAnchor, multiplier: multiplier),
      bottomAnchor.constraint(equalToSystemSpacingBelow: borderView.bottomAnchor, multiplier: multiplier)
    ])

    borderView.addSubview(messageLabel)
    NSLayoutConstraint.activate([
      messageLabel.topAnchor.constraint(equalToSystemSpacingBelow: borderView.topAnchor, multiplier: 4),
      messageLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: borderView.leadingAnchor, multiplier: 4),
      borderView.trailingAnchor.constraint(equalToSystemSpacingAfter: messageLabel.trailingAnchor, multiplier: 4)
    ])

    borderView.addSubview(selectedLabel)
    NSLayoutConstraint.activate([
      selectedLabel.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
      selectedLabel.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
      selectedLabel.widthAnchor.constraint(equalTo: borderView.widthAnchor),
      selectedLabel.heightAnchor.constraint(equalTo: borderView.heightAnchor)
    ])

    addSubview(buttonStack)
    NSLayoutConstraint.activate([
      buttonStack.topAnchor.constraint(equalToSystemSpacingBelow: borderView.bottomAnchor, multiplier: 2),
      buttonStack.leadingAnchor.constraint(equalTo: borderView.leadingAnchor),
      buttonStack.trailingAnchor.constraint(equalTo: borderView.trailingAnchor),
      buttonStack.heightAnchor.constraint(equalToConstant: 80)
    ])
  }
}

// MARK: - ANIMATION PROCESS
// #1 - begin spinning counter clockwise
// #2 - increase scale
// #3 - exceeds 1:1 scale, but then returns to it.
