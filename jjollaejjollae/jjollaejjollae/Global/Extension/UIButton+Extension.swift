//
//  UIButton+Extension.swift
//  jjollaejjollae
//
//  Created by abc on 2021/07/30.
//

import UIKit

extension UIButton {
    func roundedButton(cornerRadius: CGFloat?){
        
        if let cornerRadius_ = cornerRadius {
            self.layer.cornerRadius = cornerRadius_
        } else {
            self.layer.cornerRadius = self.layer.frame.height / 2
        }
        self.layer.masksToBounds = true
    }
    func underLine(buttonString: String){
        let attributes: [NSAttributedString.Key : Any] = [
            .underlineStyle : NSUnderlineStyle.thick.rawValue,
            .foregroundColor : UIColor.회
        ]
        let attributeString = NSAttributedString(string: buttonString, attributes: attributes)
        self.setAttributedTitle(attributeString, for: .normal)
    }
}
