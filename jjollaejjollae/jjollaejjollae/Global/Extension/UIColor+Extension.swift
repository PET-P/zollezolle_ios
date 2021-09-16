//
//  UIColor+Extension.swift
//  jjollaejjollae
//
//  Created by abc on 2021/07/30.
//

import UIKit

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
    self.init(
      red: CGFloat(red) / 255.0,
      green: CGFloat(green) / 255.0,
      blue: CGFloat(blue) / 255.0,
      alpha: CGFloat(a) / 255.0
    )
  }
  convenience init(rgb: Int) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 8) & 0xFF,
      blue: rgb & 0xFF
    )
  }
  convenience init(argb: Int) {
    self.init(
      red: (argb >> 16) & 0xFF,
      green: (argb >> 8) & 0xFF,
      blue: argb & 0xFF,
      a: (argb >> 24) & 0xFF
    )
  }
  
  @nonobjc class var themePaleGreen: UIColor {
    return UIColor(rgb: 0xCDE5C6)
  }
  @nonobjc class var themeGreen: UIColor {
    return UIColor(rgb: 0x628F56)
  }
  @nonobjc class var themeYellow: UIColor {
    return UIColor(rgb: 0xFFDB94)
  }
  @nonobjc class var themeBrown: UIColor {
    return UIColor(rgb: 0x967D60)
  }
  @nonobjc class var themeDarkBrown: UIColor {
    return UIColor(rgb: 0x78644D)
  }
  @nonobjc class var 쫄래브라운40: UIColor {
    return UIColor(rgb: 0x967D60).withAlphaComponent(0.4)
  }
  @nonobjc class var themeRed: UIColor {
    return UIColor(rgb: 0xFF543D)
  }
  @nonobjc class var gray04: UIColor {
    return UIColor(rgb: 0xC4C4C4)
  }
  @nonobjc class var gray03: UIColor {
    return UIColor(rgb: 0x828282)
  }
  @nonobjc class var gray01: UIColor {
    return UIColor(rgb: 0x383838)
  }
  @nonobjc class var gray02: UIColor {
    return UIColor(rgb: 0x454545)
  }
  @nonobjc class var gray05: UIColor {
    return UIColor(rgb: 0xE5E5E5)
  }
  @nonobjc class var gray06: UIColor {
    return UIColor(rgb: 0xF4F4F4)
  }
  @nonobjc class var 색44444: UIColor {
    return UIColor(rgb: 0x444444)
  }
  @nonobjc class var errorColor: UIColor {
    return UIColor(rgb: 0xFF7373)
  }
}

