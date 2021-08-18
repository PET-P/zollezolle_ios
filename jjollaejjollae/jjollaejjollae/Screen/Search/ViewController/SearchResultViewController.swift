//
//  SearchResultViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/16.
//

import UIKit
import XLPagerTabStrip

struct SearchResultInfo {
  var name = "아지멍카페"
  var type = "커피/브런치"
  var points = 4.9
  var numbers = 52
  var like = false
}

class SearchResultViewController: UIViewController, IndicatorInfoProvider {
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo(title: "검색 결과")
  }
  
  var dataList = [SearchResultInfo]()
  lazy var likes : [Int: Int] = [:]
  
  //MARK: - OUTLET
  @IBOutlet weak var SearchResultTableView: UITableView!
  @IBOutlet weak var noInfoLabel: UILabel! {
    didSet {
      noInfoLabel.font = .robotoRegular(size: 16)
      noInfoLabel.textColor = .회
      noInfoLabel.text = "\"멍멍이카페에 해당하는 정보가 없어요\""
    }
  }
  @IBOutlet weak var searchGuide: UILabel! {
    didSet {
      searchGuide.font = .robotoRegular(size: 14)
      searchGuide.textColor = .회
      searchGuide.textAlignment = .center
      searchGuide.numberOfLines = 2
      searchGuide.text = "띄어쓰기 후 재검색 해 보세요! \n 예)멍멍이카페 → 멍멍이 카페"
    }
  }
  
  private var noInfoLabelText: String = ""{
    didSet {
      noInfoLabel.text = "\(noInfoLabelText)에 해당하는 정보가 없어요"
    }
  }
  
  private var searchGuideText: String = "" {
    didSet {
      searchGuide.text = "띄어쓰기 후 재검색 해 보세요! \n 예)멍멍이카페 → 멍멍이 카페"
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
      dataList.append(SearchResultInfo())
    }
    searchResultDataSource.dataList = dataList
  }
}

extension SearchResultViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "근처 장소를 소개해드릴게요"
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80))
    header.addBorder([.top], color: .색e8, width: 1.0)
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
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.frame.width / 343 * 245
  }
}
