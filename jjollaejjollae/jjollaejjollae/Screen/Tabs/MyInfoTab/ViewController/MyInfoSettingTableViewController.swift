//
//  MyInfoSettingTableViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/06.
//

import UIKit


class MyInfoSettingTableViewController: UITableViewController, StoryboardInstantiable {

  @IBOutlet weak var versionLabel: UILabel!
  
  @IBOutlet var menuTitleLabels: [UILabel]! {
    didSet {
      menuTitleLabels.forEach { (label) in
        label.textColor = .gray01
      }
    }
  }
  
  @IBOutlet var menuSubtitleLabel: UILabel! {
    didSet {
      menuSubtitleLabel.textColor = .gray03
    }
  }
  
  private let settingManager = SettingManager.shared
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    guard let info = sender as? (url: URL, title: String) else { return }
    
    guard let vc = segue.destination as? SettingWebViewController else { return }
    
    vc.targetUrl = info.url
    vc.title = info.title
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let cellType = SettingCellType(rawValue: indexPath.row) else { return }
    
    let title = cellType.description
    
    switch cellType {
      
      case .versionInfo:
        return
        
      case .termsAndConditions:
        let targetURL = URL(string: "https://zolle.tistory.com/8")
        performSegue(withIdentifier: SettingWebViewController.segueIdentifier, sender: (url: targetURL, title: title))
        
      case .privacyPolicy:
        let targetURL = URL(string: "https://zolle.tistory.com/7")
        performSegue(withIdentifier: SettingWebViewController.segueIdentifier, sender: (url: targetURL, title: title))
        
      case .notice:
        let targetURL = URL(string: "https://zolle.tistory.com/category/" + "공지사항".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        
        performSegue(withIdentifier: SettingWebViewController.segueIdentifier, sender: (url: targetURL, title: title))
        
      case .openSourceLicense:
        let targetURL = URL(string: "https://zolle.tistory.com/category/" + "공지사항".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        performSegue(withIdentifier: SettingWebViewController.segueIdentifier, sender: (url: targetURL, title: title))
    }
  }
  
  
  @IBAction func didTapCloseButton(_ sender: Any) {
    
    self.dismiss(animated: true, completion: nil)
  }
  
}

extension MyInfoSettingTableViewController {
  
  enum SettingCellType: Int, CaseIterable {
    
    case versionInfo
    case termsAndConditions
    case privacyPolicy
    case openSourceLicense
    case notice
    
    var description: String {
      
      switch self {
        
        case .versionInfo:
          return "버전정보"
          
        case .termsAndConditions:
          return "이용약관"
          
        case .privacyPolicy:
          return "개인정보 보호방침"
          
        case .openSourceLicense:
          return "오픈소스 라이센스"
          
        case .notice:
          return "공지사항"
      }
    }
  }
}


