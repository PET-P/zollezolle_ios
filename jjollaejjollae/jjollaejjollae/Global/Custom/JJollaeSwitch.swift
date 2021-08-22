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
  private var barView: UIView!
  private var circleView: UIView!
  private var circleLabel: UILabel = {
    let label = UILabel()
    label.text = "여"
    label.font = .robotoMedium(size: 16)
    label.textColor = UIColor.쫄래블랙
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  weak var delegate: JJollaeButtonDelegate?
  
  var barViewTopBottomMargin: CGFloat = 0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.buttonInit(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.buttonInit(frame: frame)
  }
  
  private func buttonInit(frame: CGRect) {
    print(frame.width)
    let barViewHeight = frame.height - (barViewTopBottomMargin * 2)
    barView = UIView(frame: CGRect(x: 0, y: barViewTopBottomMargin, width: frame.width, height: barViewHeight))
    
    barView.backgroundColor = UIColor.clear
    barView.layer.borderColor = UIColor.쫄래페일그린.cgColor
    barView.layer.borderWidth = 1
    barView.layer.masksToBounds = true
    barView.clipsToBounds = true
    barView.layer.cornerRadius = barViewHeight / 2
    self.addSubview(barView)
    
    barView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    barView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    barView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    barView.translatesAutoresizingMaskIntoConstraints = false
    
    circleView = UIView(frame: CGRect(x: 0, y: 0, width: frame.height * 11 / 6, height: frame.height))
    circleView.backgroundColor = UIColor.쫄래페일그린
    circleView.layer.masksToBounds = true
    circleView.layer.cornerRadius = frame.height / 2
    
    self.addSubview(circleView)
  
    self.addSubview(circleLabel)
    circleLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor).isActive = true
    circleLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor).isActive = true
    print(superview ?? "0")
    print(subviews)
  }
  
  var isOn: Bool = false {
    didSet {
      self.changeState()
    }
  }
  
  var gender: String = "남"
  
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
      circleCenter = self.frame.width - (self.circleView.frame.width / 2)
      self.gender = "남"
    } else {
      circleCenter = self.circleView.frame.width / 2
      self.gender = "여"
    }
    
    let duration = self.isAnimated ? self.animationDuration : 0
    
    UIView.animate(withDuration: duration) { [weak self] in
      guard let self = self else {return}
      self.circleView.center.x = circleCenter
      self.barView.backgroundColor = UIColor.clear
      self.circleView.backgroundColor = UIColor.쫄래페일그린
    } completion: { [weak self] _ in
      guard let self = self else { return }
      self.circleLabel.alpha = 1
      self.circleLabel.text = "\(self.gender)"
      self.delegate?.isOnValueChage(isOn: self.isOn)
      self.isAnimated = false
    }
  }
  
}

