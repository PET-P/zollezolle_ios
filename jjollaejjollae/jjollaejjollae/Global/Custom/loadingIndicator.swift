//
//  loadingIndicator.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/26.
//

import UIKit
import Gifu

class LoadingIndicator {
  
  static let shared = LoadingIndicator()
  
  private init() {}
  
  private var backgroundView: UIView?
  private var popupView: GIFImageView?
  private var loadingLabel: UILabel?

  
    
    class func show() {
      let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
      let popupView = GIFImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
      popupView.animate(withGIFNamed: "dogwalking") {
        print("dog is walking🐕")
      }
      let loadingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
      loadingLabel.text = "잠시 기다리시개..."
      loadingLabel.font = .robotoBold(size: 18)
      loadingLabel.textColor = .themeGreen
      
      if let window = UIApplication.shared.windows.first {$0.isKeyWindow} {
        window.addSubview(backgroundView)
        window.addSubview(popupView)
        window.addSubview(loadingLabel)
        
        backgroundView.frame = CGRect(x: 0, y: 0, width: window.frame.maxX, height: window.frame.maxY)
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, a: Int(0.2))
        
        popupView.center = window.center
        loadingLabel.layer.position = CGPoint(x: window.frame.midX, y: window.frame.maxY + 10)
        
        
        shared.backgroundView?.removeFromSuperview()
        shared.popupView?.removeFromSuperview()
        shared.loadingLabel?.removeFromSuperview()
        shared.backgroundView = backgroundView
        shared.popupView = popupView
        shared.loadingLabel = loadingLabel
        
      }
    }
}
