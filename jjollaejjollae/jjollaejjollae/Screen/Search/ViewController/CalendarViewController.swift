//
//  CalendarViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/08/27.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegateAppearance {
  
  @IBOutlet weak var travelDateLabel: UILabel! {
    didSet {
      travelDateLabel.font = .robotoMedium(size: 16)
      travelDateLabel.textColor = .쫄래블랙
      travelDateLabel.text = ""
    }
  }
  
  
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
  

  @IBOutlet weak var calendar: FSCalendar!
  fileprivate var gregorian = Calendar(identifier: .gregorian)
  var dates: [Date]? {
    didSet {
      if let dates = dates {
        if dates.count >  1 {
          submitButton.backgroundColor = .쫄래그린
          submitButton.setTitle("\(dates.count-1)박 선택", for: .normal)
        } else {
          submitButton.backgroundColor = .쫄래페일그린
          submitButton.setTitle("1박 이상을 선택해주세요", for: .normal)}
      } else {
        submitButton.backgroundColor = .쫄래페일그린
        submitButton.setTitle("날짜를 선택해주세요", for: .normal)
      }
    }
  }
  
  private var firstDate: Date? {
    didSet {
      travelStartDateText = firstDate?.dateForCalendar() ?? " "
    }
  }
  private var lastDate: Date? {
    didSet {
      travelEndDateText = lastDate?.dateForCalendar() ?? " "
    }
  }
  
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
  
  private(set) var defaultdays: [Date?] = []
  internal func setDefaultDateLabel(defaultDate: [Date?]) {
        self.defaultdays = defaultDate
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    firstDate = defaultdays.first!
    lastDate = defaultdays.last!
    setUpNavigationBar()
    gregorian.locale = Locale(identifier: "ko_KR")
    calendar.delegate = self
    calendar.dataSource = self
    setUpCalendar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let defaultDates = datesRange(from: (defaultdays.first!)! , to: (defaultdays.last!)!)
    defaultDates.forEach { (date) in
      self.calendar.select(date, scrollToDate: false)
    }

  }
  
  var dateCompletionHandler: (([Date?]) -> [Date?])?
  @IBAction private func didTapSubmitButton(_ sender: UIButton) {
    _ = dateCompletionHandler?([firstDate, lastDate])
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction private func didTapXButton(_ sender: Any?){
    self.dismiss(animated: true, completion: nil)
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
    calendar.appearance.headerDateFormat = "YYYY.M"
    calendar.appearance.headerTitleColor = .쫄래그린
    calendar.headerHeight = 70
    calendar.appearance.headerTitleAlignment = .left
    calendar.appearance.headerTitleOffset = CGPoint(x: 7, y: -5)
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
  
  func minimumDate(for calendar: FSCalendar) -> Date {
    return Date()
  }
  func maximumDate(for calendar: FSCalendar) -> Date {
    return gregorian.date(byAdding: .month, value: 3, to: Date())!
  }
  
  func calendar(_ calendar: FSCalendar, cellFor date: Date,
                at position: FSCalendarMonthPosition) -> FSCalendarCell {
    let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
    return cell
  }
  
  func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date,
                at monthPosition: FSCalendarMonthPosition) {
    self.configure(cell: cell, for: date, at: monthPosition)
  }
  
  func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
    if date.weekDay() == "일" {
      return UIColor.쫄래그린
    }
    return UIColor(rgb: 0x454545)
  }
  
  
  //MARK: - CalandarDelegate
  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    
    self.calendar.frame.size.height = bounds.height
  }
  
  func calendar(_ calendar: FSCalendar, shouldSelect date: Date,
                at monthPosition: FSCalendarMonthPosition) -> Bool {
    return monthPosition == .current
  }
  
  func calendar(_ calendar: FSCalendar, shouldDeselect date: Date,
                at monthPosition: FSCalendarMonthPosition) -> Bool {
    return monthPosition == .current
  }
  
  func calendar(_ calendar: FSCalendar, didSelect date: Date,
                at monthPosition: FSCalendarMonthPosition) {
    if firstDate == nil {
      firstDate = date
      self.dates = [firstDate!]
    }
    else if firstDate != nil && lastDate == nil {
      // firstDate 보다 더 전꺼나 같은거를를선택한다면?
      if date <= firstDate! {
        calendar.deselect(firstDate!)
        firstDate = date
        self.dates = [firstDate!]
        travelStartDateText = firstDate!.dateForCalendar()
      } else {
        let range = datesRange(from: firstDate!, to: date)
        lastDate = range.last
        for day in range {
          calendar.select(day)
        }
        self.dates = range
      }
    } else if firstDate != nil && lastDate != nil {
      for day in calendar.selectedDates {
        calendar.deselect(day)
      }
      lastDate = nil
      firstDate = date
      calendar.select(firstDate!)
      self.dates = [firstDate!]
     }
    self.configureVisibleCells()
    if let firstDate = firstDate {
      calendar.setCurrentPage(firstDate, animated: true)
    }
  }
  
  func calendar(_ calendar: FSCalendar, didDeselect date: Date,
                at monthPosition: FSCalendarMonthPosition) {
    if firstDate != nil && lastDate != nil {
      for day in calendar.selectedDates {
        calendar.deselect(day)
      }
      lastDate = nil
      firstDate = date
      calendar.select(firstDate!)
      self.dates = [firstDate!]
    } else if lastDate == nil && firstDate == date {
      for day in calendar.selectedDates {
        calendar.deselect(day)
      }
      lastDate = nil
      firstDate = date
      calendar.select(firstDate!)
      self.dates = [firstDate!]
    }
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

  private func configure(cell: FSCalendarCell, for date: Date,
                         at position: FSCalendarMonthPosition) {
    let customCell = cell as! CalendarCell
    if position == .current {
      
      var selectionType = SelectionType.none
      
      if calendar.selectedDates.contains(date) {
        let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
        let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
        if calendar.selectedDates.contains(date) {
          if calendar.selectedDates.contains(previousDate) &&
              calendar.selectedDates.contains(nextDate) {
            selectionType = .middle
            cell.titleLabel.font = .robotoRegular(size: 14)
          }
          else if calendar.selectedDates.contains(previousDate) &&
                    calendar.selectedDates.contains(date) {
            selectionType = .rightBorder
            cell.titleLabel.font = .robotoBold(size: 14)
          }
          else if calendar.selectedDates.contains(nextDate) {
            selectionType = .leftBorder
            cell.titleLabel.font = .robotoBold(size: 14)
          }
          else {
            selectionType = .single
            cell.titleLabel.font = .robotoBold(size: 14)
          }
        }
      } else {
        selectionType = .none
      }
      if selectionType == .none {
        customCell.selectionLayer.isHidden = true
        cell.titleLabel.font = .robotoRegular(size: 14)
        return
      }
      customCell.selectionLayer.isHidden = false
      customCell.selectionType = selectionType
    } else {
      customCell.selectionLayer.isHidden = true
    }
  }

  func datesRange(from: Date, to: Date) -> [Date] {
    if from > to {
      return [Date]()
    }
    var tempDate = from
    var array = [tempDate]
    
    while tempDate < to {
      tempDate = gregorian.date(byAdding: .day, value: 1, to: tempDate)!
      array.append(tempDate)
    }
    return array
  }
  
}


