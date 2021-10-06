//
//  MyInfoEditViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/04.
//

import UIKit

class MyInfoEditViewController: UIViewController, StoryboardInstantiable {
  
  var infoData: User? {
    didSet {
      emailTextField.text = infoData?.email
      nickTextField.text = infoData?.nick
      if infoData?.accountType == "local" {
        passwordTextField.isHidden = false
      } else {
        passwordTextField.isHidden = true
      }
    }
  }
  
  @IBOutlet weak var nickTextField: UITextField! {
    didSet {
      nickTextField.addLeftPadding()
    }
  }
  @IBOutlet weak var emailTextField: UITextField! {
    didSet {
      emailTextField.addLeftPadding()
    }
  }
  @IBOutlet weak var passwordTextField: UITextField! {
    didSet {
      passwordTextField.addLeftPadding()
    }
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  
  
}
