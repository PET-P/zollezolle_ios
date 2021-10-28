//
//  TipWebViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/26.
//

import UIKit
import WebKit

class TipWebViewController: UIViewController {

  @IBOutlet weak var webView: WKWebView!
  
  var targetURLString: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "쫄랭이의 여행 꿀팁🍯"
    
    let targetURL = URL(string: targetURLString!)
    
    let request = URLRequest(url: targetURL!)
    
    webView.load(request)
    
  }
  
  @IBAction func didTapBackButton(_ sender: Any) {
    
    self.dismiss(animated: true)
  }
  
}

extension TipWebViewController: UIWebViewDelegate {
  
}
