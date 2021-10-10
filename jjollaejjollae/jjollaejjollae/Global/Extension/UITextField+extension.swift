//
//  UITextField+extension.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/04.
//

import UIKit

extension UITextField {
    
    func underlineStyle(textColor: UIColor, borderColor: UIColor, width: CGFloat) {
        self.borderStyle = .none
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height-10, width: width - 64 , height: 2)
        bottomLine.backgroundColor = borderColor.cgColor
        self.layer.addSublayer(bottomLine)
        self.textColor = textColor
    }
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
        
    func changeUnderLine(borderColor: UIColor, width: CGFloat) {
        self.layer.sublayers?[0].removeFromSuperlayer()
        self.borderStyle = .none
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height+5, width: width - 64 , height: 2)
        bottomLine.backgroundColor = borderColor.cgColor
        self.textColor = UIColor.gray03
        self.layer.insertSublayer(bottomLine, at: 0)
        self.setNeedsDisplay()
    }
  
  
  // 순서:
  // 1. 플레이스홀더 먼저 넣고
  // 2. 색상을 추가해야함
  func setPlaceholderColor(_ placeholderColor: UIColor) {
    attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : placeholderColor, .font: font].compactMapValues{$0})
  }

}

