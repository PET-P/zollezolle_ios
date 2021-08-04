//
//  UITextField+extension.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/04.
//

import Foundation

extension UITextField {
    
    func underlineStyle(textColor: UIColor, borderColor: UIColor) {
        self.borderStyle = .none
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.size.height-1, width: self.frame.size.width, height: 1)
        border.backgroundColor = borderColor.cgColor
        self.layer.addSublayer(border)
        self.textAlignment = .right
        self.textColor = textColor
    }
}
