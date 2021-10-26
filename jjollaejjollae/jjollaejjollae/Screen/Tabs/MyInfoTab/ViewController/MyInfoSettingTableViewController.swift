//
//  MyInfoSettingTableViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/10/06.
//

import UIKit

class MyInfoSettingTableViewController: UITableViewController, StoryboardInstantiable {
  
  @IBOutlet weak var alarmSwitch: JJollaeSwitch! {
    didSet {
      alarmSwitch.setButtonTitle(isOn: "", isOff: "")
      alarmSwitch.setTitleFont(font: .robotoBold(size: 10))
      alarmSwitch.setCircleFrame(frame: CGRect (x: 0, y: 2.5, width: 31, height: 31))
      alarmSwitch.setOn(on: true, animated: true)
      alarmSwitch.setSwitchColor(onColor: .themePaleGreen, offColor: .gray05)
      alarmSwitch.setSwitchColor(onTextColor: .themeGreen, offTextColor: .gray03)
    }
  }
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.sectionFooterHeight = 0
    tableView.sectionHeaderHeight = 0
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0:
      return
    case 1:
      return
    case 2:
      guard let provisionVC = ProvisionViewController.loadFromStoryboard() as? ProvisionViewController else {return}
      provisionVC.getMode(mode: Provisions.Terms)
      self.navigationController?.pushViewController(provisionVC, animated: true)
    case 3:
      if let url  = URL(string: "https://guttural-tumble-39b.notion.site/288b40e5a7ab48f39eb8d4616153d006") {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    case 4:
      print("오픈소스")
      guard let testVC = SearchWithLocationViewController.loadFromStoryboard() as? SearchWithLocationViewController else {return}
      self.navigationController?.pushViewController(testVC, animated:   true)
    case 5:
      print("공지사항")
      guard let searchVC = SearchViewController.loadFromStoryboard() as? SearchViewController else {return}
      self.navigationController?.pushViewController(searchVC, animated: true)
    default:
      return
    }
  }
  
}


