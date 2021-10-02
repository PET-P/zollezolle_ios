//
//  MyInfoMainViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/08.
//

import UIKit

class MyInfoMainViewController: UIViewController, StoryboardInstantiable {
  
  private var infoList: [InfoContent] = [InfoContent(title: "내후기"),
                                         InfoContent(title: "문의", subtitle: "카카오 플러스친구로 이동"),
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
    infoTableView.alwaysBounceVertical = false
  }
  
  lazy var profileStackView: UIStackView = {
    let stackV = UIStackView(arrangedSubviews: [rankLabel, nicknameLabel])
    stackV.translatesAutoresizingMaskIntoConstraints = false
    stackV.axis = .horizontal
    stackV.spacing = 5
    stackV.distribution = .fillEqually
    return stackV
  }()
  
  lazy var profileImageView: UIImageView = {
    let imageview = UIImageView()
    imageview.contentMode = .scaleAspectFill
    imageview.image = UIImage(named: "IMG_4930")
    imageview.layer.cornerRadius = imageHeight / 2
    imageview.layer.masksToBounds = true
    imageview.clipsToBounds = true
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
}

extension MyInfoMainViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return 3
    default:
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? InfoTableViewCell else {return UITableViewCell()}
    let item = infoList[indexPath.row]
    let firstItem = InfoContent(title: "예약내역")
    if indexPath.section == 0 {
      cell.titleLabel.text = firstItem.title
      cell.subtitle.text = firstItem.subtitle
    } else {
      cell.titleLabel.text = item.title
      cell.subtitle.text = item.subtitle
    }
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 8;
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 8))
    header.backgroundColor = .gray06
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 87
  }
}
