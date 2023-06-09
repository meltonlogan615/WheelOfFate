//
//  UIImage+UILabel.swift
//  WheelOfFate
//
//  Created by Logan Melton on 6/5/23.
//

import UIKit

extension UIImage {
  class func imageWithLabel(label: UILabel) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 1.0)
    //    label.adjustsFontSizeToFitWidth = true
    label.sizeToFit()
    label.layer.render(in: UIGraphicsGetCurrentContext()!)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    guard let img = img else { return UIImage() }
    return img
  }
}
