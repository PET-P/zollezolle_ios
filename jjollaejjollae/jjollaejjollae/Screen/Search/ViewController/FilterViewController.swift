//  FilterViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/24.


import UIKit

class FilterViewController: UIViewController {
  
  var accommodationFilter = accommodationType(title: "숙소유형", type: [(.독채, false), (.복층, false), (.온돌, false), (.카라반, false), (.캠핑, false), (.풀빌라, false), (.한옥, false)])
  var dogAmentiesFilter = DogAmenties(type: [(.놀이터, false), (.드라이룸, false), (.샤워장, false), (.스파, false), (.실내수영장, false), (.운동장, false)])
  var peopleAmentiesFilter = PeopleAmenties(type: [(.개별바베큐, false), (.노래방, false), (.수영장, false), (.스파, false), (.아침식사, false), (.엘리베이터, false), (.주방, false), (.피트니스, false)])
  
   
  @IBOutlet var headers: [PaddingLabel]! {
    didSet {
      headers.forEach { header in
        header.textColor = .쫄래블랙
        header.font = .robotoBold(size: 16)
      }
    }
  }
  
  @IBOutlet var accommodationButtons: [RoundButton]! {
    didSet {
      accommodationButtons.forEach { button in
        button.setBackgroundColor(color: .쫄래페일그린, stokeColor: .쫄래그린, forState: .selected)
      }
    }
  }
  @IBOutlet var dogAmentiesButtons: [RoundButton]!{
    didSet {
      dogAmentiesButtons.forEach { button in
        button.setBackgroundColor(color: .쫄래페일그린, stokeColor: .쫄래그린, forState: .selected)
      }
    }
  }
  @IBOutlet var peopleAmentiesButtons: [RoundButton]!{
    didSet {
      peopleAmentiesButtons.forEach { button in
        button.setBackgroundColor(color: .쫄래페일그린, stokeColor: .쫄래그린, forState: .selected)
      }
    }
  }
  
  @IBOutlet var submitButton: UIButton! {
    didSet {
      submitButton.setTitle("필터적용", for: .normal)
      submitButton.backgroundColor = UIColor.쫄래페일그린
      submitButton.tintColor = UIColor.white
      submitButton.titleLabel?.font = UIFont.robotoBold(size: 18)
      submitButton.contentEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
  }
  @IBOutlet var refreshButton: UIBarButtonItem! {
    didSet {
      refreshButton.tintColor = .쫄래그린
      refreshButton.setTitleTextAttributes(
        [NSAttributedString.Key.font : UIFont.robotoMedium(size: 14)], for: .normal)
    }
  }
  
  @IBOutlet weak var Xbutton: UIBarButtonItem! {
    didSet {
      Xbutton.tintColor = .black
    }
  }
  
  @IBOutlet weak var navBar: UINavigationBar!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpUI()
    setUpNavigationBar()
  }
  
  private func setUpNavigationBar() {
    let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 74, height: 23))
    navTitle.textAlignment = .center
    navTitle.font = .robotoBold(size: 20)
    navTitle.text = "조건선택"
    navBar.setBackgroundImage(UIImage(), for: .default)
    navBar.shadowImage = UIImage()
    navBar.isTranslucent = true
    navBar.backgroundColor = .clear
    navBar.items?[0].titleView = navTitle
  }
  
  
  private func setUpUI() {
    headers[0].text = accommodationFilter.title
    headers[1].text = dogAmentiesFilter.title
    headers[2].text = peopleAmentiesFilter.title
    
    for index in accommodationButtons.indices {
      accommodationButtons[index].setTitle(accommodationFilter.type[index].key.rawValue, for: .normal)
      accommodationButtons[index].setBorder(borderColor:UIColor(rgb: 0xDADADA), borderWidth: 1)
      accommodationButtons[index].titleLabel?.font = .robotoRegular(size: 16)
      accommodationButtons[index].contentEdgeInsets = UIEdgeInsets(top: 8, left: 17, bottom: 8, right: 17)
    }
    for index in dogAmentiesButtons.indices {
      dogAmentiesButtons[index].setTitle(dogAmentiesFilter.type[index].key.rawValue, for: .normal)
      dogAmentiesButtons[index].setBorder(borderColor:UIColor(rgb: 0xDADADA), borderWidth: 1)
      dogAmentiesButtons[index].titleLabel?.font = .robotoRegular(size: 16)
      dogAmentiesButtons[index].contentEdgeInsets = UIEdgeInsets(top: 8, left: 17, bottom: 8, right: 17)
    }
    for index in peopleAmentiesButtons.indices {
      peopleAmentiesButtons[index].setTitle(peopleAmentiesFilter.type[index].key.rawValue, for: .normal)
      peopleAmentiesButtons[index].setBorder(borderColor:UIColor(rgb: 0xDADADA), borderWidth: 1)
      peopleAmentiesButtons[index].titleLabel?.font = .robotoRegular(size: 16)
      peopleAmentiesButtons[index].contentEdgeInsets = UIEdgeInsets(top: 8, left: 17, bottom: 8, right: 17)
    }
  }
  
  private var selectedList = Set<String>() {
    didSet {
      if selectedList.count > 0 {
        submitButton.backgroundColor = .쫄래그린
        submitButton.isEnabled = true
      } else {
        submitButton.backgroundColor = .쫄래페일그린
        submitButton.isEnabled = false
      }
    }
  }
  
  @IBAction func didTapFilterButtons(_ sender: RoundButton) {
    if sender.isSelected {
      selectedList.remove(sender.currentTitle!)
      sender.setBorder(borderColor:UIColor(rgb: 0xDADADA), borderWidth: 1)
    } else {
      selectedList.insert(sender.currentTitle!)
      sender.setBorder(borderColor: .쫄래그린, borderWidth: 1)
    }
    sender.isSelected = !sender.isSelected
  }
  
  @IBAction func didTapSubmitButton(_ sender: UIButton) {
    for index in accommodationFilter.type.indices {
      accommodationFilter.type[index].checked = false
    }
    for index in dogAmentiesFilter.type.indices {
      dogAmentiesFilter.type[index].checked = false
    }
    for index in peopleAmentiesFilter.type.indices {
      peopleAmentiesFilter.type[index].checked = false
    }
    for element in selectedList {
      if let accommoIndex = accommodationFilter.type.firstIndex(where: {$0.key.rawValue == element}) {
        accommodationFilter.type[accommoIndex].checked = true
      }
      if let dogIndex = dogAmentiesFilter.type.firstIndex(where: {$0.key.rawValue == element}) {
        dogAmentiesFilter.type[dogIndex].checked = true
      }
      if let peopleIndex = peopleAmentiesFilter.type.firstIndex(where:    {$0.key.rawValue == element}){
        peopleAmentiesFilter.type[peopleIndex].checked = true
      }
    }
  }
  
  @IBAction func didTapRefreshButton(_ sender: UIBarButtonItem) {
    selectedList.removeAll()
    for index in accommodationButtons.indices {
      if accommodationButtons[index].isSelected {
        accommodationButtons[index].isSelected = false
        accommodationFilter.type[index].checked = false
        accommodationButtons[index].setBorder(borderColor:UIColor(rgb: 0xDADADA), borderWidth: 1)
      }
    }
    for index in dogAmentiesButtons.indices {
      if dogAmentiesButtons[index].isSelected {
        dogAmentiesButtons[index].isSelected = false
        dogAmentiesFilter.type[index].checked = false
        dogAmentiesButtons[index].setBorder(borderColor:UIColor(rgb: 0xDADADA), borderWidth: 1)
      }
    }
    for index in peopleAmentiesButtons.indices {
      if peopleAmentiesButtons[index].isSelected {
        peopleAmentiesButtons[index].isSelected = false
        peopleAmentiesFilter.type[index].checked = false
        peopleAmentiesButtons[index].setBorder(borderColor:UIColor(rgb: 0xDADADA), borderWidth: 1)
      }
    }
  }
  
  @IBAction func didTapXbutton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
}
