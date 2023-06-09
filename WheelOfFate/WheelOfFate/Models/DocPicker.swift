//
//  DocPicker.swift
//  WheelOfFate
//
//  Created by Logan Melton on 6/9/23.
//

import SwiftCSV
import UIKit

class DocPicker {
  var usableData: [[String: String]]
  init(usableData: [[String: String]] = []) {
    self.usableData = usableData
  }
  func poop(urls: [URL]) {
    guard urls.count == 1 else { return }
    let fileURL = urls[0]
    do {
      let csvFile: CSV = try CSV<Named>(url: fileURL)
      try csvFile.enumerateAsDict { file in
        guard let name = file["name"], let band = file["band"] else { return }
        self.usableData.append([name: band])
      }
    } catch is CSVParseError {
      print("parsing error")
    } catch {
      print("loading file error")
    }
  }
}
