//
//  UITextField+extension.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/04.
//

import UIKit

extension UITextField {
    
    func underlineStyle(textColor: UIColor, borderColor: UIColor) {
        self.borderStyle = .none
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height-1, width: self.frame.size.width, height: 2)
        bottomLine.backgroundColor = borderColor.cgColor
        self.layer.addSublayer(bottomLine)
//        self.textAlignment = .right
        self.textColor = textColor
    }
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
