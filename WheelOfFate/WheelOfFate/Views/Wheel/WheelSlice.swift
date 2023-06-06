//
//  WheelSlice.swift
//  WheelOfFate
//
//  Created by Logan Melton on 6/5/23.
//

import UIKit

class WheelSlice: CALayer {
  private var startAngle: CGFloat!
  private var sectorAngle: CGFloat = -1
  private var slice: Slice!
  
  init(frame: CGRect, startAngle: CGFloat, sectorAngle: CGFloat, slice: Slice) {
    super.init()
    self.startAngle = startAngle
    self.sectorAngle = sectorAngle
    self.slice = slice
    self.frame = frame.inset(by: UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0))
    self.contentsScale = UIScreen.main.scale
    self.masksToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(in ctx: CGContext) {
    let radius = self.frame.width / 2 - self.slice.borderWidth
    let center = CGPoint(x: self.frame.width / 2,
                         y: self.frame.height / 2)
    
    UIGraphicsPushContext(ctx)
    let path = UIBezierPath()
    path.lineWidth = self.slice.borderWidth
    path.move(to: center)
    path.addArc(withCenter: center,
                radius: radius,
                startAngle: self.startAngle,
                endAngle: (self.startAngle + self.sectorAngle),
                clockwise: true)
    path.close()
    self.slice.color.setFill()
    path.fill()
    self.slice.borderColor.setStroke()
    path.stroke()
    UIGraphicsPopContext()
    
    guard let image = slice.image.rotateImage(angle: sectorAngle) else { return }
    
    let lineLegth = CGFloat((2 * radius * sin(sectorAngle / 2)))
    let s = ((2 * radius) + lineLegth)/2
    
    let inCenterDiameter = ((s * (s - radius) * (s - radius) * (s - lineLegth)).squareRoot()/s) * 1.50
    
    var size : CGFloat = 0
    switch sectorAngle {
      case .toRadians(180):
        size = radius / 2.0
      case .toRadians(120):
        size = radius / 1.9
      case .toRadians(90):
        size = radius / 1.9
      default:
        size = inCenterDiameter
    }
    size -= slice.borderWidth * 3
    
    
    let xCenterNum = ((radius * radius) + ((radius * cos(self.sectorAngle)) * radius))
    let xCenterDom = (radius * 2) + lineLegth + (size * 0.07)
    let xCenter = xCenterNum / xCenterDom
    
    let yCenterNum = ((radius * sin(self.sectorAngle)) * radius)
    let yCenterDom = (radius * 2) + lineLegth
    let yCenter = yCenterNum / yCenterDom
    
    let xPosition: CGFloat = {
      switch sectorAngle {
        case .toRadians(180):
          return (-size / 2)
        case .toRadians(120):
          return (radius / 2.7 - size / 2)
        case .toRadians(90):
          return (radius / 2.4 - size / 2)
        default:
          return ((xCenter - size / 2) + (size / 2))
      }
    }()
    
    let yPosition: CGFloat = {
      switch sectorAngle {
        case .toRadians(180):
          return size / 1.6
        case .toRadians(120):
          return (radius / 2 - size / 1.75)
        case .toRadians(90):
          return (radius / 2.4 - size / 1.75)
        default:
          return (yCenter - size / 1.25)
      }
    }()
    
    UIGraphicsPushContext(ctx)
    
    path.lineWidth = slice.borderWidth
    path.move(to: center)
    path.addArc(withCenter: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: startAngle + sectorAngle,
                clockwise: true)
    
    path.close()
    self.slice.color.setFill()
    path.fill()
    self.slice.borderColor.setStroke()
    path.stroke()
    
    ctx.saveGState()
    ctx.translateBy(x: center.x, y: center.y)
    ctx.rotate(by: self.startAngle)
    image.draw(in: CGRect(x: xPosition - (size),
                          y: yPosition - (size / 6),
                          width: lineLegth,
                          height: size))
    ctx.restoreGState()
    UIGraphicsPopContext()
  }
}

