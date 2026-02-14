# 스토어 결제 식별자/심사 준비 체크리스트

## 1) 코드 식별자 값 목록

- **iOS Bundle ID** (`ios/Runner.xcodeproj/project.pbxproj`)
  - `com.rsr41.MagicAnswerBook`
- **Android applicationId** (`android/app/build.gradle`)
  - `com.magicanswerbook.magic_answer_book`
- **IAP Product ID** (`lib/services/iap_service.dart`)
  - `remove_ads_forever_4990`

> ⚠️ iOS/Android 앱 식별자와 IAP 상품 ID는 서로 다른 값이어도 됩니다.
> 다만, 각 플랫폼 콘솔(App Store Connect / Play Console)에는 코드와 **완전히 동일한 문자열(대소문자 포함)**로 등록되어 있어야 합니다.

## 2) 콘솔 등록값 일치 확인 (수동)

### App Store Connect
- [ ] 앱의 Bundle ID가 `com.rsr41.MagicAnswerBook`로 등록됨
- [ ] In-App Purchase 상품 ID가 `remove_ads_forever_4990`로 등록됨
- [ ] IAP 상태가 "Ready to Submit"/"Approved" 등 실제 테스트 가능한 상태

### Play Console
- [ ] 앱의 Application ID가 `com.magicanswerbook.magic_answer_book`로 등록됨
- [ ] 앱 내 상품(Product ID)이 `remove_ads_forever_4990`로 등록됨
- [ ] 상품이 "활성" 상태이며, 최소 1개 트랙(내부 테스트 등)에 배포되어 테스트 가능

## 3) 테스트 계정 등록 (수동)

### iOS Sandbox Tester
- [ ] App Store Connect > Users and Access > Sandbox Testers에서 테스트 계정 추가
- [ ] 테스트 기기에서 기존 App Store 계정 로그아웃 후 Sandbox 계정으로 결제 테스트

### Android License Tester
- [ ] Play Console > Settings > License testing 에 테스터 Gmail 추가
- [ ] 테스터 계정으로 내부 테스트 트랙 앱 설치 후 결제 테스트

## 4) 심사 노트 기재 문구 (복붙용)

아래 문구를 App Store 심사 노트 / Play Console 앱 검토 메모에 기재:

```text
결제 테스트 경로:
설정 > 광고 제거 > 구매/복원

"광고 제거"는 비소모성 상품(remove_ads_forever_4990)이며,
복원 버튼으로 기존 구매 복원을 확인할 수 있습니다.
```

## 실수 포인트 재확인

- [ ] 상품 ID 문자열 오탈자(대소문자/언더스코어 포함) 없음
- [ ] 콘솔에서 상품 생성만 하고 "활성화/검토 제출" 단계를 누락하지 않음

## 5) 광고(AdMob) 운영값 반영 체크

- [ ] Android App ID: `android/local.properties`에 운영값 추가
  - `admob.appId=ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy`
- [ ] iOS App ID: `ios/Flutter/Release.xcconfig`의 아래 값을 운영값으로 교체
  - `GAD_APPLICATION_ID=ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy`
- [ ] 광고 단위 ID는 빌드 시 `--dart-define`로 주입
  - `ANDROID_BANNER_AD_UNIT_ID`
  - `IOS_BANNER_AD_UNIT_ID`
  - `ANDROID_INTERSTITIAL_AD_UNIT_ID`
  - `IOS_INTERSTITIAL_AD_UNIT_ID`
- [ ] 테스트용 App ID(`ca-app-pub-3940256099942544~...`)가 릴리즈 빌드에 남아있지 않음

## 6) Android 서명키/릴리즈 준비 체크

- [ ] `android/app/upload-keystore.jks` 백업 완료(별도 안전한 저장소)
- [ ] `android/key.properties` 값 확인
  - `storeFile=app/upload-keystore.jks`
  - `keyAlias=upload`
- [ ] `key.properties`는 외부 유출 금지(사내 비밀관리/패스워드 매니저 보관)

## 7) 실제 실행 점검 (Windows CMD 권장)

프로젝트 루트(`C:\Users\qkrtj\magic\magic_answer_book`)에서:

```bat
flutter clean
flutter pub get
flutter run -d chrome
```

Android 릴리즈 검증:

```bat
flutter build appbundle --release ^
  --dart-define=ANDROID_BANNER_AD_UNIT_ID=ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx ^
  --dart-define=ANDROID_INTERSTITIAL_AD_UNIT_ID=ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx
```

iOS 릴리즈(맥에서 실행):

```bash
flutter build ipa --release \
  --dart-define=IOS_BANNER_AD_UNIT_ID=ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx \
  --dart-define=IOS_INTERSTITIAL_AD_UNIT_ID=ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx
```
