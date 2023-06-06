//
//  ViewController.swift
//  WheelOfFate
//
//  Created by Logan Melton on 6/5/23.
//

import UIKit

class ViewController: UIViewController {
  var wheelView: WheelView!
  
  var selectionView: SelectedView!
  var diameter: CGFloat = 0
  let data = TestData()
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
    for (member, _) in data.data {
      let slice = Slice.init(name: member)
      let label = UILabel(frame: CGRect(x: 0, y: 0, width: diameter / 8, height: diameter / CGFloat(data.data.count) ))
      label.text = member
      label.textAlignment = .center
      label.textColor = UIColor.label
      let image = UIImage.imageWithLabel(label: label)
      slice.image = image
      slice.color = .random()
      slices.append(slice)
    }
    
    wheelView = WheelView(center: CGPoint(x: view.frame.width / 2,
                                          y: view.frame.height / 2),
                          diameter: diameter,
                          slices: slices

    )
    wheelView.delegate = self
    view.addSubview(wheelView)
//    wheelView.spinButton.addTarget(self, action: #selector(spinTheWheel), for: .touchUpInside)
  }
}

extension ViewController: WheelDelegate {
  func shouldSelectObject() -> Int? {
    selectedIndex = Int.random(in: 0 ..< data.data.count)
    // PRECHECK
    return selectedIndex
  }
  
  func finishedSelecting(index: Int?, error: WheelError?) {
    print("First or Second?")
    // TODO: HERE!!!
    guard let selection = wheelView.slices?[selectedIndex].name else { return }
    let vc = SelectedViewController(selected: selection, message: "And the winner is...")
    vc.modalPresentationStyle = .fullScreen
    vc.modalTransitionStyle = .crossDissolve
    show(vc, sender: self)
    guard let error = error else { return }
    print("WVC 64: Error == nil")
    print(error)
  }
}

extension ViewController {
  @objc
  func spinTheWheel(_ sender: UIButton) {
    if let slicesCount = wheelView.slices?.count {
      if let index = wheelView.delegate?.shouldSelectObject() {
        wheelView.selectionIndex = index
      }
      
      if (wheelView.selectionIndex >= 0 && wheelView.selectionIndex < slicesCount ) {
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
