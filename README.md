# Geumpumta – Frontend

공학 계열 대학생을 위한 **집중 학습 시간 검증 및 랭킹 서비스**  
Flutter 기반 모바일 앱으로 **SSID 기반 학습 검증**, **실시간 시간 기록**, **랭킹 기능**을 제공합니다.

---

## 1. 프로젝트 개요

| 항목 | 내용 |
|---|---|
| 프로젝트명 | **Geumpumta** |
| 대상 | 공학 계열 대학생 |
| 목적 | 실제 학습 시간의 정확한 측정 및 비교 |
| 핵심 가치 | 부정 방지 · 공정한 랭킹 · 실시간 동기화 |
| 인증 방식 | Wi-Fi SSID 기반 학습 인증 |
| 시간 기록 | Timer + Heartbeat 기반 서버 동기화 |

---

## 2. Tech Stack

### Frontend

| Flutter | State | Architecture | Network | Storage |
|---|---|---|---|---|
| Flutter 3.35.3 | Riverpod | MVVM | Dio + Retrofit | SharedPreferences |

### Development / Tooling

| Version Control | IDE | Platform |
|---|---|---|
| Git / GitHub | Android Studio / Xcode | iOS / Android |

---

## 3. 프로젝트 구조

```text
lib/
 ├── main.dart
 ├── models/
 ├── provider/
 ├── repository/
 ├── routes/
 ├── screens/
 ├── services/
 ├── viewmodel/
 └── widgets/
```

---

## 4. 주요 기능

### 🔐 인증 / 로그인
- OAuth 로그인 (Kakao / Google / Apple)
- Access / Refresh Token 관리
- 중복 로그인 방지

### ⏱ 학습 타이머 & Heartbeat
- 서버 기반 학습 세션 관리
- 주기적 Heartbeat 전송
- 앱 재실행 시 시간 유지

### 📶 Wi-Fi 기반 학습 인증
- SSID/BSSID 검증
- 지정된 네트워크에서만 학습 허용

### 🏆 랭킹 & 통계
- 개인 / 학과 / 전체 랭킹
- 일간 / 주간 / 월간 통계

---

## 5. 시스템 아키텍처

<p align="center">
  <img src="https://github.com/user-attachments/assets/7dadbbd9-430b-4703-b6a0-453365a58a98"
       alt="Geumpumta System Architecture"
       width="600"/>
</p>

<p align="center">
  <em>Frontend–Backend 간 학습 세션 관리 및 랭킹 처리 아키텍처</em>
</p>

---

## 6. 시연 영상

- Demo Video: https://youtube.com/shorts/FN-SAg3qcQg

---

## 7. 스크린샷

### 인증 / 로그인

| 로그인 | 학과 선택 | 이메일 인증 | 약관 동의 |
|---|---|---|---|
| <img src="./doc/images/login.png" width="160"/> | <img src="./doc/images/select_department.png" width="160"/> | <img src="./doc/images/verify_school_email.png" width="160"/> | <img src="./doc/images/personal_information_consent.png" width="160"/> |

### 메인 / 타이머

| 메인 타이머 | 타이머 실행 | Wi-Fi 에러 | 종료 경고 |
|---|---|---|---|
| <img src="./doc/images/main_timer.png" width="160"/> | <img src="./doc/images/timer2.png" width="160"/> | <img src="./doc/images/main_timer_school_wifi_error.png" width="160"/> | <img src="./doc/images/timer_error_exit_app.png" width="160"/> |

### 랭킹

| 일간 | 주간 | 월간 | 개인 |
|---|---|---|---|
| <img src="./doc/images/ranking_daily_department.png" width="160"/> | <img src="./doc/images/ranking_weekly_department.png" width="160"/> | <img src="./doc/images/ranking_monthly_department.png" width="160"/> | <img src="./doc/images/ranking_personal.png" width="160"/> |

### 통계

| 일간 | 주간 | 월간 | 상세 그래프 |
|---|---|---|---|
| <img src="./doc/images/stats_daily.png" width="160"/> | <img src="./doc/images/stats_weekly.png" width="160"/> | <img src="./doc/images/stats_monthly.png" width="160"/> | <img src="./doc/images/stats_daily_graph.png" width="160"/> |

---

## 8. 팀 구성

| 역할 | 담당 |
|---|---|
| Frontend (메인, 랭킹) | 이민우 |
| Frontend (통계, 더보기) | 허광민 |

---

## 9. 향후 업데이트

- GPS / Beacon 인증
- 주간 목표 기능
- 디자인 시스템 개선
- Firebase Analytics / Crashlytics
****
