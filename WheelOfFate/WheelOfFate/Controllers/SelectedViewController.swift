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
  var sender: WheelViewController!

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
    selectedView.spinAgainButton.addTarget(self, action: #selector(startOverBooped), for: .touchUpInside)
    selectedView.uploadNewFileButton.addTarget(self, action: #selector(uploadFileBooped), for: .touchUpInside)
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

extension SelectedViewController: UIDocumentPickerDelegate, DocumentSender {
  @objc
  func uploadFileBooped() {
    let docPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.commaSeparatedText])
    docPicker.delegate = self
    docPicker.directoryURL = .downloadsDirectory
    present(docPicker, animated: true)
  }

  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    let picker = DocPicker()
    picker.poop(urls: urls)
    print(picker.usableData)
    sender.data = picker.usableData
    sender.showWheel()
    self.dismiss(animated: true)
  }
}
