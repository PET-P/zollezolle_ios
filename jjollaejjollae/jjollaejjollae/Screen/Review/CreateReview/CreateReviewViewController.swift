//
//  CreateReviewViewController.swift
//  jjollaejjollae
//
//  Created by Woochan Park on 2021/10/08.
//

import UIKit
import Photos
import PhotosUI
import SwiftyJSON

class CreateReviewViewController: UIViewController, StoryboardInstantiable, UINavigationControllerDelegate {
  
  var placeInfo: PlaceInfo?
  
  var mainImage: UIImage?
  
  var placeTitle: String?
  
  var placeId: String?
  
  var category: String?
  
  let apiService = APIService.shared
  

  @IBOutlet weak var scrollView: UIScrollView! {
    
    didSet {
      
      scrollView.showsVerticalScrollIndicator = false
      scrollView.showsHorizontalScrollIndicator = false
    }
  }
  
  /**
   장소 사진을 보여주는 이미지뷰
   */
  
  @IBOutlet weak var mainImageView: UIImageView!
  
  @IBOutlet weak var placeTitleLabel: UILabel!
  
  @IBOutlet weak var durationLabel: UILabel!
  
  @IBOutlet var starList: [UIButton]! {
    didSet {
      starList.forEach { button in
        
        button.setImage(UIImage(named: "emptyStar"), for: .normal)
        button.setImage(UIImage(named: "filledStar"), for: .selected)
      }
      
      /**
       기본 3개를 채워지게 함
       */
      setStarRating(to: 3)
    }
  }
  
  var numOfStars: Int {
    return starList.filter {
      $0.isSelected
    }.count
  }
  
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
  
//  private var ratingFactorsDict: [String: Bool] = ["Service": true, "Clean": true, "Mood": true, "Location": true]
  
  private var userSatisfactionDict: [SatisfactionType: Bool] = {
    
    var dict = [SatisfactionType: Bool]()
    
    SatisfactionType.allCases.forEach { satisfaction in
      dict.updateValue(true, forKey: satisfaction)
    }
    
    return dict
  }()
  
  @IBOutlet weak var photoScrollView: UIScrollView! {
    
    didSet {
      
      photoScrollView.showsHorizontalScrollIndicator = false
    }
  }
  
  @IBOutlet weak var userReviewPhotoCollectionView: UICollectionView!
  
  /**
   - 사용자가 리뷰에 사용할 사진을 저장하는 리스트
   - 이 리스트는 didSet 이 있어서 추가시 자동으로 콜렉션 뷰 리로드 시킴
   */
  var userReviewPhotoList: [UIImage] = [] {
    didSet {
      userReviewPhotoCollectionView.reloadData()
    }
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    scrollView.contentInsetAdjustmentBehavior = .never
    
    setUpMainImageView()
    
    setUpPlaceTitle()
    
    setUpTapGesture()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    setUpUserReviewPhotoCollectionView()
  }
  
  
  // MARK: - SetUp
  
  func setUpMainImageView() {
    
    guard let partialURL = placeInfo?.imageURLs.first else { return }
    
    mainImageView.setImage(with: partialURL)
  }
  
  func setUpPlaceTitle() {
    
    guard let placeTitle = placeTitle else { return}
    
    placeTitleLabel.text = placeTitle
  }
  
  
  private func setUpTapGesture() {
    
    tapGesture.addTarget(self, action: #selector(didTapContentView))
    
    tapGesture.delegate = self
    
    view.addGestureRecognizer(tapGesture)
    
    view.isUserInteractionEnabled = true
  }
  
  func setUpUserReviewPhotoCollectionView() {
    
    userReviewPhotoCollectionView.dataSource = self
    userReviewPhotoCollectionView.delegate = self
    
    
    
//    guard let layout = userReviewPhotoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
//
//    layout.itemSize = CGSize(width: (self.userReviewPhotoCollectionView.frame.width - (10 * 2)) / 3,
//                             height: self.userReviewPhotoCollectionView.frame.width - (10 * 2))
//
//    userReviewPhotoCollectionView.collectionViewLayout = layout
  }
  
  // MARK: - Target-Action
  
  @objc private func didTapContentView() {
    
    view.endEditing(true)
  }
  
  @IBAction func didTapBackButton(_ sender: UIButton) {
    
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didTapStarButton(_ sender: UIButton) {
    
    /**
     선택된 별의 인덱스를 저장할 변수
     */
    var targetIndex: Int = 0
    
    
    for (index, star) in starList.enumerated() {
      
      /**
       새로 칠하기 위해 우선 모든 별을 끔
       */
      
      star.isSelected = false
      
      /**
       별의 인덱스를 찾음
       */
      
      if star === sender {
        targetIndex = index
      }
    }

    /**
     해당 별 인덱스까지 칠함
     */
    setStarRating(to: targetIndex)
  }
  
  /**
   해당 별 인덱스까지 칠하는 메서드
   */
  
  private func setStarRating(to point: Int) {
    
    guard (0...4).contains(point) else { return }
    
    for (index, star) in starList.enumerated() {
      
      star.isSelected = true
      
      /**
       탭한 별 인덱스까지 칠했다면
       */
      if index == point {
        break
      }
    }
  }
  
  @IBAction func didTapThumbButton(_ sender: UIButton) {
    
    switch sender.superview {
      
      case serviceButtonStack :
        
        guard let (first, second) = bindButton(in: serviceButtonStack) else { return }
        
        toggleButtons(sender, first: first, second: second)
        
//        ratingFactorsDict.updateValue(sender == first, forKey: "Service")
        
        userSatisfactionDict.updateValue(sender == first, forKey: .service)
        
      case cleanButtonStack :
        guard let (first, second) = bindButton(in: cleanButtonStack) else { return }
        
        toggleButtons(sender, first: first, second: second)
        
//        ratingFactorsDict.updateValue(sender == first, forKey: "Clean")
      
        userSatisfactionDict.updateValue(sender == first, forKey: .cleanliness)
        
      
      case moodButtonStack :
        guard let (first, second) = bindButton(in: moodButtonStack) else { return }
        
        toggleButtons(sender, first: first, second: second)
        
//        ratingFactorsDict.updateValue(sender == first, forKey: "Mood")
      
        userSatisfactionDict.updateValue(sender == first, forKey: .mood)
        
      case locationButtonStack :
        guard let (first, second) = bindButton(in: locationButtonStack) else { return }
        
        toggleButtons(sender, first: first, second: second)
        
//        ratingFactorsDict.updateValue(sender == first, forKey: "Location")
        
        userSatisfactionDict.updateValue(sender == first, forKey: .location)

      default :
        return
    }
    
    dump(userSatisfactionDict)
  }
  
  /**
   사진 추가 버튼을 눌렀을 때 작동하는 메서드
   */
  
  @IBAction func didTapAddPhotoButton(_ sender: Any) {
    
    guard userReviewPhotoList.count <= 3 else {
      
      let controller = UIAlertController(title: "사진 개수 제한", message: "사진은 4개까지만 추가할 수 있어요 😲", preferredStyle: .alert)
      
      let okAction = UIAlertAction(title: "알겠어요", style: .default, handler: nil)
      
      controller.addAction(okAction)
      
      present(controller, animated: true, completion: nil)
      
      return
    }
    
    let imagePicker = UIImagePickerController()
    
    imagePicker.sourceType = .photoLibrary
    
    /**
     사진 editing 은 하지 않음, 포토 라이브러리 사진 그대로 올려야함
     */
    
    imagePicker.delegate = self
    
    self.present(imagePicker, animated: true, completion: nil)
    
  }
  
  /**
   전달받은 스택뷰의 thumbsUp & thumbsDown 버튼을 튜플에 바인딩한다
   */
  private func bindButton(in stackView: UIStackView) -> (UIButton, UIButton)? {
    
    guard let firstButton = stackView.arrangedSubviews[0] as? UIButton else { return nil }
    
    guard let secondButton = stackView.arrangedSubviews[1] as? UIButton else { return nil }
    
    return (firstButton, secondButton)
  }
  
  /**
   Review 모델을 만들어서 서버에 추가한다.
   
   - [작성완료] 버튼을 탭했을 때 호출되는 메서드
   */
  
  @IBAction func didTapCompleteButton(_ sender: Any) {
   /**
    Review 모델 만들기
    */
    
    guard reviewTextView.text.isNotEmpty, let reviewText = reviewTextView.text else {
      
      let controller = UIAlertController(title: "작성한 리뷰글이 없네요?😭", message: "글을 작성해서 완료해주세요", preferredStyle: .alert)
      
      let okAction = UIAlertAction(title: "알겠어요", style: .default, handler: nil)
      
      controller.addAction(okAction)
      
      present(controller, animated: true, completion: nil)
      return
    }
    
    
    guard let userId = UserManager.shared.userInfo?.id else { return }
    
    guard let placeId = placeId, let category = category else { return }
    
    /**
     true 값을 가진 요소 중 '키'만 저장
     */
    let satisfactionList = userSatisfactionDict.filter { (key, value) in
      value == true
    }.map { $0.key }
    
    let review = UserReview.init(rating: numOfStars, satisfactionList: satisfactionList, reviewImages: userReviewPhotoList, reviewText: reviewText, userId: userId, placeId: placeId, category: category)
    
    guard let token = UserManager.shared.userIdandToken?.token else { return }
    
    
    apiService.createReview(token: token, userReview: review) { result in
      
      switch result {
        case .success(let data):
          
          let data = JSON(data)
          
          print(data["message"].stringValue)
          
        case .failure(let statusCode):
          print(statusCode)
      }
    }
    
    /**
     PlaceDetailVC 의 placeInfo 를 새로 업데이트해야함
     */
    
    self.dismiss(animated: true) { [self] in
      
//      guard let vc = presentingViewController as? PlaceDetailTableViewController else { return }
//
//      guard let innerVC = vc.children.first as? InnerReviewTableViewController else { return }
//
//      innerVC.tableView.reloadData()
    }
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

//@available(iOS 14.0, *)
//extension CreateReviewViewController: PHPickerViewControllerDelegate {
//
//  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//
//    picker.dismiss(animated: true, completion: nil)
//
//    results.forEach { result in
//
//      let itemProvider = result.itemProvider
//
//      if itemProvider.canLoadObject(ofClass: UIImage.self) {
//
//        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
//
//          if let error = error {
//            fatalError(error.localizedDescription)
//          }
//
//          self.selectedPhotos.append(image as! UIImage)
//        }
//      } else {
//        print(#function,"- Cannot Load PhotoObject")
//      }
//    }
//  }
//}

extension CreateReviewViewController: UIImagePickerControllerDelegate {
  
  /**
   사용자가 사진을 선택했을 때 호출되는 메서드
   */
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    guard let image = info[.originalImage] as? UIImage else { return }
    
    /**
     다운 샘플링
     */
    
    guard let downSampledImageData = image.jpegData(compressionQuality: 0.1) else { return }
    
    guard let downSampledImage = UIImage(data: downSampledImageData) else { return }
    
    
    /**
     userReviewPhotoList에 사진 추가

     */
    guard let presentingVC = picker.presentingViewController as? CreateReviewViewController else { return }
   
    presentingVC.userReviewPhotoList.append(downSampledImage)

    
    /**
     원한다면 completion 핸들러에서 구현해주어도 됨
     */
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    
    guard let presentingVC = picker.presentingViewController as? CreateReviewViewController else { return }
    
    presentingVC.userReviewPhotoList.append(#imageLiteral(resourceName: "cafe"))
    
    picker.dismiss(animated: true, completion: nil)
  }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension CreateReviewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return userReviewPhotoList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserReviewPhotoCollectionViewCell.identifier, for: indexPath) as? UserReviewPhotoCollectionViewCell else { return UICollectionViewCell() }
    
    cell.mainImage = userReviewPhotoList[indexPath.item]
    cell.deleteButton.tag = indexPath.item
    cell.deleteButton.addTarget(self, action: #selector(didTapPhotoDeleteButton(sender:)), for: .touchUpInside)
    
    return cell
  }
  
  /**
   버튼의 태그 값을 인덱스로 계산하여 userReviewPhotoList 내부의 사진을 지운다.
   - PhocoCell 내부의 [x] 버튼을 클릭하였을때 호출되는 메서드
   */
  
  @objc func didTapPhotoDeleteButton(sender: UIButton) {
    
    let targetIndex = sender.tag
    
    /**
     버튼의 tag 는 [0 ~ 포토리스트 개수 -1] 사이 숫자일 것임
     */
    guard (0...userReviewPhotoList.count-1).contains(targetIndex) else { return }
    
    
    userReviewPhotoList.remove(at: targetIndex)
  }
}

extension CreateReviewViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: (collectionView.frame.width - (10 * 2)) / 3,
                             height: collectionView.frame.height - (10 * 2))
  }
}
