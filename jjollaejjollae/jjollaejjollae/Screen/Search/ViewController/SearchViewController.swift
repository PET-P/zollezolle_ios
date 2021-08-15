//
//  SearchViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/14.
//

import UIKit
import XLPagerTabStrip


class SearchViewController: ButtonBarPagerTabStripViewController  {
  
  @IBOutlet weak var headView: UIView! {
    didSet {
      headView.backgroundColor = .쫄래페일그린
    }
  }
  @IBOutlet weak var searchTextField: UITextField!{
    didSet {
      searchTextField.setRounded(radius: nil)
    }
  }
  @IBOutlet weak var backButton: UIButton! {
    didSet {
      backButton.tintColor = .쥐색38
    }
  }
  @IBOutlet weak var searchButton: UIButton! {
    didSet {
      searchButton.tintColor = .쥐색38
    }
  }
  
  private lazy var searchManager = SearchManager()
  
  override func viewDidLoad() {
    buttonBarView.addBorder([.bottom], color: .색e8, width: 1)
    setUpButton()
    super.viewDidLoad()
    let tapGesture = UITapGestureRecognizer(
      target: view,
      action: #selector(view.endEditing(_:)))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
  }
  
  private func setUpButton() {
    settings.style.buttonBarBackgroundColor = .쥐색38
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.selectedBarBackgroundColor = .쫄래페일그린
    settings.style.buttonBarItemFont = .robotoBold(size: 14)
    settings.style.buttonBarItemTitleColor = .쥐색38
    settings.style.buttonBarMinimumLineSpacing = 0
    settings.style.buttonBarItemLeftRightMargin = 0
    settings.style.buttonBarLeftContentInset = 0
    settings.style.buttonBarRightContentInset = 0
    settings.style.buttonBarItemsShouldFillAvailableWidth = true
    settings.style.buttonBarHeight = 1.0
    settings.style.selectedBarHeight = 4.0
  
    changeCurrentIndexProgressive = {
      (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage:
      CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
      guard changeCurrentIndex == true else { return }
      oldCell?.label.textColor = .쥐색38
      oldCell?.label.font = .robotoMedium(size: 14)
      oldCell?.contentView.addBorder([.bottom], color: .색e8, width: 1)
      newCell?.contentView.addBorder([.bottom], color: .색e8, width: 1)
      newCell?.label.textColor = .쥐색38
      newCell?.label.font = .robotoBold(size: 14)
    }
  }

  override func viewControllers(for pagerTabStripController: PagerTabStripViewController)
  -> [UIViewController] {
    let recentStoryboard = UIStoryboard(name: "Recent", bundle: nil)
    guard let recentVC = recentStoryboard
            .instantiateViewController(withIdentifier: "RecentSearchViewController")
            as? RecentSearchViewController else {return []}
    let starStoryboard = UIStoryboard(name: "Stars", bundle: nil)
    guard let starVC = starStoryboard
            .instantiateViewController(withIdentifier: "StarsSearchViewController")
            as? StarsSearchViewController else {return []}
    return [starVC, recentVC]
  }
}

//MARK: - Actions
extension SearchViewController {
  @IBAction private func didTapSearchButton(_ sender: UIButton) {
    //TODO 검색결과 화면으로 이동
    searchManager.saveSearchHistory(with: searchTextField.text)
  }
  @IBAction private func didTapBackButton(_ sender: UIButton) {
  }
}

