//
//  WheelDelegate.swift
//  WheelOfFate
//
//  Created by Logan Melton on 6/5/23.
//

import UIKit

protocol WheelDelegate: NSObject {
  func shouldSelectObject() -> Int?
  func finishedSelecting(index: Int? , error: WheelError?)
}
