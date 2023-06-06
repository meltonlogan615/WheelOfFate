//
//  UIView+Scale.swift
//  WheelOfFate
//
//  Created by Logan Melton on 6/5/23.
//

import UIKit

extension UIView {
  func scaleUp(duration: CFTimeInterval = 1.0, completionDelegate: CAAnimationDelegate? = nil) {
    let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
    scaleAnimation.fromValue = 0.0
    scaleAnimation.toValue = 1.0
    scaleAnimation.duration = duration * 5
    if let delegate: CAAnimationDelegate = completionDelegate {
      scaleAnimation.delegate = delegate
    }
    self.layer.add(scaleAnimation, forKey: nil)
  }
  
  func overScale(duration: CFTimeInterval = 1, completionDelegate: CAAnimationDelegate? = nil) {
    let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
    scaleAnimation.fromValue = 1.0
    scaleAnimation.toValue = 1.2
    scaleAnimation.duration = duration
    if let delegate: CAAnimationDelegate = completionDelegate {
      scaleAnimation.delegate = delegate
    }
    self.layer.add(scaleAnimation, forKey: nil)
  }
  
  func returnToScale(duration: CFTimeInterval = 3, completionDelegate: CAAnimationDelegate? = nil) {
    let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
    scaleAnimation.fromValue = 1.2
    scaleAnimation.toValue = 1.0
    scaleAnimation.duration = duration
    if let delegate: CAAnimationDelegate = completionDelegate {
      scaleAnimation.delegate = delegate
    }
    self.layer.add(scaleAnimation, forKey: nil)
  }
}

