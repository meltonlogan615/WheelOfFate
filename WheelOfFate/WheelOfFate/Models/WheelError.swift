//
//  WheelError.swift
//  WheelOfFate
//
//  Created by Logan Melton on 6/5/23.
//

import UIKit

class WheelError: Error {
  let message: String
  let code: Int

  init(message: String, code: Int) {
    self.message = message
    self.code = code
  }
}
