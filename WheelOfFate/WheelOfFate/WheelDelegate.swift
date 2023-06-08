//
//  WheelDelegate.swift
//  WheelOfFate
//
//  Created by Logan Melton on 6/5/23.
//
//  swiftlint: disable class_delegate_protocol
import UIKit

protocol WheelDelegate: NSObject {
  func shouldSelectObject() -> Int?
  func finishedSelecting(index: Int?, error: WheelError?)
}
