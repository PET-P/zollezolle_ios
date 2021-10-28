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
  
  private var isLogged: Bool? {
    didSet {
      if isLogged == false {
        rankLabel.isHidden = true
        nicknameLabel.text = "로그인을 해주세요!!"
        disclosureIndicator.isHidden = true
        profileImageView.image = UIImage(named: "default")
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("\(self)", #function)
    infoTableView.delegate = self
    infoTableView.dataSource = self
    setupHeader()
    infoTableView.tableFooterView = UIView(frame: CGRect.zero)
//    if #available(iOS 15.0, *) {
//      infoTableView.sectionHeaderTopPadding = 0
//    }
    infoTableView.sectionFooterHeight = .leastNonzeroMagnitude
    infoTableView.alwaysBounceVertical = false
  }
  
  lazy var profileStackView: UIStackView = {
    let stackV = UIStackView(arrangedSubviews: [rankLabel, nicknameLabel, disclosureIndicator])
    stackV.translatesAutoresizingMaskIntoConstraints = false
    stackV.axis = .horizontal
    stackV.spacing = 5
    stackV.distribution = .fill
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gotoMyInfoDetail(_:)))
    stackV.addGestureRecognizer(tapGesture)
    return stackV
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    isLogged = UserManager.shared.isLogged
  }
  
  
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
  
  lazy var disclosureIndicator: UIImageView = {
    let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    imageview.contentMode = .scaleAspectFit
    StorageService.shared.downloadUIImageWithURL(with: "//Users/abc/Desktop/Hack/애견동반숙소/애견카페/애견카페 세종시/헤이미쉬독/7ZGh1o63ZY7yX4Aes2VRFWil.jpg", imageCompletion: { (image) in
      guard let image = image else {
        return
      }
      imageview.image = image
    })
    imageview.isUserInteractionEnabled = true
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
  
  deinit{
    print(self, #function)
  }
  
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
    disclosureIndicator.widthAnchor.constraint(equalToConstant: 12).isActive = true
    disclosureIndicator.heightAnchor.constraint(equalToConstant: 17).isActive = true
    profileStackView.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
    profileStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,
                                          constant: 20).isActive = true
    }
  
  @objc func gotoMyInfoDetail(_ sender: Any?) {
    if isLogged == false {
      guard let loginVC = LoginViewController.loadFromStoryboard() as? LoginViewController else {return}
      let newNaviController = UINavigationController(rootViewController: loginVC)
      newNaviController.isNavigationBarHidden = true
      let sceneDelegate = UIApplication.shared.connectedScenes
              .first!.delegate as! SceneDelegate
      sceneDelegate.window!.rootViewController = newNaviController
    } else  {
      guard let detailVC = MyInfoDetailViewController.loadFromStoryboard() as?
              MyInfoDetailViewController else {return}
      PagingManager.shared.mainVC = detailVC
      self.navigationController?.pushViewController(detailVC, animated: true)
    }
  }
  
}

extension MyInfoMainViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return infoList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? InfoTableViewCell else {return UITableViewCell()}
    let item = infoList[indexPath.row]
    cell.titleLabel.text = item.title
    cell.subtitle.text = item.subtitle
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
      switch indexPath.row {
      case 0:
        if isLogged == false {return}
        guard let myReviewVC = MyInfoReviewViewController.loadFromStoryboard() as? MyInfoReviewViewController else {return}
        guard let userId = UserManager.shared.userIdandToken?.userId else {return}
        guard let token = UserManager.shared.userIdandToken?.token else {return}
        myReviewVC.getTokenAndUserId(token: token, userId: userId)
        self.navigationController?.pushViewController(myReviewVC, animated: true)
      case 1:
        print("이메일")
      case 2:
        guard let settingVC = MyInfoSettingViewController.loadFromStoryboard() as? MyInfoSettingViewController else {return}
        self.navigationController?.pushViewController(settingVC, animated: true)
      default: return
    }
  }
}
