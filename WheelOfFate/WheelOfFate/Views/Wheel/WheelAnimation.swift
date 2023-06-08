//
//  WheelAnimation.swift
//  WheelOfFate
//
//  Created by Logan Melton on 6/5/23.
//
//  swiftlint: disable compiler_protocol_init

import AVFoundation
import UIKit

class WheelAnimation {
  var player: AVAudioPlayer!
  var delay: Double = 0
  var currentSlice: Int = 0
  let soundID: SystemSoundID = 1104
}

// MARK: - SPIN ANIMATIONS
extension WheelAnimation {
  // START OFF GOING FAST
  func fastSpin<T: Sequence>(with items: T?) -> CABasicAnimation {
    guard let items = items else { return CABasicAnimation() }
    var count = 0
    for _ in items { count += 1}
    let fastSpin = CABasicAnimation.init(keyPath: "transform.rotation")
    fastSpin.duration = 0.7
    fastSpin.repeatCount = 3

// TODO #1: Needs to make sound as each slice passes by indicator

    fastSpin.fromValue = NSNumber(floatLiteral: 0)
    fastSpin.toValue = NSNumber(floatLiteral: .pi * 2)
    fastSpin.beginTime = CACurrentMediaTime() + delay
    delay += Double(fastSpin.duration) * Double(fastSpin.repeatCount)
    return fastSpin
  }

  // SLOW DOWN A BIT
  func slowSpin<T: Sequence>(with items: T?) -> CABasicAnimation {
    guard let items = items else { return CABasicAnimation() }
    var count = 0
    for _ in items { count += 1}
    let slowSpin = CABasicAnimation.init(keyPath: "transform.rotation")
    slowSpin.fromValue = NSNumber(floatLiteral: 0)
    slowSpin.toValue = NSNumber(floatLiteral: .pi * 2)
    slowSpin.isCumulative = true
    slowSpin.beginTime = CACurrentMediaTime() + delay
    slowSpin.repeatCount = 1
    slowSpin.duration = 1.5

    delay += Double(slowSpin.duration) * Double(slowSpin.repeatCount)
    return slowSpin
  }

  // ROTATE TO THE FINAL SELECTION
  func selectionSpin(delegate: CAAnimationDelegate,
                     duration selectionSpinDuration: Double,
                     selectionAngle: CGFloat) -> CABasicAnimation {
    let selectionSpin = CABasicAnimation.init(keyPath: "transform.rotation")
    selectionSpin.delegate = delegate
    selectionSpin.fromValue = NSNumber(floatLiteral: 0)
    selectionSpin.toValue = NSNumber(floatLiteral: Double(selectionAngle))
    selectionSpin.duration = selectionSpinDuration
    selectionSpin.beginTime = CACurrentMediaTime() + delay
    selectionSpin.isCumulative = true
    selectionSpin.repeatCount = 1
    selectionSpin.isRemovedOnCompletion = false
    selectionSpin.fillMode = .forwards
    return selectionSpin
  }
}
