//
//  CalendarViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/27.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
  
  @IBOutlet weak var travelDateLabel: UILabel!
  @IBOutlet weak var submitButton: UIButton! {
    didSet {
      submitButton.setTitle("날짜를 선택해주세요", for: .normal)
      submitButton.backgroundColor = UIColor.쫄래페일그린
      submitButton.tintColor = UIColor.white
      submitButton.titleLabel?.font = UIFont.robotoBold(size: 18)
      submitButton.contentEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
  }
  @IBOutlet weak var refreshButton: UIBarButtonItem! {
    didSet {
      refreshButton.tintColor = .쫄래그린
      refreshButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.robotoMedium(size: 14)], for: .normal)
    }
  }
  @IBOutlet weak var navBar: UINavigationBar!
  
  private var travelStartDateText: String = "" {
    didSet {
      travelDateLabel.text = "\(travelStartDateText) ~ \(travelEndDateText)"
    }
  }
  
  private var travelEndDateText: String = "" {
    didSet {
      travelDateLabel.text = "\(travelStartDateText) ~ \(travelEndDateText)"
    }
  }
  
  @IBOutlet weak var calendar: FSCalendar!
  var dateCompletionHandler: ((String) -> String)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpNavigationBar()
    calendar.delegate = self
    calendar.dataSource = self
    setUpCalendar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  @IBAction private func didTapSubmitButton(_ sender: UIButton) {
    _ = dateCompletionHandler?(self.travelDateLabel.text ?? "no data")
    let searchResultStoryboard = UIStoryboard(name: "SearchResult", bundle: nil)
    guard let searchResultVC = searchResultStoryboard.instantiateViewController(identifier: "SearchResultViewController") as? SearchResultViewController else {
      print("fuck")
      return
    }
    searchResultVC.schedulingCompletionHandler = {
      text in
      print("text \(text)")
      self.travelDateLabel.text = text
      return text
    }
    dismiss(animated: true, completion: nil)
  }
  
  private func setUpNavigationBar() {
    let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 74, height: 23))
    navTitle.textAlignment = .center
    navTitle.font = .robotoBold(size: 20)
    navTitle.text = "날짜선택"
    navBar.setBackgroundImage(UIImage(), for: .default)
    navBar.shadowImage = UIImage()
    navBar.isTranslucent = true
    navBar.backgroundColor = .clear
    navBar.items?[0].titleView = navTitle
  }
  
}

//MARK: - FSCalender
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
  private func setUpCalendar() {
    calendar.appearance.selectionColor = .쫄래페일그린
    calendar.appearance.headerMinimumDissolvedAlpha = 0.0
    calendar.appearance.todayColor = .쫄래그린
    calendar.appearance.titleDefaultColor = UIColor(rgb: 0x454545)
    calendar.appearance.headerDateFormat = "YYYY.M"
    calendar.appearance.headerTitleFont = .robotoBold(size: 18)
    calendar.weekdayHeight = 0
    calendar.placeholderType = .none
    calendar.allowsMultipleSelection = true
    calendar.scrollEnabled = true
    calendar.scrollDirection = .vertical
  }
}

