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
      guard let provisionVC = ProvisionViewController.loadFromStoryboard() as? ProvisionViewController else {return}
      provisionVC.getMode(mode: Provisions.Privacy)
      self.navigationController?.pushViewController(provisionVC, animated: true)
    case 4:
      print("탈퇴하기")
      showAlert()
    case 5:
      print("공지사항")
    default:
      return
    }
  }
  
  private func showAlert(){
    var usertype = true
    var secessionAlertController: UIAlertController!
    if usertype {
      secessionAlertController = UIAlertController(title: "탈퇴하기", message: "회원탈퇴를 하시려면 안내 및 동의가 필요합니다.비밀번호를 입력해주세요", preferredStyle: .alert)
      secessionAlertController.addTextField { (password) in
        print("서버와 연동해서 password가 맞는지 확인을해야한딩")
      }
    } else {
      secessionAlertController = UIAlertController(title: "탈퇴하기", message: "회원탈퇴를 하시려면 안내 및 동의가 필요합니다.", preferredStyle: .alert)
    }
    let ok = UIAlertAction(title: "진행하기", style: .default) { (ok) in
      print("탈퇴 진행하는 행위")
    }
    let cancel = UIAlertAction(title: "취소", style: .cancel) { (cancel) in
      print("탈퇴안하기")
    }
    secessionAlertController.addAction(cancel)
    secessionAlertController.addAction(ok)
    self.present(secessionAlertController, animated: true, completion: nil)
  }
  
  
  
}


