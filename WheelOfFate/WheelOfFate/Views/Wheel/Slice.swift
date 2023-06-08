//
//  Slice.swift
//  WheelOfFate
//
//  Created by Logan Melton on 6/5/23.
//

import UIKit

class Slice {
  var color = UIColor.clear
  var image = UIImage()
  var name: String
  var borderColor = UIColor.label
  var borderWidth: CGFloat = 1

  init(name: String) {
    self.name = name
  }
}
