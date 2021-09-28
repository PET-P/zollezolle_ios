//
//  SearchResultViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/16.
//

import UIKit

class SearchNoResultViewController: UIViewController {
  
  var dataList = [SearchResultInfo]()
  lazy var likes : [Int : Int] = [:]
  
  //MARK: - OUTLET
  @IBOutlet weak var SearchResultTableView: UITableView!
  @IBOutlet weak var noInfoLabel: UILabel! {
    didSet {
      noInfoLabel.font = .robotoRegular(size: 16)
      noInfoLabel.textColor = .gray03
      noInfoLabel.text = "\"멍멍이카페에 해당하는 정보가 없어요\""
    }
  }
  @IBOutlet weak var noInfoView: UIView! {
    didSet {
      noInfoView.addBorder([.bottom], color: .gray06, width: 1)
    }
  }

  private var noInfoLabelText: String = ""{
    didSet {
      noInfoLabel.text = "\(noInfoLabelText)에 해당하는 정보가 없어요"
    }
  }

  
  let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
  let searchResultDataSource = SearchResultDataSource()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    SearchResultTableView.dataSource = searchResultDataSource
    SearchResultTableView.delegate = self
    SearchResultTableView.register(nib, forCellReuseIdentifier: "resultCell")
    SearchResultTableView.rowHeight = UITableView.automaticDimension
    for _ in 0..<10 {
      dataList.append(SearchResultInfo(sector: .accommodation,
                                       coordinate: (33.45193127215219, 126.78398144916886)))
    }
    searchResultDataSource.dataList = dataList
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}

extension SearchNoResultViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "근처 장소를 소개해드릴게요"
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80))
    let headerLabel = UILabel()
    headerLabel.frame = CGRect(x: 16, y: 37, width: header.frame.width-16, height: 21)
    headerLabel.text = "근처 장소를 소개해드릴게요"
    headerLabel.font = .robotoBold(size: 18)
    headerLabel.textColor = UIColor.색44444
    header.backgroundColor = .white
    header.addSubview(headerLabel)
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 80
  }
}
