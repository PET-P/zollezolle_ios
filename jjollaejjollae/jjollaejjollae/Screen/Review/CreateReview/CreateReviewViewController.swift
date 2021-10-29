//
//  CreateReviewViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/08.
//

import UIKit
import PhotosUI

// TODO: 최상단 사진과 최하단 버튼 늘어나는 효과
// TODO: Custom Switch

class CreateReviewViewController: UIViewController, StoryboardInstantiable {

  @IBOutlet weak var scrollView: UIScrollView! {
    
    didSet {
      
      scrollView.showsVerticalScrollIndicator = false
      scrollView.showsHorizontalScrollIndicator = false
    }
  }
  
  @IBOutlet weak var accomodationTitleLabel: UILabel!
  
  @IBOutlet weak var durationLabel: UILabel!
  
  @IBOutlet var starList: [UIButton]!
  
  @IBOutlet weak var withPetSatisfactionLabel: UILabel!
  
  @IBOutlet weak var customSwitch: ZollaeCustomSwitch!
  
  @IBOutlet var positiveFactorButtons: [UIButton]! {
    didSet {
      positiveFactorButtons.forEach {
        
        $0.layer.cornerRadius = 5
        
        $0.tintColor = .clear
      }
    }
  }
  
  
  @IBOutlet weak var negativeFeedbackTextView: UITextView! {
    
    didSet {
      
      negativeFeedbackTextView.isHidden = false
      negativeFeedbackTextView.layer.cornerRadius = 5
    }
  }
  
  @IBOutlet weak var serviceButtonStack: UIStackView!
  
  @IBOutlet weak var cleanButtonStack: UIStackView!
  
  @IBOutlet weak var moodButtonStack: UIStackView!
  
  @IBOutlet weak var locationButtonStack: UIStackView!
  
  @IBOutlet weak var reviewTextView: UITextView! {
    
    didSet {
      reviewTextView.layer.cornerRadius = 5
    }
  }
  
  private let tapGesture = UITapGestureRecognizer()
  
  var starRating: Int = 0
  
  private var previousContentOffset: CGPoint = CGPoint(x: 0, y: 0)
  
  private var ratingFactorsDict: [String: Bool] = ["Service": true, "Clean": true, "Mood": true, "Location": true]
  
  @IBOutlet weak var photoScrollView: UIScrollView! {
    
    didSet {
      
      photoScrollView.showsHorizontalScrollIndicator = false
    }
  }
  
  @IBOutlet weak var photoImageStackView: UIStackView!
  
  private var selectedPhotos: [UIImage] = [] {
    
    didSet {
      // 사진이 추가되었다면
      if oldValue.count < selectedPhotos.count {
//        photoScrollView.addArrangedSubviews(UIImageView(image: selectedPhotos.last!))
        
        let imageView = UIImageView(image: selectedPhotos.last!)
        
        photoImageStackView.addArrangedSubview(imageView)
        
        imageView.widthAnchor.constraint(equalTo: photoImageStackView.heightAnchor).isActive = true
      }
    }
  }
  
  private var maximumPhotoLimit: Int {
    return 4
  }
  
  private var availableNumberOfPhotos: Int {
    return maximumPhotoLimit - selectedPhotos.count
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.contentInsetAdjustmentBehavior = .never
    
    customSwitch.delegate = self
    
    setUpTapGesture()
  }
  
  
  // MARK: - SetUp
  
  private func setUpTapGesture() {
    
    tapGesture.addTarget(self, action: #selector(didTapContentView))
    
    tapGesture.delegate = self
    
    view.addGestureRecognizer(tapGesture)
    
    view.isUserInteractionEnabled = true
  }
  
  // MARK: - Target-Action
  
  @objc private func didTapContentView() {
    view.endEditing(true)
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    
    print(#function)
  }
  
  @IBAction func didTapStarButton(_ sender: UIButton) {
    
    starList.forEach { star in
      star.isSelected = false
    }
    
    for (index,star) in starList.enumerated() {
      
      star.isSelected = true
      
      if star === sender {
        starRating = index + 1
        break
      }
    }
  }
  
  @IBAction func didTapPositiveFactorButton(_ sender: UIButton) {
    
    sender.isSelected.toggle()
    
    if sender.isSelected {
      sender.backgroundColor = .themePaleGreen
    } else {
      sender.backgroundColor = #colorLiteral(red: 0.9567790627, green: 0.9569163918, blue: 0.956749022, alpha: 1)
    }
  }
  
  
  @IBAction func didTapThumbButton(_ sender: UIButton) {
    
    
    switch sender.superview {
      case serviceButtonStack :
        let (first, second) = bindButton(in: serviceButtonStack)
        
        toggleButtons(sender, first: first, second: second)
        
        ratingFactorsDict.updateValue(sender == first, forKey: "Service")
        
      case cleanButtonStack :
        let (first, second) = bindButton(in: cleanButtonStack)
        
        toggleButtons(sender, first: first, second: second)
        
        ratingFactorsDict.updateValue(sender == first, forKey: "Clean")
        
      
      case moodButtonStack :
        let (first, second) = bindButton(in: moodButtonStack)
        
        toggleButtons(sender, first: first, second: second)
        
        ratingFactorsDict.updateValue(sender == first, forKey: "Mood")
        
      case locationButtonStack :
        let (first, second) = bindButton(in: locationButtonStack)
        
        toggleButtons(sender, first: first, second: second)
        
        ratingFactorsDict.updateValue(sender == first, forKey: "Location")

      default :
        return
    }
  }
  
  @IBAction func didTapAddPhotoButton(_ sender: Any) {
    
    if #available(iOS 14.0, *) {
      
      var configuration = PHPickerConfiguration()
      
      configuration.filter = .images
      
      if availableNumberOfPhotos  <= 0 {
        print("더 이상 선택 불가")
      }
      
      configuration.selectionLimit = availableNumberOfPhotos
      
      let picker = PHPickerViewController(configuration: configuration)
      
      picker.delegate = self
      
      present(picker, animated: true, completion: nil)
    }

  }
  
  func bindButton(in stackView: UIStackView) -> (UIButton, UIButton) {
    
    guard let firstButton = stackView.arrangedSubviews[0] as? UIButton else { fatalError(#function) }
    
    guard let secondButton = stackView.arrangedSubviews[1] as? UIButton else { fatalError(#function) }
    
    return (firstButton, secondButton)
  }

  
  @IBAction func didTapCompleteButton(_ sender: Any) {
    
//    print(ratingFactorsDict)
    
      selectedPhotos.append(UIImage(systemName: "heart")!)
  }
  
  
  func toggleButtons(_ sender: UIButton, first: UIButton, second: UIButton) {
    
    if sender == first {
        if sender.isSelected != true {
          sender.isSelected.toggle()
          second.isSelected.toggle()
          return
        }
    } else {
      if sender.isSelected != true {
        sender.isSelected.toggle()
        first.isSelected.toggle()
        return
      }
    }
  }


}

// MARK: - ZollaeCustomSwitchDelegate

extension CreateReviewViewController: ZollaeCustomSwitchDelegate {
  
  func isOnValueChage(isOn: Bool) {
    
    if isOn {
      
      negativeFeedbackTextView.isHidden = true
    } else {
      
      negativeFeedbackTextView.isHidden = false
    }
  }
}

// MARK: - KeyBoardNotification Action

extension CreateReviewViewController {
  
  
  @objc func keyboardDidShow(_ notification: Notification) {
    
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
    
    let insets = UIEdgeInsets(top: -keyboardFrame.height, left: 0, bottom: 0, right: 0)
    
    scrollView.contentInset = insets
 
    scrollView.isScrollEnabled = false
    
    if negativeFeedbackTextView.isFirstResponder {
      
      let newContentOffset = CGPoint(x: 0,
                                     y: negativeFeedbackTextView.superview!.frame.minY + ( negativeFeedbackTextView.frame.minY / 2 ))
      
      scrollView.setContentOffset(newContentOffset, animated: true)
    }
    
    if reviewTextView.isFirstResponder {
      
      view.bounds = CGRect(x: view.bounds.minX, y: view.bounds.minY + keyboardFrame.height / 2, width: view.bounds.width, height: view.bounds.height)
      
      let newContentOffset = CGPoint(x: 0, y: scrollView.frame.maxY)
      
      scrollView.setContentOffset(newContentOffset, animated: true)
    }
  }
  
  @objc func keyboardWillHide(_ notification: Notification) {
    
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
    
    
    scrollView.contentInset = UIEdgeInsets.zero
    
    if reviewTextView.isFirstResponder {
      
      view.bounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
      
      scrollView.contentOffset.y = scrollView.frame.maxY
    }
    
    scrollView.isScrollEnabled = true
  }
}

// MARK: - UIGestureRecognizerDelegate

extension CreateReviewViewController : UIGestureRecognizerDelegate {
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    
    if touch.view!.isDescendant(of: customSwitch) {
      return false
    }

    return true
  }
}

@available(iOS 14.0, *)
extension CreateReviewViewController: PHPickerViewControllerDelegate {
  
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    
    picker.dismiss(animated: true, completion: nil)
    
    results.forEach { result in
      
      let itemProvider = result.itemProvider
      
      if itemProvider.canLoadObject(ofClass: UIImage.self) {
        
        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
          
          if let error = error {
            fatalError(error.localizedDescription)
          }
          
          self.selectedPhotos.append(image as! UIImage)
        }
      } else {
        print(#function,"- Cannot Load PhotoObject")
      }
    }
  }
  
  
}

struct CustomerReview {
  
  var ratingStar: Int
  var isPositive: Bool
  var positiveFeedBack: String
  var negativeFeedback: String?
  var factors: [String: Bool]
  
  var mainReview: String?
}

enum FeedBackType {
//  case positive(.)
//
}


