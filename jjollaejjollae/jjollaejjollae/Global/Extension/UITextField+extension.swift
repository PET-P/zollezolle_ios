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
        print("newwidth \(width)")
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height-10, width: width - 64 , height: 2)
        bottomLine.backgroundColor = borderColor.cgColor
        
        print(self.frame.size.width)
        self.layer.addSublayer(bottomLine)
//        self.textAlignment = .right
        self.textColor = textColor
    }
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func underline(){
        self.borderStyle = .none
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.size.height+3))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.size.height+3))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = path.lineWidth + 1
        shapeLayer.fillColor = UIColor.쫄래페일그린.cgColor
        shapeLayer.strokeColor = UIColor.쫄래페일그린.cgColor
        layer.addSublayer(shapeLayer)
    }

}

