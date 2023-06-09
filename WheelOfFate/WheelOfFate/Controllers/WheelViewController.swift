//
//  ViewController.swift
//  WheelOfFate
//
//  Created by Logan Melton on 6/5/23.
//

import UIKit

protocol DocumentSender {
  func uploadFileBooped()
}

class WheelViewController: UIViewController {
  var wheelView: WheelView!

  var selectionView: SelectedView!
  var diameter: CGFloat = 0
  var data = [[String: String]]()
  var selectedIndex: Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    showWheel()
  }

  func showWheel() {
    if view.frame.height < view.frame.width {
      diameter = view.frame.height
    } else {
      diameter = view.frame.width
    }

    var slices = [Slice]()
    for submission in data {
      for (member, _) in submission {
        let slice = Slice.init(name: member)
        let label = UILabel(frame: CGRect(x: 0,
                                          y: 0,
                                          width: diameter / 4,
                                          height: diameter / CGFloat(data.count / 4) ))
        label.text = member
        label.textAlignment = .left
        label.textColor = UIColor.label
        let image = UIImage.imageWithLabel(label: label)
        slice.image = image
        slice.color = .random()
        slices.append(slice)
      }
    }

    wheelView = WheelView(center: CGPoint(x: view.frame.width / 2,
                                          y: view.frame.height / 2),
                          diameter: diameter,
                          slices: slices
    )

    wheelView.delegate = self
    view.addSubview(wheelView)
  }
}

extension WheelViewController: WheelDelegate {
  func shouldSelectObject() -> Int? {
    selectedIndex = Int.random(in: 0 ..< data.count)
    // PRECHECK
    return selectedIndex
  }

  func finishedSelecting(index: Int?, error: WheelError?) {
    guard let selection = wheelView.slices?[selectedIndex].name else { return }
    let selectedVC = SelectedViewController(selected: selection, message: "And the winner is...")
    selectedVC.modalPresentationStyle = .fullScreen
    selectedVC.modalTransitionStyle = .crossDissolve
    selectedVC.sender = self
    show(selectedVC, sender: self)
    guard let error = error else { return }
    print("WheelVC: Error == nil")
    print(error)
  }
}

extension WheelViewController {
  @objc
  func spinTheWheel(_ sender: UIButton) {
    if let slicesCount = wheelView.slices?.count {
      if let index = wheelView.delegate?.shouldSelectObject() {
        wheelView.selectionIndex = index
      }

      if wheelView.selectionIndex >= 0 && wheelView.selectionIndex < slicesCount {
        wheelView.performSelection()
        wheelView.selectionIndex = 0
      } else {
        let error = WheelError.init(message: "Invalid selection index", code: 0)
        print("This Error")
        wheelView.performFinish(with: error)
      }
    } else {
      let error = WheelError.init(message: "No Slices", code: 0)
      print("No, This One")
      wheelView.performFinish(with: error)
    }
  }
}
