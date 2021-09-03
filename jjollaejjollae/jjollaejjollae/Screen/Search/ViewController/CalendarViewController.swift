//
//  CalendarViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/27.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegateAppearance {
  
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
  fileprivate let gregorian = Calendar(identifier: .gregorian)
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpNavigationBar()
    calendar.delegate = self
    calendar.dataSource = self
    setUpCalendar()
    let dates = [
      self.gregorian.date(byAdding: .day, value: -1, to: Date()),
      Date(),
      self.gregorian.date(byAdding: .day, value: 1, to: Date())
    ]
    dates.forEach { (date) in
      self.calendar.select(date)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  @IBAction private func didTapSubmitButton(_ sender: UIButton) {
    _ = dateCompletionHandler?(self.travelDateLabel.text ?? "no data")
    let searchResultStoryboard = UIStoryboard(name: "SearchResult", bundle: nil)
    guard let searchResultVC = searchResultStoryboard.instantiateViewController(identifier: "SearchResultViewController") as? SearchResultViewController else {
      return
    }
    searchResultVC.schedulingCompletionHandler = {
      text in
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
    calendar.appearance.headerTitleColor = .쫄래그린
    
    print("\(Date().firstDayOfTheMonth.weekDay())")
    calendar.headerHeight = 70
    calendar.appearance.headerTitleAlignment = .left
    calendar.appearance.headerTitleOffset = CGPoint(x: 0, y: -20)
    calendar.appearance.headerSeparatorColor = UIColor.clear.withAlphaComponent(0)
    calendar.appearance.headerTitleFont = .robotoBold(size: 18)
    calendar.appearance.titleFont = .robotoRegular(size: 14)
    calendar.appearance.titleSelectionColor = .쫄래그린
    calendar.weekdayHeight = 0
    calendar.placeholderType = .none
    calendar.allowsMultipleSelection = true
    calendar.scrollEnabled = true
    calendar.scrollDirection = .vertical
    calendar.today = nil
    calendar.register(CalendarCell.self, forCellReuseIdentifier: "cell")
  }
  
  //MARK: - CalandarDataSource
  
  func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
    let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
    return cell
  }
  
  func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
    self.configure(cell: cell, for: date, at: monthPosition)
  }
  
  func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    let firstWeekDay = calendar.currentPage.firstDayOfTheMonth.weekDay()
    if firstWeekDay != "일" || firstWeekDay != "월" {
      calendar.appearance.headerTitleOffset = CGPoint(x: 0, y: 5)
    } else {
      calendar.appearance.headerTitleOffset = CGPoint(x: 0, y: 10)
    }
  }
  
  //MARK: - CalandarDelegate
  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    self.calendar.frame.size.height = bounds.height
  }
  
  func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    return monthPosition == .current
  }
  
  func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    return monthPosition == .current
  }
  
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    print("date \(date.datePickerToString())")
    self.configureVisibleCells()
  }
  
  func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
    self.configureVisibleCells()
  }
    
  
  //MARK: - functions
  
  private func configureVisibleCells() {
    calendar.visibleCells().forEach { (cell) in
      let date = calendar.date(for: cell)
      let position = calendar.monthPosition(for: cell)
      self.configure(cell: cell, for: date!, at: position)
    }
  }

  private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
    let customCell = cell as! CalendarCell
    //만약 date가 오늘이라면 hidden 없애기
//    customCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
    //selectionLayer configuree - 자세히봐야할껏
    if position == .current {
      
      var selectionType = SelectionType.none
      
      if calendar.selectedDates.contains(date) {
        let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
        let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
        if calendar.selectedDates.contains(date) {
          if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
            selectionType = .middle
//            print("selectionType == middle \(date)")
          }
          else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
            selectionType = .rightBorder
//            print("selectionType == rightBorder + \(date)")
          }
          else if calendar.selectedDates.contains(nextDate) {
            selectionType = .leftBorder
//            print("selectionType = leftborder + \(date) ")
          }
          else {
            selectionType = .single
          }
        }
      } else {
        selectionType = .none
      }
      if selectionType == .none {
        customCell.selectionLayer.isHidden = true
//        print("selectionType == none")
        return
      }
      customCell.selectionLayer.isHidden = false
      customCell.selectionType = selectionType
    } else {
//      customCell.circleImageView.isHidden = true
      customCell.selectionLayer.isHidden = true
    }
  }

//  func startOfMonth() {
//    let components = gregorian.dateComponents([.year, .month], from: Date())
//    let startofMonth = gregorian.date(from: components)!
//
//
//  }
  
}


