# Store Submission Readiness (v0.1.2)

## 1) 스토어 설명 초안 (정책 문구 반영)

### App Store / Google Play 공통 설명 초안 (KO)
마법의 고민해결책은 일상의 작은 고민에 힌트를 주는 **엔터테인먼트 앱**입니다.  
질문을 떠올린 뒤 휴대폰을 흔들거나 버튼을 눌러 랜덤 답변을 받아보세요.

- 흔들기 또는 버튼으로 즉시 답변 받기
- 답변 저장/공유 기능
- 오프라인에서도 기본 기능 사용 가능
- 광고 제거 1회 구매(영구) 지원

면책 안내:
- 본 앱의 답변은 **오락/참고용**입니다.
- 의료·법률·투자 등 전문적 판단을 대체하지 않습니다.
- 중요한 결정은 반드시 전문가 상담을 권장합니다.

금지어 체크:
- 설명/UI에서 “운세”, “점”, “예언”, “미래 예측” 표현 미사용
- “엔터테인먼트”, “참고”, “오락”, “랜덤 답변” 중심 표현 사용

---

## 2) App Privacy / Data safety 작성안

아래는 **광고 SDK + IAP 사용** 기준 제출안입니다.

### 2-A. App Store Connect — App Privacy
- Data Used to Track You
  - Identifiers (광고 ID/기기 식별자) — Third-Party Advertising (AdMob 사용 시)
- Data Linked to You
  - Purchases (인앱 구매 내역)
- Data Not Linked to You
  - Diagnostics (SDK 설정에 따라 수집 시)
- Tracking
  - AdMob 개인화 광고/추적 사용 시 ATT 및 Tracking 응답 필요
  - 비개인화 광고만 사용해도 식별자 처리 여부를 SDK 실제 동작 기준으로 점검

### 2-B. Google Play Console — Data safety
- 데이터 수집/공유: **예 (광고 SDK 사용 시)**
- 수집 가능 데이터 항목
  - Device or other IDs (Advertising ID)
  - App activity (광고 상호작용/진단 로그: SDK 설정 시)
  - Financial info / Purchase history (IAP 검증 목적 범위)
- 데이터 처리 목적
  - 광고/마케팅
  - 앱 기능(결제 처리)
  - 분석/진단(사용 시)
- 보안
  - 전송 중 암호화(예)
  - 데이터 삭제 요청: 계정 기반 데이터가 없으면 “해당 없음”으로 고지 가능

> 주의: 현재 코드베이스는 Ads/IAP가 stub 상태이므로, 실제 SDK 연동 전에는 “미수집”로 보일 수 있습니다. **릴리즈 빌드에서 SDK가 활성화되면 반드시 위 항목으로 갱신**해야 합니다.

---

## 3) `lib/l10n/*.arb` 면책/개인정보 문구 검수 결과 (4개 언어)

검수 대상 키:
- `disclaimer`
- `cautionText`
- `privacyPolicyText`
- `termsOfServiceText`

검수 결과:
- KO/EN/JA/ZH 모두
  - 엔터테인먼트/참고용 목적 명시
  - 의료·법률·투자 관련 전문 조언 대체 불가 명시
  - 사용자 책임 범위 명시
  - 광고 SDK 식별자 처리 가능성 및 IAP 결제 검증 처리 가능성 반영
- 결론: 4개 언어 모두 동일한 정책 의미로 정렬 완료

---

## 4) 설정 화면 문구 vs 스토어 제출 문구 충돌 점검

점검 파일: `magic_answer_book/lib/screens/settings_screen.dart` + 각 ARB 문구

- 개인정보/이용약관/주의 문구가 모두 ARB 기반으로 노출되므로 다국어 동기화 가능
- 스토어 설명의 핵심 면책(엔터테인먼트, 전문 조언 대체 불가, 전문가 상담 권장)과 설정 화면 문구 일치
- “예언 보장” 표현은 부정형(보장하지 않음)으로만 사용되어 금지어 정책 충돌 없음

판정: 현재 문구 기준 충돌 없음

---

## 5) 개인정보처리방침 URL 등록

실제 콘솔 등록용 URL은 **외부에서 접근 가능한 HTTPS 페이지**여야 합니다.

권장 등록 URL(배포 후):
- `https://<your-domain>/privacy-policy`

실행 체크리스트:
1. 개인정보처리방침 웹페이지 배포(정적 페이지 가능)
2. App Store Connect의 Privacy Policy URL에 동일 URL 입력
3. Play Console 앱 정보 > 개인정보처리방침에 동일 URL 입력
4. 앱 내 설정 화면 문구와 URL의 내용 일치 여부 재검수

