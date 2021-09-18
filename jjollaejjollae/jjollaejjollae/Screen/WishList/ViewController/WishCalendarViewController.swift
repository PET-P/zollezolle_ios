//
//  WishCalendarViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/17.
//

import UIKit
import FSCalendar

class WishCalendarViewController: UIViewController {
  
  //MARK: - IBOUTLET
  
  @IBOutlet weak var navTitle: UILabel! {
    didSet {
      navTitle.font = .robotoBold(size: 16)
      navTitle.textColor = .gray01
    }
  }
  
  @IBOutlet weak var listTitle: UILabel! {
    didSet {
      listTitle.font = .robotoMedium(size: 14)
      listTitle.textColor = .gray03
    }
  }
  
  @IBOutlet weak var listTitleTextField: UITextField! {
    didSet {
      listTitleTextField.borderStyle = .none
      listTitleTextField.placeholder = "여기에 입력하세요"
      listTitleTextField.backgroundColor = .clear
    }
  }
  
  @IBOutlet weak var ListView: UIView! {
    didSet {
      ListView.setRounded(radius: 10)
      ListView.setBorder(borderColor: .gray03, borderWidth: 1)
      ListView.backgroundColor = .clear
      
    }
  }
  
  @IBOutlet weak var travelDateLabel: UILabel! {
    didSet {
      travelDateLabel.font = .robotoMedium(size: 14)
      travelDateLabel.textColor = .gray03
    }
  }
  
  @IBOutlet weak var startEndDateLabel: UILabel! {
    didSet {
      startEndDateLabel.font = .robotoMedium(size: 16)
      startEndDateLabel.textColor = .gray01
      startEndDateLabel.text = "날짜를 선택해주세요"
    }
  }
  
  @IBOutlet weak var refreshButton: UIButton! {
    didSet {
      refreshButton.titleLabel?.font = .robotoMedium(size: 14)
      refreshButton.setTitleColor(.gray03, for: .normal)
    }
  }
  
  
  @IBOutlet weak var saveButton: UIButton! {
    didSet {
      saveButton.backgroundColor = .themeGreen
      saveButton.setTitleColor(.white, for: .normal)
      saveButton.setRounded(radius: 10)
      
    }
  }
  
  
  @IBOutlet weak var calendarSwitch: JJollaeSwitch! {
    didSet {
      calendarSwitch.setButtonTitle(isOn: "ON", isOff: "OFF")
      calendarSwitch.setTitleFont(font: .robotoBold(size: 10))
      calendarSwitch.setCircleFrame(frame: CGRect (x: 0, y: 2.5, width: 25, height: 25))
      calendarSwitch.setOn(on: true, animated: true)
      calendarSwitch.setSwitchColor(onColor: .themePaleGreen, offColor: .gray05)
      calendarSwitch.setSwitchColor(onTextColor: .themeGreen, offTextColor: .gray03)
    }
  }
  
  @IBOutlet weak var weekDaysView: UIView! {
    didSet {
      weekDaysView.addBorder([.bottom], color: .gray05, width: 1)
    }
  }
  
  @IBOutlet var weekDays: [UILabel]! {
    didSet {
      weekDays.forEach { (days) in
        days.font = .robotoRegular(size: 13)
        days.textColor = .gray03
      }
      weekDays[0].textColor = .themeGreen
    }
  }
  
  @IBOutlet weak var calendar: FSCalendar!
  fileprivate var gregorian = Calendar(identifier: .gregorian)
  
  //MARK: - Variables
  var dates: [Date]? {
    didSet {
      if let dates = dates {
        if dates.count >  1 {
          saveButton.backgroundColor = .themeGreen
          saveButton.setTitle("\(dates.count-1)박 선택", for: .normal)
        } else {
          saveButton.backgroundColor = .themePaleGreen
          saveButton.setTitle("1박 이상을 선택해주세요", for: .normal)}
      } else {
        saveButton.backgroundColor = .themePaleGreen
        saveButton.setTitle("날짜를 선택해주세요", for: .normal)
      }
    }
  }
  
  private var firstDate: Date? {
    didSet {
      
    }
  }
  
  private var lastDate: Date? {
    didSet {
      
    }
  }
  
  var dateCompletionHandler: (([Date?]) -> [Date?])?
  private let transParentView = UIView()
  
  //MARK: - IBACTION
  @IBAction func didTapSaveButton(_ sender: UIButton) {
    _ = dateCompletionHandler?([firstDate, lastDate])
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didTapXButton(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didTapRefreshButton(_ sender: UIButton) {
    
  }
  
  //MARK: - LIFECYCLE

  override func viewDidLoad() {
    super.viewDidLoad()
    calendar.delegate = self
    calendar.dataSource = self
    calendarSwitch.delegate = self
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUpCalendar()
  }
  
}

//MARK: - Switch Delegate


extension WishCalendarViewController: JJollaeButtonDelegate {
  
  func addTransparentView() {
    transParentView.frame = calendar.frame
    view.addSubview(transParentView)
    transParentView.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
    
    transParentView.alpha = 0
    UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
      self.transParentView.alpha = 0.2
    }, completion: nil)
  }
  
  func removeTransparentView() {
    UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
      self.transParentView.alpha = 0.0
    }, completion: nil)

  }
  
  func isOnValueChage(isOn: Bool) {
    if isOn {
      removeTransparentView()
    } else {
      addTransparentView()
    }
    
  }
  
  
}


//MARK: - Calendar

extension WishCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
  
  private func setUpCalendar() {
    calendar.appearance.selectionColor = .themePaleGreen
    calendar.appearance.headerMinimumDissolvedAlpha = 0.0
    calendar.appearance.todayColor = .themeGreen
    calendar.appearance.headerDateFormat = "YYYY.M"
    calendar.appearance.headerTitleColor = .themeGreen
    calendar.appearance.headerTitleAlignment = .left
    calendar.appearance.headerTitleOffset = CGPoint(x: 20, y: 10)
    calendar.appearance.headerSeparatorColor = UIColor.clear.withAlphaComponent(0)
    calendar.appearance.headerTitleFont = .robotoBold(size: 18)
    calendar.appearance.titleFont = .robotoRegular(size: 14)
    calendar.appearance.titleSelectionColor = .themeGreen
    calendar.weekdayHeight = 0
    calendar.placeholderType = .none
    calendar.allowsMultipleSelection = true
    calendar.scrollEnabled = true
    calendar.scrollDirection = .vertical
    calendar.today = nil
    calendar.register(CalendarCell.self, forCellReuseIdentifier: "cell")
  }
  //MARK: - CalendarDataSource
  
  
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
      return UIColor.themeGreen
    }
    return UIColor(rgb: 0x454545)
  }
  //MARK: - CalendarDelegate
  
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
        //        travelStartDateText = firstDate!.dateForCalendar()
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
