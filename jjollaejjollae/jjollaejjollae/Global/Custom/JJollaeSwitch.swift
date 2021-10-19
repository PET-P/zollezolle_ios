//
//  JJollaeSwitch.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/08.
//

import UIKit

protocol JJollaeButtonDelegate: AnyObject {
  func isOnValueChage(isOn: Bool)
}

class JJollaeSwitch: UIButton {
  //MARK: - 쫄래쫄래 custom switch
  
  private var isOnButtonTitle: String?
  private var isOffButtonTitle: String?
  private var barView: UIView!
  private var circleView: UIView!
  private var circleLabel: UILabel = {
    let label = UILabel()
    label.text = "여"
    label.font = .robotoMedium(size: 16)
    label.textColor = UIColor.gray01
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  weak var delegate: JJollaeButtonDelegate?
  
  var barViewTopBottomMargin: CGFloat = 0
  var barviewPadding: (top: CGFloat , right: CGFloat, bottom: CGFloat, left: CGFloat) = (top: 0, right: 0, bottom: 0, left: 0)
  
  private var onColor: UIColor?
  private var onTextColor: UIColor?
  private var offColor: UIColor?
  private var offTextColor: UIColor?
  
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
    print(barViewHeight)
    barView = UIView(frame: CGRect(x: 0, y: barViewTopBottomMargin, width: frame.width, height: barViewHeight))
    
    barView.backgroundColor = UIColor.themePaleGreen
    barView.layer.borderColor = UIColor.themePaleGreen.cgColor
    barView.layer.borderWidth = 0
    barView.layer.masksToBounds = true
    barView.clipsToBounds = true
    barView.layer.cornerRadius = barViewHeight / 2
    self.addSubview(barView)
    
    barView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    barView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    barView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
    barView.translatesAutoresizingMaskIntoConstraints = false
    
    circleView = UIView(frame: CGRect(x: 10, y: 2, width: frame.height * 11 / 6 - (barviewPadding.right + barviewPadding.left), height: frame.height - (barviewPadding.top + barviewPadding.bottom)))
    circleView.backgroundColor = UIColor.white
    circleView.layer.masksToBounds = true
    circleView.layer.cornerRadius = circleView.frame.height / 2
    self.addSubview(circleView)
  
    self.addSubview(circleLabel)
    circleLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor).isActive = true
    circleLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor).isActive = true
  }
  
  var isOn: Bool = false {
    didSet {
      self.changeState()
    }
  }
  
  func setTitleFont(font: UIFont) {
    circleLabel.font = font
  }
  
  func setCircleFrame(frame: CGRect){
    circleView.frame = frame
  }
  
  func setSwitchColor(onColor: UIColor, offColor: UIColor) {
    self.barView.backgroundColor = onColor
    self.onColor = onColor
    self.offColor = offColor
  }
  
  func setSwitchColor(onTextColor: UIColor, offTextColor: UIColor) {
    self.circleLabel.textColor = onTextColor
    self.onTextColor = onTextColor
    self.offTextColor = offTextColor
  }
  
  func setButtonTitle(isOn: String?, isOff: String?) {
    self.circleLabel.text = isOn
    self.isOnButtonTitle  = isOn
    self.isOffButtonTitle = isOff
  }
  
  func setCircleRadius(round: CGFloat) {
    self.circleView.layer.cornerRadius = round
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
    self.circleLabel.alpha = 0
    
    if self.isOn {
      circleCenter = self.frame.width - (self.circleView.frame.width / 2) - 2
      self.buttonTitle = isOnButtonTitle ?? ""
      self.barView.backgroundColor = onColor ?? .themePaleGreen
      self.circleLabel.textColor = onTextColor ?? .themePaleGreen
    } else {
      circleCenter = self.circleView.frame.width / 2 + 2
      self.buttonTitle = isOffButtonTitle ?? ""
      self.barView.backgroundColor = offColor ?? .themePaleGreen
      self.circleLabel.textColor = offTextColor ?? .themePaleGreen
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
      self.circleLabel.alpha = 1
      self.circleLabel.text = "\(self.buttonTitle)"
      self.delegate?.isOnValueChage(isOn: self.isOn)
      self.isAnimated = false
    }
  }
  
}

