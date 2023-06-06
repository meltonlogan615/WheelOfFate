//
//  CGFloat+ToRadians.swift
//  WheelOfFate
//
//  Created by Logan Melton on 6/5/23.
//

import CoreGraphics

extension CGFloat {
  static func toRadians(_ float: CGFloat) -> CGFloat {
    return (float * CGFloat.pi) / 180
  }
}
