//
//  HomeMainViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/08/08.
//

import UIKit

class HomeMainViewController: UIViewController {
  
	// MARK: - IBOutlets
  
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var searchField: UITextField!
  
  // TODO: CollectionView 연결
  
  lazy var searchButton: UIButton = {
    
    let button = UIButton()
    
    button.setImage(UIImage(named: "Search"), for: UIControl.State.normal)
    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return button
  }()
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    searchField.delegate = self
    super.viewDidLoad()
    setSearchField()
  }
  
  // MARK: - Custom
  
  private func setSearchField() {
    
    searchField.layer.cornerRadius = searchField.frame.height / 2
    searchField.layer.masksToBounds = true
    
    searchField.rightView = searchButton
    searchField.rightViewMode = .always
    
    searchField.addSubview(searchButton)
    
    searchButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
    searchButton.heightAnchor.constraint(equalTo: searchButton.widthAnchor, multiplier: 1.0).isActive = true
    
    searchButton.centerYAnchor.constraint(equalTo: searchField.centerYAnchor).isActive = true
    searchButton.trailingAnchor.constraint(equalTo: searchField.trailingAnchor, constant: -20).isActive = true
  }
}

// MARK: - Storyborad
extension HomeMainViewController: Storyboardable{
  
  static func loadFromStoryboard(fileName name: String) -> UIViewController {
    
    let identifier = "\(name)ViewController"
    
    let storyboard = UIStoryboard(name: name, bundle: nil)
    let homeMainVC = storyboard.instantiateViewController(identifier: identifier)
    
    return homeMainVC
  }
 
}

extension HomeMainViewController: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField == searchField {
      self.navigationController?.pushViewController(HomeMainViewController
                                                      .loadFromStoryboard(fileName: "Search")
                                                    , animated: true)
    }
    return false
  }
}


