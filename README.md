# MediaProject
TMDB 영화 API를 통해 trend 영화를 보여주며, 봤던 영화를 기록하는 영화 기록앱

## 개발 환경
```
- 개발 인원 : 1명
- 개발 기간 : 2024.08 - 2024.09 (약 1달)
- Swift 5.10
- Xcode 15.3
- iOS 16.0+
- 세로모드/라이트 모드 지원
```

## 기술스택
UIKit, MVVM, custom Observable

URLSession, Realm, SnapKit

## 핵심기능
| Trend| 영화 정보 | 검색 | 캘린더 | 메모 |
| --- | --- | --- | --- | --- |
|<img width="82%" alt="스크린샷 2024-10-21 오후 11 57 48" src="https://github.com/user-attachments/assets/9d1fcae8-b40b-42b0-85ce-95b095336d7f">|![Detail](https://github.com/user-attachments/assets/70baf6b4-9518-45b3-bf9b-6c77b2a1116f)|<img width="100%" alt="스크린샷 2024-10-21 오후 11 59 06" src="https://github.com/user-attachments/assets/e609517a-e9b7-4113-a51a-33d02111dc14">|<img width="100%" alt="스크린샷 2024-10-22 오전 12 02 58" src="https://github.com/user-attachments/assets/71a5a337-9c05-4df2-a86e-517fa4f7c28d">| <img width="100%" alt="스크린샷 2024-10-22 오전 12 05 18" src="https://github.com/user-attachments/assets/cf6447ac-179b-40b4-b2c9-4fcf8df3d21c"> |

## 주요 기술
- **Architecture**
    - MVVM으로 UI와 Business Logic 분리
    - view에서 쓰일 데이터를 private(set)을 통해 접근은 가능하지만, 값 수정 불가능하게 처리
- **Network**
    - protocol을 활용해 반복되는 url endpoint 관리 및 네트워크 추상화
    - DTO와 Response 모델을 두어 API 통신을 통해 가져오는 데이터 손상 없이 원하는 데이터 모델로 변환하여 사용
    - Decodable 채택한 데이터 모델 타입을 제네릭으로 받아 유연한 응답 모델 처리
    - Result type을 통해 네트워크 통신의 성공, 실패 관리
- **UI**
    - Composional layout을 통해 유연한 layout 구성
    - DiffableDataSource와 Snapshot을 통해 효율적인 데이터 관리 및 애니메이션 처리
    - **UICollectionViewDataSourcePrefetching**을 통해 **offset기반의 pagination** 구현

## 트러블 슈팅
### 1. Section마다 다른 API호출한 결과 값이 뷰에 따로따로 보여지는 이슈
- 원인
    - Section마다 다른 종류의 TMDB API 호출
    - 네트워크 통신은 비동기로 일어나기 때문에 각 요청의 완료 시점을 동기화하기 어려운 문제가 발생
        - UI 업데이트가 따로 일어나 UX적으로 좋지 않은 경험을 줄 수 있음

<img width="701" alt="스크린샷 2024-10-22 오전 1 21 13" src="https://github.com/user-attachments/assets/2d235e0b-4269-40bf-9b97-03294f9e08b4">

- 해결
    - **DispatchGroup**을 사용하여 **비동기 API 통신의 완료를 모니터링**
    - 모든 요청이 완료된 후에 한번에 뷰에 로드할 수 있게 bool값으로 변수 제어
        - ViewController에서 bool 값에 의해 통신 결과로 받은 데이터 로드

### 2. Section마다 다른 Cell Layout 형태
<img width="784" alt="스크린샷 2024-10-18 오후 9 14 13" src="https://github.com/user-attachments/assets/ccc662cd-511f-4b65-ae4e-02bfa6fdd1b2">

- 원인
    - Compositional layout을 활용하여 여러 Section layout을 잡을 때 각 Layout마다 다른 메서드를 만들게 되면 비슷한 메서드를 계속해서 생성하게 됨.
    - 재사용성이 높은 코드를 추구

    <div style="display: flex; justify-content: space-between;">
    <img width="40%" alt="스크린샷 2024-10-22 오전 1 29 38" src="https://github.com/user-attachments/assets/720fefea-64cf-4bb7-b211-07f9ca16a9da">
    <img width="70%" alt="스크린샷 2024-10-22 오전 1 30 28" src="https://github.com/user-attachments/assets/4e8ae76c-f3e7-4b3c-ac72-d03d5a17b175">
    </div>

- 해결
    - 파라미터를 받을 수 있는 열린 형태의 layout 메서드 구성
    - Section마다 Cell layout이 다르기에 Section 모델에 Dictionary 값으로 group 사이즈에 대한 데이터를 갖게 처리

    <img width="951" alt="스크린샷 2024-10-22 오전 1 42 04" src="https://github.com/user-attachments/assets/067fae0e-5f3b-4c33-8baf-acc651bd71ee">
