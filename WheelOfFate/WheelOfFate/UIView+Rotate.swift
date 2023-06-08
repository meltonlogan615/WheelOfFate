//
//  UIView+Rotate.swift
//  WheelOfFate
//
//  Created by Logan Melton on 6/5/23.
//

import UIKit

extension UIView {
  func rotate360(duration: CFTimeInterval = 1.0, completionDelegate: CAAnimationDelegate? = nil, repetitions: Float) {
    let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
    rotateAnimation.fromValue = 0.0
    rotateAnimation.toValue = CGFloat.pi * 2
    rotateAnimation.duration = duration
    rotateAnimation.repeatCount = repetitions * 5
    if let delegate: CAAnimationDelegate = completionDelegate {
      rotateAnimation.delegate = delegate
    }
    self.scaleUp(duration: duration)
    self.layer.add(rotateAnimation, forKey: nil)
  }
}

extension UIImage {
  func rotateImage(angle: CGFloat) -> UIImage? {
    let angle = CGFloat.toRadians(angle)
    let ciImage = CIImage(image: self)

    let filter = CIFilter(name: "CIAffineTransform")
    filter?.setValue(ciImage, forKey: kCIInputImageKey)
    filter?.setDefaults()

    let newAngle = angle * 1.0
    var transform = CATransform3DIdentity
    transform = CATransform3DRotate(transform, CGFloat(newAngle), 0, 0, 1)

    let affineTransform = CATransform3DGetAffineTransform(transform)
    filter?.setValue(NSValue(cgAffineTransform: affineTransform), forKey: "inputTransform")

    let contex = CIContext(options: [CIContextOption.useSoftwareRenderer: true])
    let outputImage = filter?.outputImage
    let cgImage = contex.createCGImage(outputImage!, from: (outputImage?.extent)!)
    let result = UIImage(cgImage: cgImage!)
    return result
  }
}
