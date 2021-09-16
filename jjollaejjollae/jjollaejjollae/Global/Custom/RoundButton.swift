//
//  RoundButton.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/24.
//

import UIKit

class RoundButton: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.buttonInit(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.buttonInit(frame: frame)
  }
  
  private func buttonInit(frame: CGRect) {
    self.setRounded(radius: nil)
  }
}
