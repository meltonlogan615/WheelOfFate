//
//  ViewController.swift
//  WheelOfFate
//
//  Created by Logan Melton on 6/6/23.
//

import SwiftCSV
import UIKit

class ViewController: UIViewController {
  var titleLabel: UILabel!
  var wheelImg: UIImageView!
  var uploadButton: UIButton!

  var docPicker: UIDocumentPickerViewController!
  var fileURL: URL!

  override func viewDidLoad() {
    super.viewDidLoad()
    styleView()
    layoutView()
  }
}

extension ViewController {
  private func styleView() {
    titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
    titleLabel.text = "WHEEL OF FATE!!!"
    titleLabel.textAlignment = .center

    wheelImg = UIImageView()
    wheelImg.translatesAutoresizingMaskIntoConstraints = false
    wheelImg.image = UIImage(named: "wheel")

    uploadButton = UIButton()
    uploadButton.translatesAutoresizingMaskIntoConstraints = false
    var config = UIButton.Configuration.filled()
    config.title = "Upload Your Options"
    config.baseBackgroundColor = .red
    config.titlePadding = 4
    config.titleAlignment = .center
    uploadButton.configuration = config
    uploadButton.addTarget(self, action: #selector(uploadFileBooped), for: .touchUpInside)
  }

  private func layoutView() {
    view.addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    view.addSubview(wheelImg)
    NSLayoutConstraint.activate([
      wheelImg.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 2),
      wheelImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      wheelImg.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      wheelImg.heightAnchor.constraint(equalToConstant: view.frame.height * 0.75),
      wheelImg.widthAnchor.constraint(equalTo: wheelImg.heightAnchor)
    ])

    view.addSubview(uploadButton)
    NSLayoutConstraint.activate([
      uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      uploadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      uploadButton.heightAnchor.constraint(equalToConstant: 100),
      uploadButton.widthAnchor.constraint(equalToConstant: 100)
    ])
  }
}

extension ViewController: UIDocumentPickerDelegate, DocumentSender {
  @objc
  func uploadFileBooped() {
    docPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.commaSeparatedText])
    docPicker.delegate = self
    docPicker.directoryURL = .downloadsDirectory
    present(docPicker, animated: true)
  }

  func documentPicker(_ controller: UIDocumentPickerViewController,
                      didPickDocumentsAt urls: [URL]) {
    let picker = DocPicker()
    picker.poop(urls: urls)
    print(picker.usableData)
    let wheel = WheelViewController()
    wheel.data = picker.usableData
    wheel.modalPresentationStyle = .overCurrentContext
    self.titleLabel.isHidden = true
    self.wheelImg.isHidden = true
    self.uploadButton.isHidden = true
    present(wheel, animated: true)
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    docPicker.dismiss(animated: true)
  }
}
