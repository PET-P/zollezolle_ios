# 쫄래쫄래 - 반려동물 동반여행 O2O 서비스


![Generic badge](https://img.shields.io/badge/Xcode-12.5.1-blue.svg)  ![Generic badge](https://img.shields.io/badge/iOS-13.0-yellow.svg)  ![Generic badge](https://img.shields.io/badge/Swift-5-green.svg)  ![Generic badge](https://img.shields.io/badge/Moya-14.0-red.svg)  ![Generic badge](https://img.shields.io/badge/Kingfisher-6.0-orange.svg)


![191_드래그함_](https://user-images.githubusercontent.com/69891604/187135017-b395a333-bbac-4b5e-8dd5-90eacabbfced.png)


'쫄래쫄래'앱은 반려동물과 사람이 함께 여행을 갈 수 있도록 도움을 주는 앱입니다. 반려동물 정보와 위치정보를 통해서 반려동물 동반 가능 장소를 추천해주고, 앱을 통해서 반려동물 동반여행을 계획할 수 있습니다.



**앱스토어 바로가기 현재 version 1.0.2**


version 1.0.2 (2022.3.10)


vesions 1.0.1 (2021.11.7)

<a href="https://apps.apple.com/kr/app/%EC%AB%84%EB%9E%98%EC%AB%84%EB%9E%98-%EB%B0%98%EB%A0%A4%EB%8F%99%EB%AC%BC-%EB%8F%99%EB%B0%98-%EC%9E%85%EC%9E%A5-%EC%9E%A5%EC%86%8C-%EB%AA%A8%EC%9D%8C-%ED%94%8C%EB%9E%AB%ED%8F%BC/id1593023162" target="_blank"><img src="https://user-images.githubusercontent.com/42762236/127537585-a07753d1-d0af-4cdc-8f53-24fbfae72be8.png" width="200px" /></a>

# 앱 화면
<p class='center'> 
    <img src="https://user-images.githubusercontent.com/69891604/187135661-df86b6f2-0e1f-419a-9356-ce7907ec7877.png" width="200" height="400"/>
    <img src="https://user-images.githubusercontent.com/69891604/187135672-003b60c4-a1dc-4434-86ff-df294198c6db.png" width="200" height="400"/>
    <img src="https://user-images.githubusercontent.com/69891604/187135685-56df498e-a9a4-430c-8db8-89e75d423ef6.png" width="200" height="400"/>
    <img src="https://user-images.githubusercontent.com/69891604/187135695-5715fe66-3576-463d-9eb6-0dc023577379.png" width="200" height="400"/>
    <img src="https://user-images.githubusercontent.com/69891604/187135708-86a9c150-28cf-4eb9-b10c-c0264074d968.png" width="200" height="400"/>
    <img src="https://user-images.githubusercontent.com/69891604/187135717-81683af0-fc8f-46f6-9a57-63948d9e8930.png" width="200" height="400"/>
    <img src="https://user-images.githubusercontent.com/69891604/187135719-55e0f434-7e42-4086-a95f-dfd9f8216d81.png" width="200" height="400"/>
</p>


## 기획의도
1500만 반려인의 55%가 반려동물 양육 시 외출/여행의 어려움을 호소한다. 또한 검색 시 업체 수 대비 과도한 콘텐츠 양 및 불필요 광고용 컨텐츠에 고객은 노출된다. 따라서 앱에서 반려동물 정보와 위치정보를 통해서 반려동물 동반 가능 장소를 추천 및 검색을 가능하게하여, 반려동물 동반 여행을 계획할 수 있는 앱을 기획하였다.

## Dependencies
```
  pod 'SwiftLint'
  pod 'Kingfisher', :git => 'https://github.com/onevcat/Kingfisher.git', :branch => 'version6-xcode13'
  pod 'Moya', '~> 14.0'
  pod 'FSCalendar'
  pod 'NMapsMap'
  pod 'naveridlogin-sdk-ios'
  pod 'KakaoSDKCommon'
  pod 'KakaoSDKAuth'
  pod 'KakaoSDKUser'
  pod 'KakaoSDKTalk'
  pod 'Firebase/Analytics'
  pod 'Firebase/Storage'
  pod 'Gifu'
  pod 'Toast-Swift', '~> 5.0.1'
``` 

## MVC 아키텍처 및 Foldering
* MVC를 기반으로 앱을 개발하였다. MVC를 선택한 이유는 앱을 기획하고, 개발하고 해커톤의 일정을 맞추는데 있어서, 속도가 중시되었다. 그렇기 때문에 가장 익숙한 MVC 아키텍처가 채택되었다. 또한 직관적인 UI개발을 위하여 storyboard를 활용한 개발이 진행되었다. 
* Foldering 구조에서는 Global, Screen, Support 폴더가 존재한다. Global 폴더에는 앱 전반적으로 쓰이는 Model들, 네트워크 통신 서비스, 키체인 서비스, 커스텀 뷰 등이 존재한다. Screen에는 View, ViewController들이 존재한다. Support 폴더에는 AppDelegate 및 이미지 Asset, Font 등이 존재한다.  
```
├── Global
│   ├── Custom
│   ├── Extension
│   ├── Model
│   │   ├── Location
│   │   ├── Pet
│   │   ├── Place
│   │   ├── Review
│   │   └── User
│   ├── Protocol
│   └── Service
├── Screen
│   ├── Base.lproj
│   ├── Detail
│   ├── Login
│   │   ├── Storyboard
│   │   ├── View
│   │   └── ViewController
│   ├── MainTabBar
│   ├── PlaceDetail
│   │   └── InnerReview
│   ├── Review
│   │   ├── AllReviews
│   │   └── CreateReview
│   ├── Search
│   │   ├── Model
│   │   ├── Storyboard
│   │   ├── View
│   │   └── ViewController
│   ├── Splash
│   │   └── Storyboard
│   │       └── Base.lproj
│   └── Tabs
│       ├── HomeTab
│       │   ├── Stroyboard
│       │   ├── ViewController
│       │   └── Xib
│       ├── MapTab
│       │   ├── Storyboard
│       │   ├── View
│       │   └── ViewController
│       ├── MyInfoTab
│       │   ├── Storyboard
│       │   ├── View
│       │   └── ViewController
│       └── WishListTab
│           ├── Storyboard
│           ├── View
│           └── ViewController
└── Support
```

## 배운점
### 협업능력
기획자, 디자이너, iOS 개발자, 서버 개발자와 협업을 진행하면서, 협업 능력을 키울 수 있었다. 협업을 하면서 WBS, 스토리보드를 확인하면서 어떻게 해야지만, 사용자에게 사랑을 받는 앱을 만들 수 있는지 생각할 수 있었다. 결국 '쫄래쫄래'를 개발하면서, 기획파트, 디자인파트 개발파트에 모두 참여를 하였고 앱 개발의 A-Z를 경험할 수 있었다.


<p class='center'> 
    <img src="https://user-images.githubusercontent.com/69891604/187137599-81d79b05-6ba9-4562-9b14-47841271297a.png" height="400"/>
    <img src="https://user-images.githubusercontent.com/69891604/187137604-7b83e506-d0fb-40be-a7e7-d306be7dbe2a.png" height="300"/>
    <img src="https://user-images.githubusercontent.com/69891604/187137616-11808727-02dc-4773-8e29-e1dc651e33be.png" height="300"/>
</p>


### 앱 배포의 경험
첫 앱 배포를 진행하면서 어떻게 앱 배포를 할 수 있는지, 앱 배포를 할 때 어떤 주의사항이 필요한지를 알 수 있었다. 첫 앱 배포를 하면서 해결해야했던 문제는 자동로그인과 Auth2.0 문제였고, 이를 해결하기 위해서 Request Token, Access Token과 이메일로그인, 소셜로그인에 대한 분기문을 모두 만들었다. 
### 네트워크 통신에 대한 이해
첫 앱을 만들면서 어려웠던 부분 중 하나는 네트워크 통신의 문제였다. 네트워크 통신 관련 코드를 Github에서 찾아보면서 다양한 코드를 발견할 수 있었고, 그중에 협업하기도 좋아보이는 Moya를 채택한 코드, 그리고 제네릭을 활용한 코드를 참고해서 쫄래쫄래만의 네트워크 매니저 객체를 만들 수 있었다.
특히 서버 개발자와 Response 형식을 맞추고, 제너릭한 코드를 사용하면서 재사용성이 편한 코드를 짰다. 
``` swift
  func judgeGenericResponse<T: Codable>(_ target: APITarget,
                                        completion: @escaping ((NetworkResult<T>) -> Void)) {
    provider.request(target) { response in
      switch response {
      case .success(let result):
        do {
          let decoder = JSONDecoder()
          let body = try decoder.decode(GenericResponse<T>.self, from: result.data)
          if let data = body.data {
            completion(.success(data))
          }
        } catch {
          print("구조체를 확인하세요")
        }
      case .failure(let error):
        print("\(#function), error: \(error)")
        completion(.failure(error.response?.statusCode ?? -1))
      }
    }
  }
```
### 이미지 캐시처리
KingFisher 라이브러리를 사용하면서 이미지 캐시처리를 진행하였다.  
### Firebase 스토리지에 이미지 저장과 메타데이터
Firebase 스토리지에 이미지를 넘기고, 관련 url과 메타데이터를 서버에 넘기면서 이미지를 저장하였다. 이 방법을 사용하면서, 서버로 직접 이미지 데이터를 보낼 필요 없게 되었고, 편리한 방식이라고 생각한다. 
### 다양한 애니메이션
다양한 애니메이션을 활용을 하였다. 원하는 느낌을 애니메이션으로 만드는 것이 난이도가 있었다. 


<p class='center'> 
    <img src="https://user-images.githubusercontent.com/69891604/187131763-5d348401-7c93-4a69-b1fb-480ca060caa5.gif" width="200" height="400"/>
    <img src="https://user-images.githubusercontent.com/69891604/187131772-9598126c-ac95-4917-b364-bf75467a6240.gif" width="200" height="400"/>
    <img src="https://user-images.githubusercontent.com/69891604/187131783-5b84758c-0882-458b-9239-cab8c4229e7d.gif" width="200" height="400"/>
    <img src="https://user-images.githubusercontent.com/69891604/187131792-487dfb18-6118-4b45-81fc-bb8a8f1708de.gif" width="200" height="400"/>
</p>


### 달력
달력은 FSCanlendar 라이브러리를 사용했다. FSCanlendar를 사용하더라도 안에서 사용되는 로직과 스타일은 다 커스텀이 필요했다. FSCalendar를 사용하면서 후에는 FSCalendar 라이브러리 코드를 참고하여 달력을 직접만드는게 오히려 편할 수 있겠다는 생각이들었다. 그 중에 어려웠던 로직은 여행계획을 짤때 사용되는 달력이었다. 어떨때 달력의 Cell 종류를 바꿔줘야할지, 초기화할지 등 복잡한 로직이이었다.
관련 로직은 `Screen/Tabs/WishlistTab/ViewController/WishCalendarViewController`에 존재한다. 
  `func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)` 에는 달력의 셀을 선택했을때 필요한 로직, `func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition)`에는 선택을 취소했을때 필요한 로직이 존재한다. 
  
  
  <p class='center'> 
      <img src="https://user-images.githubusercontent.com/69891604/187132167-cf184d6b-9f6f-4547-ba4f-7d1005658ef4.gif" width="200" height="400"/>
  </p>
  
  
## 수상이력
* '쫄래쫄래' 우수상(2021 펫 아이디어 경진대회, 건국대학교), 2021.12
* '쫄래쫄래' 우수상(2021 세종-하계 Start-up camp), 2021.07
* '쫄래쫄래' 3등-한국콘텐츠학회장상 (9th K-Hackathon Software Contest), 2021.12

## 아쉬운점
* 처음으로 규모가 있는 iOS 프로젝트를 진행하고, 해커톤에 일정을 맞추면서 시간이 부족하다는 것을 느꼈다. 그로 인해서 구현이 어려운 부분을 디지아너, 기획자와 서로 협의를 하면서 줄여나갔다. 또한 MVC 패턴을 사용하면서 ViewController에 엄청난 로직이 많이 들어가는 과정을 직접 파악하면서, 더 유지보수가 나은 코드, 아키텍처의 당위성이 매우 대두되었다. 특히 여러가지 기능이 존재하는 ViewController에서는 각각의 기능들이 잘 나눠져있어야하고, 그 기능들의 유기적인 연결이 어떠한 기준에 맞춰져 있어야한다는 것을 느꼈다. 개발 도중에, MVC보다는 더 각각의 기능에 맞춰서 세분화가 되어있는 아키텍처, 패턴이 필요하다는 것을 느끼면서, 이 프로젝트를 통해서 MVVM, Clean Architecture, DI Patterns, RIBs를 공부해보는 계기가 되었다. 
 

