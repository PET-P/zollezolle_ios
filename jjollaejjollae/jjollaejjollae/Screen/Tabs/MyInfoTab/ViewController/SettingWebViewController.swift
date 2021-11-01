//
//  SettingWebViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/11/01.
//

import UIKit
import WebKit

class SettingWebViewController: UIViewController {
  
  static var segueIdentifier: String {
    "ShowSettingWebViewController"
  }
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var webView: WKWebView!
  
  var targetUrl: URL!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    let request = URLRequest(url: targetUrl)

    webView.load(request)
    
    titleLabel.text = self.title
  }
  
  
  @IBAction func didTapCloseButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
}

extension SettingWebViewController : WKNavigationDelegate {
  
}
