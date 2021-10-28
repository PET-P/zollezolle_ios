//
//  WishCalendarViewController.swift
//  jjollaejjollae
//
//  Created by abc on 2021/09/17.
//

import UIKit
import FSCalendar

protocol EditWishCalendarDelegate: NSObject {
  func didChangeSchedule(name: String, startDate: Date?, endDate: Date?)
}

protocol addWishCalendarDelegate: NSObject {
  func didAddWishList(name: String, startDate: Date?, endDate: Date? )
}

class WishCalendarViewController: UIViewController, StoryboardInstantiable {
  
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
  
  @IBOutlet weak var buttonsView: UIView! {
    didSet {
      buttonsView.addBorder([.top], color: .gray06, width: 1)
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
      calendarSwitch.setCircleRadius(round: 25/2)
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
  
  @IBOutlet weak var calendarStackView: UIStackView!
  
  
  //MARK: - Variables
  
  fileprivate var gregorian = Calendar(identifier: .gregorian)
  
  weak var delegate: EditWishCalendarDelegate?
  weak var addDelegate: addWishCalendarDelegate?
  
  var data: Wish?
  //create - true, edit - false
  private var mode = false

  internal func setMode(mode: Bool) {
    self.mode = mode
  }
  
  func setData(data: Wish?){
    self.data = data
  }
  
  
  var dates: [Date]? {
    didSet {
      if calendarSwitch.isOn == true {
        if let dates = dates {
          if dates.count >  1 {
            saveButton.backgroundColor = .themeGreen
            savebuttonTitle = "\(dates.count-1)박 선택"
            saveButton.isEnabled = true
          } else {
            saveButton.backgroundColor = .themePaleGreen
            savebuttonTitle = "1박 이상을 선택해주세요"
            self.saveButton.isEnabled = false
          }
        } else {
          saveButton.backgroundColor = .themePaleGreen
          savebuttonTitle = "날짜를 선택해주세요"
          self.saveButton.isEnabled = false
        }
      } else {
        self.saveButton.isEnabled = true
      }
    }
  }
  
  private var firstDate: Date? {
    didSet {
      startDateLabelText = firstDate?.dateForCalendar() ?? " "
    }
  }
  
  private var lastDate: Date? {
    didSet {
      endDateLabelText = lastDate?.dateForCalendar() ?? " "
    }
  }
  
  private var savebuttonTitle: String = "저장" {
    didSet {
      self.saveButton.setTitle(savebuttonTitle, for: .normal)
    }
  }
  
  private var startDateLabelText: String = "" {
    didSet {
      startEndDateLabel.text = "\(startDateLabelText) ~ \(endDateLabelText)"
    }
  }
  
  private var endDateLabelText: String = "" {
    didSet {
      startEndDateLabel.text = "\(startDateLabelText) ~ \(endDateLabelText)"
    }
  }
  
  var dateCompletionHandler: (([Date?]) -> [Date?])?
  private let transParentView = UIView()
  
  //MARK: - IBACTION
  @IBAction func didTapSaveButton(_ sender: UIButton) {
    guard let title = listTitleTextField.text else {
      showAlert()
      return}
    guard title != "" else {
      showAlert()
      return
    }
    guard let token = UserManager.shared.userIdandToken?.token else {return}
    guard let userId = UserManager.shared.userIdandToken?.userId else {return}
    //수정
    if !mode {
      delegate?.didChangeSchedule(name: title, startDate: firstDate, endDate: lastDate)
    } else {
      addDelegate?.didAddWishList(name: title, startDate: firstDate, endDate: lastDate)
    }
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didTapXButton(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didTapRefreshButton(_ sender: UIButton) {
   refreshDates()
  }
  
  private func refreshDates(){
    for day in calendar.selectedDates {
      calendar.deselect(day)
    }
    firstDate = nil
    lastDate = nil
    self.dates = nil
    self.configureVisibleCells()
    if calendarSwitch.isOn {
      self.startEndDateLabel.text = "날짜를 선택해주세요"
    } else {
      self.startEndDateLabel.text = ""
    }
  }
  
  //MARK: - LIFECYCLE

  var wishCompletionHandler: ((Wish?) -> (Wish?))?
  
  init(nibName: String?, bundle: Bundle){
    super.init(nibName: nibName, bundle: bundle)
    wishCompletionHandler = {
      data in
      self.data = data
      return data
    }
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    wishCompletionHandler = {
      data in
      self.data = data
      return data
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    calendar.delegate = self
    calendar.dataSource = self
    calendarSwitch.delegate = self
    keyboardSetting()
    resetVC()
    
    // Do any additional setup after loading the view.
  }
  
  // 위시리스트 수정일지 .
  private func resetVC() {
    if mode == true {
      navTitle.text = "위시리스트 만들기"
    } else {
      navTitle.text = "위시리스트 수정하기"
      self.firstDate = data?.Dates?.first
      self.lastDate = data?.Dates?.last
      if let firstDay = data?.Dates?.first, let lastDay = data?.Dates?.last {
        let dates = datesRange(from: firstDay, to: lastDay)
        for date in dates {
          calendar.select(date)
        }
        self.dates = dates
      }
      self.listTitleTextField.text = data?.wishTitle
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUpCalendar()
    resetVC()
  }
}

//MARK: - Switch Delegate

extension WishCalendarViewController: JJollaeButtonDelegate {
  
  func addTransparentView() {
    transParentView.frame = calendarStackView.frame
    view.addSubview(transParentView)
    transParentView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
    
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
      // 처음부터 ison 이 불리기 때문에 이때는 아래 코드가 실행되면 안되서 걍 return
      if firstDate != nil && lastDate != nil {
        return
      }
      removeTransparentView()
      self.refreshDates()
      self.saveButton.isEnabled = false
      self.saveButton.backgroundColor = .themePaleGreen
    } else {
      addTransparentView()
      self.saveButton.backgroundColor = .themeGreen
      self.savebuttonTitle = "저장"
      self.refreshDates()
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

//MARK: - KEYBOARD
extension WishCalendarViewController {
  func keyboardSetting() {
    let tapGesture = UITapGestureRecognizer(
      target: view,
      action: #selector(view.endEditing(_:)))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
  }
}

//MARK: - Alert
extension WishCalendarViewController {
  func showAlert() {
    var alert = UIAlertController(title: "이름을 적으시개", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "아니요", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: "네", style: .default))
    self.present(alert, animated: true, completion: nil)
  }
}

