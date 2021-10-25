//
//  SearchViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/14.
//

import UIKit


class SearchViewController: UIViewController, StoryboardInstantiable, Searchable {
  
  @IBOutlet weak var headView: UIView! {
    didSet {
      headView.backgroundColor = .themePaleGreen
    }
  }
  @IBOutlet weak var searchTextField: UITextField!{
    didSet {
      searchTextField.setRounded(radius: nil)
    }
  }
  @IBOutlet weak var backButton: UIButton! {
    didSet {
      backButton.tintColor = .gray01
    }
  }
  
  @IBOutlet weak var categoryTabbarView: CategoryTabbar!
  {
    didSet {
      categoryTabbarView.delegate = self
    }
  }
  @IBOutlet weak var cateboryTabbarViewTrailing: NSLayoutConstraint!
  
  @IBOutlet weak var pageCollectionView: UICollectionView! {
    didSet {
      pageCollectionView.dataSource = self
      pageCollectionView.delegate = self
      pageCollectionView.showsHorizontalScrollIndicator = false
      pageCollectionView.isPagingEnabled = true
    }
  }
  
  private lazy var searchManager = SearchManager.shared
  let childrenVC: [UIViewController] = [StarsSearchViewController.loadFromStoryboard(),
                                        RecentSearchViewController.loadFromStoryboard()]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tapGesture = UITapGestureRecognizer(
      target: view,
      action: #selector(view.endEditing(_:)))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
    searchTextField.returnKeyType = .search
    searchTextField.delegate = self
  }
}
//MARK: - PagingCollectionView

extension SearchViewController: PagingTabbarDelegate, UICollectionViewDelegateFlowLayout {
  
  func scrollToIndex(to index: Int) {
    pageCollectionView.scrollToItem(at: IndexPath(row: index, section: 0),
                                    at: .centeredHorizontally, animated: true)
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let scrollLimit = scrollView.contentOffset.x / 2 - cateboryTabbarViewTrailing.constant
    if scrollLimit < 0 {
      categoryTabbarView.indicatorLeadingConstraint.constant = 0
    } else {
      categoryTabbarView.indicatorLeadingConstraint.constant = scrollLimit
    }
  }

  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                 targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let page = Int(targetContentOffset.pointee.x / pageCollectionView.frame.width)
    categoryTabbarView.scroll(to: page)
  }
}

extension SearchViewController: UICollectionViewDelegate,
                                UICollectionViewDataSource, UIScrollViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return childrenVC.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath)
    display(contentController: childrenVC[indexPath.row], on: cell.contentView)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    let height = collectionView.frame.height
    return CGSize(width: width, height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func display(contentController content: UIViewController, on view: UIView) {
    self.addChild(content)
    content.view.frame = view.bounds
    view.addSubview(content.view)
    content.didMove(toParent: self)
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
    guard let searchText = searchTextField.text else {return true}
    searchManager.searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    searchManager.saveSearchHistory(with: searchTextField.text)
    if let token = LoginManager.shared.loadFromKeychain(account: "accessToken") {
      APIService.shared.search(token: token, keyword: searchText, page: 0) { result in
        switch result{
        case .success(let data):
          guard let nextVC = self.sendRightVC(from: self, by: data.region, with: data.result) as? UIViewController&SearchDataReceiveable else {return}
          nextVC.newDataList = data.result
          self.hidesBottomBarWhenPushed = true
          self.navigationController?.pushViewController(nextVC, animated: true)
        case .failure(let error):
          print(self, #function, error)
        }
      }
    } else {
      APIService.shared.search(keyword: searchText, page: 0) { (result) in
        switch result {
        case .success(let data):
          guard let nextVC = self.sendRightVC(from: self, by: data.region, with: data.result) as? UIViewController&SearchDataReceiveable else {return}
          nextVC.newDataList = data.result
          SearchManager.shared.searchText = searchText
          self.hidesBottomBarWhenPushed = true
          self.navigationController?.pushViewController(nextVC, animated: true)
        case .failure(let error):
          print(self, #function, error)
        }
      }
    }
    return true
  }
}
