//
//  helpLabel.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/11.
//

import UIKit

class helpLabel: UIView {

  @IBOutlet weak var helpNumLabel: UIButton! {
    didSet {
      helpNumLabel.setRounded(radius: 13 / 2)
      helpNumLabel.backgroundColor = .themePaleGreen
      helpNumLabel.setTitleColor(.gray01, for: .normal)
      helpNumLabel.titleLabel?.font = .robotoRegular(size: 9)
      helpNumLabel.isUserInteractionEnabled = false
    }
  }
  
  @IBOutlet weak var helpLabelbutton: UIButton! {
    didSet {
      helpLabelbutton.setBackgroundImage(UIImage(named: "thumbBtn"), for: .normal)
      helpLabelbutton.isUserInteractionEnabled = false
    }
  }
  
  var helpNumber: Int? = nil {
    didSet {
      if helpNumber != nil {
        helpNumLabel.setTitle("\(helpNumber!)", for: .normal)
      } else {
        helpNumLabel = nil
      }
    }
  }
  
  var helpImage: String = "thumbLabel" {
    didSet {
      helpLabelbutton.setBackgroundImage(UIImage(named: "\(helpImage)"), for: .normal)
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setUpView()
  }
  
  private func setUpView() {
    let nib = UINib(nibName: "helpLabel", bundle: nil)
    guard let helpLabel = nib.instantiate(withOwner: self, options: nil).first as? UIView else {return}
    helpLabel.frame = self.bounds
    helpLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.addSubview(helpLabel)
  }
  
}
