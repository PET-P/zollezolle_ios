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
    
    @nonobjc class var 쫄래페일그린: UIColor {
        return UIColor(rgb: 0xCDE5C6)
    }
    @nonobjc class var 쫄래그린: UIColor {
        return UIColor(rgb: 0x628F56)
    }
    @nonobjc class var 쫄래앨로우: UIColor {
        return UIColor(rgb: 0xFFDB94)
    }
    @nonobjc class var 쫄래브라운2: UIColor {
        return UIColor(rgb: 0x967D60)
    }
    @nonobjc class var 쫄래브라운: UIColor {
        return UIColor(rgb: 0x78644D)
    }
    @nonobjc class var 쫄래브라운40: UIColor {
        return UIColor(rgb: 0x967D60).withAlphaComponent(0.4)
    }
    @nonobjc class var 연회: UIColor {
        return UIColor(rgb: 0xC4C4C4)
    }
    @nonobjc class var 회: UIColor {
        return UIColor(rgb: 0x828282)
    }
    @nonobjc class var 쫄래블랙: UIColor {
        return UIColor(rgb: 0x383838)
    }
    @nonobjc class var 연회랑38사이: UIColor {
        return UIColor(rgb: 0xF4F4F4)
    }
    @nonobjc class var 색44444: UIColor {
        return UIColor(rgb: 0x444444)
    }
    @nonobjc class var 색e8: UIColor {
        return UIColor(rgb: 0xE8E8E8)
    }
    @nonobjc class var errorColor: UIColor {
        return UIColor(rgb: 0xFF7373)
    }
}

