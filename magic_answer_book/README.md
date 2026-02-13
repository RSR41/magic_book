# magic_answer_book

Flutter 기반 매직 앤서 북 앱입니다.

## 스토어 식별자 정책 (Android/iOS)

### 1) 최종 브랜드 도메인 기준 네임스페이스 원칙
- 브랜드 도메인이 확정되면 아래 규칙으로 식별자를 정합니다.
  - Android `applicationId`: `com.<brand-domain-reverse>.<app-name>`
  - iOS `PRODUCT_BUNDLE_IDENTIFIER`: `com.<brand-domain-reverse>.<app-name>`
- 예: 브랜드 도메인이 `magicanswerbook.com`이면 권장 네임스페이스는 `com.magicanswerbook.magic_answer_book`입니다.

### 2) 스토어 앱 미생성 상태
- Google Play / App Store Connect에 앱 레코드가 아직 없다면 Android/iOS 모두 동일한 네임스페이스로 통일합니다.
- 권장 통일값
  - Android: `com.magicanswerbook.magic_answer_book`
  - iOS: `com.magicanswerbook.magic_answer_book`

### 3) 스토어 앱이 이미 생성된 상태
- 이미 발급/등록된 스토어 식별자는 **변경하지 않습니다**.
- 현재 저장소 기준 운영 식별자
  - Android: `com.magicanswerbook.magic_answer_book` (유지)
  - iOS: `com.rsr41.MagicAnswerBook` (기존값 유지)
- 이 경우 운영 문서/릴리즈 노트에 “브랜드 네임스페이스 ↔ 실제 스토어 식별자” 매핑을 반드시 기록합니다.

## 실제 스토어 식별자 표

| Platform | 정책 기준(브랜드 도메인) | 실제 운영 식별자 | 상태 | 비고 |
|---|---|---|---|---|
| Android | `com.magicanswerbook.magic_answer_book` | `com.magicanswerbook.magic_answer_book` | 통일됨 | 신규/기존 모두 동일 운영 가능 |
| iOS | `com.magicanswerbook.magic_answer_book` | `com.rsr41.MagicAnswerBook` | 예외(레거시 유지) | 스토어 생성 이력 있는 경우 변경 금지 |

## 릴리즈 운영 매핑 규칙
- 문서 위치: 본 README 표 + 릴리즈 노트(배포 태그별)
- 매핑 포맷(권장)
  - `brand_namespace`: `com.magicanswerbook.magic_answer_book`
  - `android_application_id`: `com.magicanswerbook.magic_answer_book`
  - `ios_bundle_id`: `com.rsr41.MagicAnswerBook`
  - `reason`: `iOS 기존 스토어 등록 식별자 유지`

## 실수 포인트 체크리스트
- 스토어 등록 후 식별자 변경 불가
- Firebase/AdMob/IAP 콘솔 등록값과 식별자 불일치 주의
- 배포 전 점검
  - Android `applicationId` ↔ Firebase Android 앱 등록 패키지명 일치
  - iOS `PRODUCT_BUNDLE_IDENTIFIER` ↔ Firebase iOS 앱 등록 Bundle ID 일치
  - AdMob 앱/광고단위의 플랫폼 앱 매핑 일치
  - IAP 상품이 각 스토어 앱 식별자에 연결되어 있는지 확인

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [online documentation](https://docs.flutter.dev/)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Test Automation

To keep regressions from reaching release builds, run tests through the shared script:

```bash
./tool/run_tests.sh
```

In CI, configure your pipeline to execute this script on every push and pull request so that `flutter test` is always enforced.
