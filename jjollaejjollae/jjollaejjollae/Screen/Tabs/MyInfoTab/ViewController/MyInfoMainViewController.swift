//
//  MyInfoMainViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/08.
//

import UIKit

class MyInfoMainViewController: UIViewController, StoryboardInstantiable {
  
  private var infoList: [InfoContent] = [InfoContent(title: "내후기"),
                                         InfoContent(title: "문의", subtitle: "이메일 보내기"),
                                         InfoContent(title:"설정")]
  
  @IBOutlet var infoTableView: UITableView!
  
  private let cellIdentifier = "cell"
  private var imageHeight: CGFloat = 132
  
  override func viewDidLoad() {
    super.viewDidLoad()
    infoTableView.delegate = self
    infoTableView.dataSource = self
    setupHeader()
    infoTableView.tableFooterView = UIView(frame: CGRect.zero)
    if #available(iOS 15.0, *) {
      infoTableView.sectionHeaderTopPadding = 0
    }
    infoTableView.sectionFooterHeight = .leastNonzeroMagnitude
    infoTableView.alwaysBounceVertical = false
  }
  
  lazy var profileStackView: UIStackView = {
    let stackV = UIStackView(arrangedSubviews: [rankLabel, nicknameLabel])
    stackV.translatesAutoresizingMaskIntoConstraints = false
    stackV.axis = .horizontal
    stackV.spacing = 5
    stackV.distribution = .fillEqually
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gotoMyInfoDetail(_:)))
    stackV.addGestureRecognizer(tapGesture)
    return stackV
  }()
  
  
  // 이거 왜그러지? setupgesture에 넣을때는 안되더니만 여기다 넣으면 된다 뭐지? 따로함수를 빼고 해도 안된당 음 시점차이가
  // 확실한대 왜그런지 나중에 한번 알아보기
  // imageview완성 시점과 gesture시점
  lazy var profileImageView: UIImageView = {
    let imageview = UIImageView()
    imageview.contentMode = .scaleAspectFill
    imageview.image = UIImage(named: "IMG_4930")
    imageview.layer.cornerRadius = imageHeight / 2
    imageview.layer.masksToBounds = true
    imageview.clipsToBounds = true
    imageview.isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gotoMyInfoDetail(_:)))
    imageview.addGestureRecognizer(tapGesture)
    imageview.translatesAutoresizingMaskIntoConstraints = false
    return imageview
  }()
  
  lazy var rankLabel: UILabel = {
    let label = UILabel()
    label.text = "멍멍박사"
    label.textColor = .gray03
    label.font = .robotoBold(size: 18)
    return label
  }()
  
  lazy var nicknameLabel: UILabel = {
    let label = UILabel()
    label.text = "쪼꼬언니"
    label.textColor = .gray01
    label.font = .robotoBold(size: 18)
    return label
  }()
  
  private func setupHeader() {
    let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 260))
    header.backgroundColor = .white
    infoTableView.tableHeaderView = header
    header.isUserInteractionEnabled = true
    header.addSubview(profileImageView)
    profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
    profileImageView.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
    profileImageView.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
    header.addSubview(profileStackView)
    profileStackView.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
    profileStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,
                                          constant: 20).isActive = true
    }
  
  @objc func gotoMyInfoDetail(_ sender: Any?) {
    guard let detailVC = MyInfoDetailViewController.loadFromStoryboard() as?
            MyInfoDetailViewController else {return}
    self.navigationController?.pushViewController(detailVC, animated: true)
    //로그인이 되어있지 않다면?
//    guard let loginVC = LoginViewController.loadFromStoryboard() as?
//            LoginViewController else {return}
//    self.navigationController?.pushViewController(loginVC, animated: true)
  }
  
}

extension MyInfoMainViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    switch section {
//    case 0:
//      return 1
//    case 1:
//      return 3
//    default:
//      return 1
//    }
    return infoList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? InfoTableViewCell else {return UITableViewCell()}
    let item = infoList[indexPath.row]
//    let firstItem = InfoContent(title: "예약내역")
    cell.titleLabel.text = item.title
    cell.subtitle.text = item.subtitle
//    if indexPath.section == 0 {
//      cell.titleLabel.text = firstItem.title
//      cell.subtitle.text = firstItem.subtitle
//    } else {
//      cell.titleLabel.text = item.title
//      cell.subtitle.text = item.subtitle
//    }
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 8;
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView()
    header.backgroundColor = .gray06
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 87
  }
}

extension MyInfoMainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    if indexPath.section == 0 {
//      guard let myReservationVC = MyInfoReservationViewController.loadFromStoryboard() as? MyInfoReservationViewController else {return}
//      self.navigationController?.pushViewController(myReservationVC, animated: true)
//    } else {}
      switch indexPath.row {
      case 0:
        guard let myReviewVC = MyInfoReviewViewController.loadFromStoryboard() as? MyInfoReviewViewController else {return}
        self.navigationController?.pushViewController(myReviewVC, animated: true)
      case 1:
        guard let testVC = DogInfoViewController.loadFromStoryboard() as? DogInfoViewController else {return}
        self.navigationController?.pushViewController(testVC, animated: true)
      case 2:
        guard let settingVC = MyInfoSettingViewController.loadFromStoryboard() as? MyInfoSettingViewController else {return}
        self.navigationController?.pushViewController(settingVC, animated: true)
      default: return
    }
  }
}
