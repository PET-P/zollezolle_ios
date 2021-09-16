//
//  UIView+Extension.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/02.
//

import UIKit

extension UIView {
    
    func setRounded(radius : CGFloat?) {
        // UIView 모서리 둥글때
        if let cornerRadius_ = radius {
            self.layer.cornerRadius = cornerRadius_
        } else {
            // if nil -> go default
            self.layer.cornerRadius = self.layer.frame.height / 2
        }
        
        self.layer.masksToBounds = true
    }
    
    func setBorder(borderColor : UIColor?, borderWidth : CGFloat?) {
        // UIView 테두리 설정
        
        // 색상 설정 default값은 쫄래페일그린
        if let borderColor_ = borderColor {
            self.layer.borderColor = borderColor_.cgColor
        } else {
            self.layer.borderColor = UIColor.쫄래페일그린.cgColor
        }
        
        // UIView의 테두리 두께 설정
        if let borderWidth_ = borderWidth {
            self.layer.borderWidth = borderWidth_
        } else {
            // borderWidth 변수가 nil일 경우의 default 1포인트
            self.layer.borderWidth = 1.0
        }
    }
    
}

