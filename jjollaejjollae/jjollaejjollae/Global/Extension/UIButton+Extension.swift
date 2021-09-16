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
}
