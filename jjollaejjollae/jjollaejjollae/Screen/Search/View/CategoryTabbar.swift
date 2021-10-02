//
//  CategoryTabbar.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/30.
//

import UIKit

protocol PagingTabbarDelegate: AnyObject {
  func scrollToIndex(to index: Int)
}

@IBDesignable
class CategoryTabbar: UIView {
  //nibName을 써주는 순간 load는 밖에서 진행하는 것으로 하자
  static let nibName = "CategoryTabbar"
  weak var delegate: PagingTabbarDelegate?
  var titleList = ["인기키워드", "최근 검색어"]
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  private var view: UIView!
  
  //페이지를 표시할 Tabbar
  @IBOutlet weak var categoryCollectionView: UICollectionView!
  
  private func initCollectionView() {
    categoryCollectionView.dataSource = self
    categoryCollectionView.delegate = self
    categoryCollectionView.register(UINib(nibName: CategoryCell.nibName, bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifier)
    categoryCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: [])
    categoryCollectionView.backgroundColor = .white
  }

  func scroll(to index: Int) {
    categoryCollectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: [])
  }
  // indicator로 현재 페이지를 표시
  var indicatorView: UIView = {
    let indicatorView = UIView()
    indicatorView.backgroundColor = .themePaleGreen
    indicatorView.translatesAutoresizingMaskIntoConstraints = false
    return indicatorView
  }()

  var indicatorLeadingConstraint: NSLayoutConstraint!

  private func setConstraint() {
    indicatorLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            NSLayoutConstraint.activate([
              indicatorView.heightAnchor.constraint(equalToConstant: 3),
              indicatorView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor),
              indicatorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
              indicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
              indicatorLeadingConstraint
            ])
  }
  
  private func commonInit() {
    guard let loadedNib = Bundle.main.loadNibNamed("CategoryTabbar", owner: self, options: nil) else {return}
    guard let view = loadedNib.first as? UIView else {return}
    view.frame = self.bounds
    view.backgroundColor = .gray05
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.addSubview(view)
    self.view = view
    initCollectionView()
    view.addSubview(indicatorView)
    setConstraint()
  }
}

extension CategoryTabbar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.bounds.width / 2, height: collectionView.bounds.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.titleList.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
    cell.titleLabel.text = titleList[indexPath.row]
    cell.backgroundColor = .white
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.scrollToIndex(to: indexPath.row)
  }
}
