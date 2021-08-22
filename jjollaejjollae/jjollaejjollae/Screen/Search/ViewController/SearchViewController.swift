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
      backButton.tintColor = .쫄래블랙
    }
  }
  
  private lazy var searchManager = SearchManager.shared
  
  override func viewDidLoad() {
    buttonBarView.addBorder([.bottom], color: .색e8, width: 1)
    setUpButton()
    super.viewDidLoad()
    let tapGesture = UITapGestureRecognizer(
      target: view,
      action: #selector(view.endEditing(_:)))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
    searchTextField.returnKeyType = .search
    searchTextField.delegate = self
  }
  
  private func setUpButton() {
    settings.style.buttonBarBackgroundColor = .쫄래블랙
    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.selectedBarBackgroundColor = .쫄래페일그린
    settings.style.buttonBarItemFont = .robotoBold(size: 14)
    settings.style.buttonBarItemTitleColor = .쫄래블랙
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
      oldCell?.label.textColor = .쫄래블랙
      oldCell?.label.font = .robotoMedium(size: 14)
      oldCell?.contentView.addBorder([.bottom], color: .색e8, width: 1)
      newCell?.contentView.addBorder([.bottom], color: .색e8, width: 1)
      newCell?.label.textColor = .쫄래블랙
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
    
    let resultStoryboard = UIStoryboard(name: "SearchNoResult", bundle: nil)
    guard let resultVC = resultStoryboard.instantiateViewController(identifier: "SearchNoResultViewController") as? SearchNoResultViewController else {return []}
    return [resultVC, recentVC]
  }
}

//MARK: - Actions
extension SearchViewController {
  @IBAction private func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}

//MARK: - delegate
extension SearchViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard searchTextField.text != "" else {return true}
    searchManager.saveSearchHistory(with: searchTextField.text)
    textField.resignFirstResponder()
    let searchResultStoryboard = UIStoryboard(name: "SearchResult", bundle: nil)
    guard let resultVC = searchResultStoryboard.instantiateViewController(identifier: "SearchResultViewController") as? SearchResultViewController else {
      return true
    }
    self.navigationController?.pushViewController(resultVC, animated: true)
    return true
  }
}


