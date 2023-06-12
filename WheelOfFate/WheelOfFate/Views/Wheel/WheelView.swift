//
//  WheelView.swift
//  WheelOfFate
//
//  Created by Logan Melton on 6/5/23.
//

import AVFoundation
import UIKit

// MARK: - Wheel Container
class WheelView: UIView {
  let animator = WheelAnimation()
  let soundID: SystemSoundID = 1104
  weak var delegate: WheelDelegate?

  var selectionIndex: Int = -1
  var selectionAngle: CGFloat = 0

  private lazy var indicatorSize: CGSize = {
    let size = CGSize(width: self.bounds.width * 0.126,
                      height: self.bounds.height * 0.126)
    return size
  }()

  var slices: [Slice]?
  private var indicator = UIImageView()
  var spinButton = UIButton(type: .custom)
  var sectorAngle: CGFloat = 0
  var wheelView: UIView!

  init(center: CGPoint, diameter: CGFloat, slices: [Slice]) {
    super.init(frame: CGRect(origin: CGPoint(x: center.x - (diameter / 2),
                                             y: center.y - (diameter / 2)),
                             size: CGSize(width: diameter,
                                          height: diameter)))
    self.slices = slices
    self.initialSetUp()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension WheelView {
  private func initialSetUp() {
    addWheelView()
    addWheelLayer()
    addSpinButton()
    addIndicator()
  }
}

// MARK: - Wheel Itself
extension WheelView {
  private func addWheelView() {
    let width = bounds.width - indicatorSize.width
    let height = bounds.height - indicatorSize.height

    let xPosition: CGFloat = (bounds.width / 2) - (width / 2)
    let yPosition: CGFloat = (bounds.height / 2) - (height / 2)

    wheelView = UIView(frame: CGRect(x: xPosition,
                                     y: yPosition,
                                     width: width,
                                     height: height))

    wheelView.backgroundColor = .red
    wheelView.layer.cornerRadius = width / 2
    wheelView.clipsToBounds = true
    addSubview(wheelView)

    addWheelLayer()
  }
}

// MARK: - Indicator
extension WheelView {
  private func addIndicator() {
    let position = CGPoint(x: frame.width - (indicatorSize.width - 24),
                           y: frame.height / 2 - (indicatorSize.height / 2.7))
    indicator.frame = CGRect(origin: position,
                             size: indicatorSize)
    indicator.image = UIImage(systemName: "hand.point.left.fill")
    if indicator.superview == nil {
      addSubview(self.indicator)
    }
  }
}

// MARK: - Adds Button
extension WheelView {
  private func addSpinButton() {
    let size = CGSize(width: bounds.width * 0.2,
                      height: bounds.height * 0.2)
    let point = CGPoint(x: (frame.width / 2) - (size.width / 2),
                        y: (frame.height / 2) - (size.height / 2))
    spinButton.setTitle("SPIN", for: [])
    spinButton.frame = CGRect(origin: point, size: size)
    spinButton.addTarget(self, action: #selector(spinTheWheel), for: .touchUpInside)
    spinButton.layer.cornerRadius = spinButton.frame.height / 2
    spinButton.clipsToBounds = true
    spinButton.backgroundColor = .red
    spinButton.layer.borderWidth = 1
    spinButton.layer.borderColor = UIColor.purple.cgColor
    addSubview(spinButton)
  }

  @objc
  func spinTheWheel(_ sender: UIButton) {
    if let slicesCount = slices?.count {

      if let index = delegate?.shouldSelectObject() {
        selectionIndex = index
      }

      if selectionIndex >= 0 && selectionIndex < slicesCount {
        performSelection()
        selectionIndex = 0
      } else {
        let error = WheelError.init(message: "Invalid selection index", code: 0)
        print("This Error")
        performFinish(with: error)
      }
    } else {
      let error = WheelError.init(message: "No Slices", code: 0)
      print("No, This One")
      performFinish(with: error)
    }

  }
}

extension WheelView {
  private func addWheelLayer() {

    if let slices = slices {
      if slices.count >= 2 {
        wheelView.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        sectorAngle = CGFloat(2.0 * CGFloat.pi) / CGFloat(slices.count)
        for (index, slice) in slices.enumerated() {
          let sector = WheelSlice.init(frame: wheelView.bounds,
                                       startAngle: sectorAngle * CGFloat(index),
                                       sectorAngle: sectorAngle,
                                       slice: slice)
          wheelView.layer.addSublayer(sector)
          sector.setNeedsDisplay()
        }
      } else {
        let error = WheelError(message: "no Slice, Home-Slice",
                               code: 0)
        performFinish(with: error)
      }
    }
  }
}

extension WheelView {
  func performFinish(with error: WheelError?) {
    selectionIndex = 0
    if let error = error {
      delegate?.finishedSelecting(index: nil, error: error)
    } else {
      //  When the animation completes fix the view position to selection angle.
      wheelView.transform = CGAffineTransform(rotationAngle: selectionAngle)
      delegate?.finishedSelecting(index: selectionIndex, error: nil)
    }
    if !spinButton.isEnabled {
      spinButton.isEnabled = true
    }
  }
}

extension WheelView {
  func performSelection() {
    var selectionSpinDuration: Double = 1.0

    self.selectionAngle = .toRadians(360) - (sectorAngle * CGFloat(selectionIndex))
    let borderOffset = self.sectorAngle * 0.1
    selectionAngle -= CGFloat.random(in: borderOffset...(sectorAngle - borderOffset))

//    if selection angle is negative its changed to positive.
//    negative value spins wheel in reverse direction
    if selectionAngle < 0 {
      selectionAngle = .toRadians(360) + selectionAngle
      selectionSpinDuration += 0.5
    }

    let fast = animator.fastSpin(with: slices)
    guard let slices = slices else { return }
    let slow = animator.slowSpin(with: slices)
    let selection = animator.selectionSpin(delegate: self,
                                           duration: selectionSpinDuration,
                                           selectionAngle: selectionAngle)
    wheelView.layer.add(fast, forKey: "fastAnimation")
    wheelView.layer.add(slow, forKey: "SlowAnimation")
    wheelView.layer.add(selection, forKey: "SelectionAnimation")
  }
}

extension WheelView: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if flag {
      print(selectionIndex)
      performFinish(with: nil)
      selectionIndex = 0
    } else {
      let error = WheelError.init(message: "Error perforing selection", code: 0)
      performFinish(with: error)
    }
  }
}

extension WheelView {
  enum Speed {
    case fast, slow, selection
  }

  func clackyClack(speed: Speed, duration: CFTimeInterval) -> Timer {
    guard let slices = slices else { return Timer() }
    let count = Double(slices.count)
    var rate: Double = 0
    switch speed {
    case .fast:
      rate = 0.7 / count
    case .slow:
      rate = 1.0 / count
    case .selection:
      rate = 1.5 / count
    }
    return Timer.scheduledTimer(timeInterval: rate,
                                target: self,
                                selector: #selector(claks),
                                userInfo: nil,
                                repeats: true)
  }

  @objc
  func claks() {
    let soundID: SystemSoundID = 1104
    AudioServicesPlaySystemSound(soundID)
  }
}
