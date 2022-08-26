# 쫄래쫄래 - 반려동물 동반여행 O2O 서비스

![Generic badge](https://img.shields.io/badge/Xcode-12.5.1-blue.svg)  ![Generic badge](https://img.shields.io/badge/iOS-13.0-yellow.svg)  ![Generic badge](https://img.shields.io/badge/Swift-5-green.svg)  ![Generic badge](https://img.shields.io/badge/Moya-14.0-red.svg)  ![Generic badge](https://img.shields.io/badge/Kingfisher-6.0-orange.svg)

'쫄래쫄래'앱은 반려동물과 사람이 함께 여행을 갈 수 있도록 도움을 주는 앱입니다. 반려동물 정보와 위치정보를 통해서 반려동물 동반 가능 장소를 추천해주고, 앱을 통해서 반려동물 동반여행을 계획할 수 있습니다.

** 앱스토어 바로가기 현재 version 1.0.2**

<a href="https://apps.apple.com/kr/app/%EC%AB%84%EB%9E%98%EC%AB%84%EB%9E%98-%EB%B0%98%EB%A0%A4%EB%8F%99%EB%AC%BC-%EB%8F%99%EB%B0%98-%EC%9E%85%EC%9E%A5-%EC%9E%A5%EC%86%8C-%EB%AA%A8%EC%9D%8C-%ED%94%8C%EB%9E%AB%ED%8F%BC/id1593023162" target="_blank"><img src="https://user-images.githubusercontent.com/42762236/127537585-a07753d1-d0af-4cdc-8f53-24fbfae72be8.png" width="200px" /></a>

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
### 앱 배포의 경험
### 네트워크 통신에 대한 이해
### 이미지 캐시처리
### Firebase 스토리지에 이미지 저장과 메타데이터
### 다양한 애니메이션
### 달력

## 수상이력
'쫄래쫄래' 우수상(2021 펫 아이디어 경진대회, 건국대학교), 2021.12
'쫄래쫄래' 우수상(2021 세종-하계 Start-up camp), 2021.07
'쫄래쫄래' 3등-한국콘텐츠학회장상 (9th K-Hackathon Software Contest), 2021.12

