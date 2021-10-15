//
//  JJollaeSwitch.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/08.
//

import UIKit

protocol ZollaeCustomSwitchDelegate: AnyObject {
  
  func isOnValueChage(isOn: Bool)
}

class ZollaeCustomSwitch: UIButton {
  //MARK: - 쫄래쫄래 custom switch
  
  private var isOnButtonTitle: String?
  private var isOffButtonTitle: String?
  private var barView: UIView!
  private var circleView: UIView!
  private var circleInnerImageView: UIImageView!
  
  weak var delegate: ZollaeCustomSwitchDelegate?
  
  var barViewTopBottomMargin: CGFloat = 0
  
  var barviewPadding: (top: CGFloat , right: CGFloat, bottom: CGFloat, left: CGFloat) = (top: 5, right: 5, bottom: 5, left: 5)
  
  private var onColor: UIColor = #colorLiteral(red: 0.8039215686, green: 0.8980392157, blue: 0.7764705882, alpha: 1)
  
  private var offColor: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.buttonInit(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.buttonInit(frame: frame)
  }
  
  
  private func buttonInit(frame: CGRect) {
    
    let barViewHeight = frame.height - (barViewTopBottomMargin * 2)
    
    barView = UIView(frame: CGRect(x: 0, y: barViewTopBottomMargin, width: frame.width, height: barViewHeight))
    
    barView.backgroundColor = offColor

    barView.layer.masksToBounds = true
    barView.clipsToBounds = true
    barView.layer.cornerRadius = barViewHeight / 2
    
    self.addSubview(barView)
    
    barView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    barView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    barView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
    barView.translatesAutoresizingMaskIntoConstraints = false
    
    
    circleView = UIView(frame: CGRect(x: barviewPadding.left,
                                      y: barviewPadding.top,
                                      width: (frame.width - (barviewPadding.left + barviewPadding.right) * 2) / 2,
                                      height: frame.height - (barviewPadding.top + barviewPadding.bottom)))
    
    circleView.backgroundColor = UIColor.white
    circleView.layer.masksToBounds = true
    circleView.layer.cornerRadius = circleView.frame.height / 2
    
    self.addSubview(circleView)
    
    circleInnerImageView = UIImageView(image: #imageLiteral(resourceName: "DefaultThumbsDown"))
    
    circleInnerImageView.contentMode = .scaleAspectFit
    
    circleInnerImageView.translatesAutoresizingMaskIntoConstraints = false
    
    circleView.addSubview(circleInnerImageView)
    
    circleInnerImageView.leadingAnchor.constraint(equalTo: circleView.leadingAnchor, constant: 3).isActive = true
    circleInnerImageView.trailingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: -3).isActive = true
    circleInnerImageView.topAnchor.constraint(equalTo: circleView.topAnchor, constant: 3).isActive = true
    circleInnerImageView.bottomAnchor.constraint(equalTo: circleView.bottomAnchor, constant: -3).isActive = true
    
    circleView.clipsToBounds = true
    
    circleView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
    
  }
  
  var isOn: Bool = false {
    didSet {
      self.changeState()
    }
  }
  
//  func setTitleFont(font: UIFont) {
//    circleLabel.font = font
//  }
  
  func setCircleFrame(frame: CGRect){
    circleView.frame = frame
  }
  
  func setSwitchColor(onColor: UIColor, offColor: UIColor) {
    self.barView.backgroundColor = onColor
    self.onColor = onColor
    self.offColor = offColor
  }
  
  func setSwitchColor(onTextColor: UIColor, offTextColor: UIColor) {
//    self.circleLabel.textColor = onTextColor
//    self.onTextColor = onTextColor
//    self.offTextColor = offTextColor
  }
  
  func setButtonTitle(isOn: String?, isOff: String?) {
//    self.circleLabel.text = isOn
    self.isOnButtonTitle  = isOn
    self.isOffButtonTitle = isOff
  }
 
  
  private var buttonTitle: String = "남"
  
  // 스위치 isOn 값 변경시 애니메이션 여부
  private var isAnimated: Bool = false
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    self.setOn(on: !self.isOn, animated: true)
  }
  
  func setOn(on: Bool, animated: Bool) {
    self.isAnimated = animated
    self.isOn = on
  }
  
  var animationDuration: TimeInterval = 0.2
  
  private func changeState() {
    var circleCenter: CGFloat = 0
//    self.circleLabel.alpha = 0
    
    if self.isOn {
      
      circleCenter = self.frame.width - (self.circleView.frame.width / 2) - 4

      self.barView.backgroundColor = onColor
      
      self.circleInnerImageView.image = #imageLiteral(resourceName: "SelectedThumbsUp")

    } else {
      
      circleCenter = self.circleView.frame.width / 2 + 4

      self.barView.backgroundColor = offColor
      
      self.circleInnerImageView.image = #imageLiteral(resourceName: "DefaultThumbsDown")
    }
    
    let duration = self.isAnimated ? self.animationDuration : 0
    
    UIView.animate(withDuration: duration) { [weak self] in
      
      guard let self = self else {return}
      
      self.circleView.center.x = circleCenter
      
      if self.isOn {
        
        self.barView.backgroundColor = self.onColor
        self.circleView.backgroundColor = UIColor.white
      } else {
        
        self.barView.backgroundColor =
          self.offColor
          self.circleView.backgroundColor = .white
      }
     
    } completion: { [weak self] _ in
      guard let self = self else { return }
      
      self.delegate?.isOnValueChage(isOn: self.isOn)
      self.isAnimated = false
    }
  }
  
}

