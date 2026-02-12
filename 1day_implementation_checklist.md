# 마법의 고민해결책 — 하루 구현 체크리스트 (우선순위 순)

> **목표**: 24시간 내 MVP 완성 → iOS/Android 심사 제출 가능  
> **날짜**: 2026-02-11  
> **작성자**: PM+Tech Lead (Claude)

---

## Phase 1: 프로젝트 초기화 (0~2h)

### P1-1. Flutter 프로젝트 생성
- [ ] `flutter create magic_answer_book` 실행
- [ ] Android Studio / VS Code에서 프로젝트 오픈
- [ ] 빌드 타겟 설정: iOS 12.0+, Android API 21+
- [ ] 프로젝트 구조 확인 (`lib/`, `assets/` 폴더)

### P1-2. 필수 패키지 설치
`pubspec.yaml` 에 다음 패키지 추가:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  
  # 상태관리
  riverpod: ^2.5.0
  flutter_riverpod: ^2.5.0
  
  # 로컬 DB
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # 애니메이션
  lottie: ^2.7.0
  
  # 흔들기
  shake: ^2.2.0
  
  # 공유
  share_plus: ^7.2.0
  
  # 광고 (MVP에서는 테스트 ID 사용)
  google_mobile_ads: ^4.0.0
  
  # 인앱결제
  in_app_purchase: ^3.1.11
  
  # 다국어
  intl: ^0.18.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1
  build_runner: ^2.4.7
```

- [ ] `flutter pub get` 실행
- [ ] 패키지 의존성 확인

### P1-3. 프로젝트 설정
- [ ] iOS: `ios/Runner/Info.plist` 에 권한 추가
  ```xml
  <key>NSMotionUsageDescription</key>
  <string>흔들기로 답변을 받기 위해 필요합니다.</string>
  ```
- [ ] Android: `android/app/src/main/AndroidManifest.xml` 에 권한 추가
  ```xml
  <uses-permission android:name="com.google.android.gms.permission.AD_ID"/>
  ```
- [ ] Android: `android/app/build.gradle` 에 minSdkVersion 21 설정
- [ ] AdMob 앱 ID 추가 (테스트 ID 사용):
  - iOS: `ios/Runner/Info.plist` → `ca-app-pub-3940256099942544~1458002511`
  - Android: `android/app/src/main/AndroidManifest.xml` → `ca-app-pub-3940256099942544~3347511713`

### P1-4. 폴더 구조 생성
```
lib/
  main.dart
  models/
    answer.dart
  providers/
    answers_provider.dart
    settings_provider.dart
  screens/
    intro_screen.dart
    home_screen.dart
    result_screen.dart
    saved_screen.dart
    settings_screen.dart
  widgets/
    waiting_overlay.dart
  services/
    answers_service.dart
    storage_service.dart
    ads_service.dart
    iap_service.dart
  l10n/
    app_ko.arb
    app_en.arb
assets/
  data/
    answers.json
  animations/
    waiting.json (Lottie - 생성 필요)
  audio/
    bell.mp3 (효과음 - 무료 리소스 or 생성)
```

- [ ] 폴더 및 파일 생성 완료

---

## Phase 2: 데이터 레이어 (2~4h)

### P2-1. 답변 데이터 모델
`lib/models/answer.dart`:
```dart
class Answer {
  final String id;
  final List<String> tags;
  final Map<String, String> text;      // {'ko': '...', 'en': '...'}
  final Map<String, String> subtext;   // {'ko': '...', 'en': '...'}

  Answer({
    required this.id,
    required this.tags,
    required this.text,
    required this.subtext,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      tags: List<String>.from(json['tags']),
      text: Map<String, String>.from(json['text']),
      subtext: Map<String, String>.from(json['subtext']),
    );
  }
}
```

- [ ] 모델 클래스 작성 완료

### P2-2. 답변 JSON 파일
`assets/data/answers.json`:
- [ ] 첨부된 `magic_answerbook_answers_seed_v0_1_60.json` 을 `answers.json` 으로 복사
- [ ] 200개로 확장 (추가 답변 140개 생성) — 또는 60개로 시작 후 출시 후 확장
- [ ] `pubspec.yaml` 에 assets 등록:
  ```yaml
  flutter:
    assets:
      - assets/data/answers.json
      - assets/animations/
      - assets/audio/
  ```

### P2-3. 답변 서비스
`lib/services/answers_service.dart`:
```dart
class AnswersService {
  List<Answer> _answers = [];
  
  Future<void> loadAnswers() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/answers.json');
      final jsonData = json.decode(jsonString);
      _answers = (jsonData['answers'] as List)
          .map((e) => Answer.fromJson(e))
          .toList();
    } catch (e) {
      // Fallback 답변 20개 하드코딩
      _answers = _getFallbackAnswers();
    }
  }
  
  Answer getRandomAnswer() {
    final random = Random();
    return _answers[random.nextInt(_answers.length)];
  }
  
  List<Answer> _getFallbackAnswers() {
    // 최소 20개 하드코딩
    return [/* ... */];
  }
}
```

- [ ] 답변 서비스 작성 완료
- [ ] Fallback 답변 20개 하드코딩 완료

### P2-4. 로컬 저장 (Hive)
`lib/services/storage_service.dart`:
```dart
class StorageService {
  static const String settingsBoxName = 'settingsBox';
  static const String metaBoxName = 'metaBox';
  static const String savedBoxName = 'savedBox';
  
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(settingsBoxName);
    await Hive.openBox(metaBox Name);
    await Hive.openBox(savedBoxName);
  }
  
  // 설정 관련
  bool get vibration => Hive.box(settingsBoxName).get('vibration', defaultValue: true);
  set vibration(bool value) => Hive.box(settingsBoxName).put('vibration', value);
  
  // 저장 관련 (FIFO 로직)
  Future<void> saveAnswer(Answer answer, String question) async {
    final box = Hive.box(savedBoxName);
    final keys = box.keys.toList();
    
    if (keys.length >= 50) {
      // savedAt 기준 정렬 및 가장 오래된 항목 삭제
      keys.sort((a, b) {
        final aTime = box.get(a)['savedAt'] as DateTime;
        final bTime = box.get(b)['savedAt'] as DateTime;
        return aTime.compareTo(bTime);
      });
      await box.delete(keys.first);
    }
    
    await box.put('saved_${DateTime.now().millisecondsSinceEpoch}', {
      'answerId': answer.id,
      'question': question,
      'text': answer.text,
      'subtext': answer.subtext,
      'savedAt': DateTime.now(),
    });
  }
}
```

- [ ] 저장 서비스 작성 완료
- [ ] FIFO 로직 테스트 완료

---

## Phase 3: 핵심 UI (4~10h)

### P3-1. 인트로 화면 (18~20h 에서 앞당김)
`lib/screens/intro_screen.dart`:
- [ ] 밤하늘 배경 (Gradient 또는 Lottie)
- [ ] 타이틀: "마법의 고민해결책"
- [ ] "고민 해결 시작" 버튼
- [ ] `hasSeenIntro` 로컬 저장 → 홈으로 이동

### P3-2. 홈 화면
`lib/screens/home_screen.dart`:
- [ ] 질문 입력 필드 (0~80자, 선택)
- [ ] 흔들기 안내 문구 + 애니메이션 아이콘
- [ ] "답변 받기" 버튼 (대체 수단)
- [ ] 설정 아이콘 (상단 우측)
- [ ] 흔들기 감지 → `WaitingOverlay` 표시

### P3-3. 흔들기 감지
`lib/widgets/shake_detector.dart`:
```dart
import 'package:shake/shake.dart';

class ShakeDetector extends StatefulWidget {
  final VoidCallback onShake;
  
  @override
  _ShakeDetectorState createState() => _ShakeDetectorState();
}

class _ShakeDetectorState extends State<ShakeDetector> {
  late ShakeDetector detector;
  
  @override
  void initState() {
    super.initState();
    detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        widget.onShake();
        // 진동 + 사운드 재생
        HapticFeedback.mediumImpact();
        // AudioPlayer 사용 (audioplayers 패키지)
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
```

- [ ] 흔들기 감지 구현 완료
- [ ] 진동/사운드 연동 완료

### P3-4. 대기 애니메이션 (Lottie)
`lib/widgets/waiting_overlay.dart`:
- [ ] Lottie 파일 준비:
  - 무료 Lottie: https://lottiefiles.com (우주/별/나선 검색)
  - 또는 직접 생성 (After Effects → Lottie)
  - 파일 크기: 100KB 이하
- [ ] `assets/animations/waiting.json` 에 저장
- [ ] 오버레이 UI:
  - 전체 화면 다크 배경 (80% opacity)
  - 중앙 Lottie 애니메이션 (2초 재생)
  - 재생 완료 후 답변 카드 표시

### P3-5. 답변 카드
`lib/screens/result_screen.dart`:
- [ ] 모달 팝업 또는 전체 화면
- [ ] 메인 답변 텍스트 (20~32pt, 볼드)
- [ ] 보조 텍스트 (14~16pt, 회색)
- [ ] 액션 버튼:
  - "다시 뽑기" → 홈으로 돌아가서 재실행
  - "저장" → Hive에 저장 (최대 50개, FIFO)
  - "공유" → share_plus 사용
- [ ] 하단 면책 문구 (9pt, 회색)
- [ ] Fade In + Scale Up 애니메이션 (0.3초)

---

## Phase 4: 저장 & 설정 (10~14h)

### P4-1. 저장 목록 화면
`lib/screens/saved_screen.dart`:
- [ ] ListView: 저장 시간 역순 정렬
- [ ] 항목 탭 → 상세 팝업 (답변 + 질문)
- [ ] 스와이프 삭제 또는 삭제 버튼
- [ ] 전체 삭제 버튼 (확인 다이얼로그)
- [ ] 배너 광고 (하단, 광고 제거 미구매 시)
- [ ] 빈 상태: "아직 저장한 답변이 없어요"

### P4-2. 설정 화면
`lib/screens/settings_screen.dart`:
- [ ] 진동 On/Off (SwitchListTile)
- [ ] 흔들기 On/Off (SwitchListTile)
- [ ] 사운드 On/Off (SwitchListTile)
- [ ] 언어 선택 (DropdownButton: KO/EN)
- [ ] 광고 제거 구매 버튼 (ListTile)
- [ ] 구매 복원 버튼 (ListTile, iOS 필수)
- [ ] 주의 문구 (ExpansionTile)
- [ ] 라이선스 고지 (ListTile → showLicensePage)
- [ ] 버전 정보 (ListTile)

### P4-3. 다국어 설정
- [ ] `lib/l10n/app_ko.arb` 작성 (한국어)
- [ ] `lib/l10n/app_en.arb` 작성 (영어)
- [ ] `flutter gen-l10n` 실행 → `lib/l10n/` 에 생성된 파일 확인
- [ ] `main.dart` 에 localization 설정:
  ```dart
  MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    // ...
  )
  ```

---

## Phase 5: 광고 & IAP (14~18h)

### P5-1. AdMob 연동
`lib/services/ads_service.dart`:
- [ ] 배너 광고:
  - 테스트 ID: `ca-app-pub-3940256099942544/6300978111` (Android)
  - 테스트 ID: `ca-app-pub-3940256099942544/2934735716` (iOS)
  - 저장 화면 하단에 표시
- [ ] 전면 광고:
  - 테스트 ID: `ca-app-pub-3940256099942544/1033173712` (Android)
  - 테스트 ID: `ca-app-pub-3940256099942544/4411468910` (iOS)
  - "다시 뽑기" 5회마다 1회 표시 (최소 60초 간격)
  - 첫 실행 후 첫 답변 및 첫 2~3회는 표시 안 함
- [ ] 광고 로딩 실패 시 사용자 경험 유지 (광고 없이 진행)

### P5-2. IAP 연동 (광고 제거)
`lib/services/iap_service.dart`:
- [ ] 상품 ID: `remove_ads_forever_4990` (iOS/Android 동일)
- [ ] 상품 유형: 비소모성 (Non-Consumable)
- [ ] 테스트 방법:
  - iOS: Sandbox 계정으로 테스트 (App Store Connect)
  - Android: 테스트 계정 추가 (Google Play Console)
- [ ] 구매 로직:
  ```dart
  Future<bool> purchaseAdRemoval() async {
    final available = await InAppPurchase.instance.isAvailable();
    if (!available) return false;
    
    final response = await InAppPurchase.instance.queryProductDetails({'remove_ads_forever_4990'});
    final product = response.productDetails.first;
    
    final purchaseParam = PurchaseParam(productDetails: product);
    return await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
  }
  ```
- [ ] 구매 성공 시 `isAdFree = true` 로컬 저장
- [ ] 구매 복원 로직 (iOS 필수):
  ```dart
  Future<void> restorePurchases() async {
    await InAppPurchase.instance.restorePurchases();
  }
  ```
- [ ] 광고 표시 로직 연동: `isAdFree == true` 이면 광고 스킵

---

## Phase 6: 마무리 & 테스트 (20~24h)

### P6-1. 예외 처리
- [ ] 답변 데이터 로딩 실패 → Fallback 답변 20개 사용
- [ ] 흔들기 실패 → "답변 받기" 버튼 정상 동작 확인
- [ ] 애니메이션 로딩 실패 → 프로그레스 바 표시
- [ ] 광고 로딩 실패 → 사용자 경험 유지
- [ ] 저장 실패 → 토스트 메시지
- [ ] IAP 실패 → 에러 메시지

### P6-2. 기능 테스트
- [ ] 흔들기 감지 정상 동작 (실기기 테스트 필수)
- [ ] "답변 받기" 버튼 동작
- [ ] 2초 대기 애니메이션 재생
- [ ] 답변 카드 표시 및 애니메이션
- [ ] 저장 기능 (최대 50개, FIFO 확인)
- [ ] 공유 기능 (카카오톡, 문자, 이메일 등)
- [ ] 설정 변경 (진동/흔들기/사운드/언어)
- [ ] 광고 표시 (배너/전면)
- [ ] IAP 구매 및 복원 (테스트 계정)
- [ ] 광고 제거 구매 후 광고 비노출 확인

### P6-3. 정책 준수
- [ ] 답변 카드 하단 면책 문구 표시 확인
- [ ] 설정 화면 주의 문구 표시 확인
- [ ] "운세", "점", "예언" 단어 전체 검색 → 미사용 확인
- [ ] iOS: Info.plist 권한 사유 명시 확인
- [ ] Android: 광고 ID 권한 명시 확인

### P6-4. 성능 확인
- [ ] 앱 실행 시간: 2초 이내 확인
- [ ] 애니메이션 프레임레이트: 60fps 확인 (DevTools)
- [ ] 저장 목록 로딩: 0.5초 이내 확인
- [ ] 메모리 사용량: 정상 범위 확인 (100~200MB)
- [ ] 오프라인 동작: 비행기 모드에서 테스트
- [ ] 크래시 없음: 30분 사용 테스트

### P6-5. 빌드 & 스토어 준비
- [ ] iOS 빌드:
  - Xcode에서 Archive 생성
  - TestFlight 업로드 (심사 전 테스트)
  - 스크린샷 준비 (6.5", 5.5", iPad Pro)
- [ ] Android 빌드:
  - APK/AAB 생성: `flutter build appbundle --release`
  - Google Play Console 업로드 (Internal Testing)
  - 스크린샷 준비 (Phone, 7", 10")
- [ ] 스토어 설명 작성:
  - 앱 이름: "마법의 고민해결책"
  - 부제목: "폰 흔들기로 랜덤 답변 받기" (iOS)
  - 짧은 설명: "일상의 고민에 힌트를 주는 엔터테인먼트 앱" (Android)
  - 자세한 설명: 명세서 10-2 참고
  - 카테고리: Entertainment / Lifestyle
  - 키워드: "고민", "답변", "힌트", "엔터테인먼트", "오락"
- [ ] 개인정보처리방침 URL (필수):
  - GitHub Pages 또는 Notion 페이지 생성
  - 내용: 광고 ID 수집, 로컬 저장 데이터, 제3자 제공 없음 등
- [ ] 지원 URL (선택):
  - 이메일 또는 웹사이트

---

## 우선순위 요약

### 🔴 P0 (필수, MVP 핵심)
1. 프로젝트 초기화 + 패키지 설치 (P1-1~P1-4)
2. 답변 데이터 모델 + JSON (P2-1~P2-2)
3. 답변 서비스 + Fallback (P2-3)
4. 홈 화면 + 흔들기 감지 (P3-2~P3-3)
5. 대기 애니메이션 (P3-4)
6. 답변 카드 (P3-5)
7. 저장 기능 (P2-4, P4-1)
8. 설정 화면 기본 (P4-2)

### 🟡 P1 (중요, MVP 완성도)
1. 인트로 화면 (P3-1)
2. 공유 기능 (P3-5)
3. 광고 연동 (P5-1)
4. IAP 연동 (P5-2)
5. 다국어 지원 (P4-3)

### 🟢 P2 (선택, 출시 후 추가 가능)
1. 로그인 기능 (FR-09) — MVP에서는 제외 권장
2. 클라우드 동기화 (FR-09) — MVP에서는 제외 권장
3. 이미지 공유 (FR-07 확장) — v1.1 이후
4. 카테고리별 필터링 — v1.2 이후

---

## 시간 배분 권장 (24시간 기준)

| 시간대 | 작업 | 중요도 |
|--------|------|--------|
| 0~2h | Phase 1: 프로젝트 초기화 | 🔴 P0 |
| 2~4h | Phase 2: 데이터 레이어 | 🔴 P0 |
| 4~6h | Phase 3-1: 홈 화면 + 흔들기 | 🔴 P0 |
| 6~8h | Phase 3-2: 대기 애니메이션 | 🔴 P0 |
| 8~10h | Phase 3-3: 답변 카드 + 저장/공유 | 🔴 P0 |
| 10~12h | Phase 4-1: 저장 목록 화면 | 🔴 P0 |
| 12~14h | Phase 4-2: 설정 화면 + i18n | 🔴 P0 |
| 14~16h | Phase 5-1: 광고 연동 | 🟡 P1 |
| 16~18h | Phase 5-2: IAP 연동 | 🟡 P1 |
| 18~20h | Phase 3-1: 인트로 화면 | 🟡 P1 |
| 20~22h | Phase 6-1~6-3: 예외 처리 + 테스트 | 🔴 P0 |
| 22~24h | Phase 6-4~6-5: 빌드 + 스토어 준비 | 🔴 P0 |

---

## 주의사항 & 팁

### ⚠️ 시간 절약 팁
1. **Lottie 애니메이션**: 무료 리소스 활용 (직접 제작 X)
   - https://lottiefiles.com
   - 검색어: "galaxy", "space", "stars", "spiral"
2. **효과음**: 무료 리소스 활용
   - https://freesound.org
   - 검색어: "bell", "chime", "ding"
3. **광고**: 테스트 ID 사용 (출시 후 실제 ID로 교체)
4. **IAP**: 테스트 계정으로 충분히 테스트 (실제 결제 X)
5. **다국어**: MVP는 KO/EN만 구현 (JA/ZH는 v1.1 이후)

### ⚠️ 실기기 테스트 필수
- 흔들기 감지는 에뮬레이터에서 테스트 불가
- 최소 1대 이상의 실기기에서 테스트 필요
- iOS/Android 각 1대씩 권장

### ⚠️ 심사 거절 방지
- "운세", "점", "예언" 단어 사용 금지
- 면책 문구 필수 포함
- iOS: Sign in with Apple (로그인 제공 시)
- iOS: Info.plist 권한 사유 명시
- Android: 광고 ID 권한 명시

---

작성일: 2026-02-11  
작성자: PM+Tech Lead (Claude)
