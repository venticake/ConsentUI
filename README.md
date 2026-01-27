# ConsentUI

iOS/Android 모바일 앱용 유저 동의 UI 라이브러리. EEA 지역에서 ADID/IDFA 접근 전 동의를 받는 시스템 스타일 팝업을 제공합니다.

## Features

- EEA 지역 자동 감지
- 시스템 기본 Alert/Dialog 스타일 UI
- iOS: UIKit + SwiftUI 지원, ATT (App Tracking Transparency) 연계
- Android: View + Jetpack Compose 지원
- 다국어 지원 (영어, 한국어, 독일어, 프랑스어, 스페인어, 이탈리아어, 일본어, 중국어, 포르투갈어, 네덜란드어, 폴란드어, 스웨덴어)

## Installation

### iOS (Swift Package Manager)

`Package.swift`:
```swift
dependencies: [
    .package(url: "https://github.com/user/ConsentUI.git", from: "1.0.0")
]
```

또는 Xcode에서:
1. File > Add Packages...
2. URL 입력: `https://github.com/user/ConsentUI`

### Android (JitPack)

`settings.gradle.kts`:
```kotlin
dependencyResolutionManagement {
    repositories {
        maven { url = uri("https://jitpack.io") }
    }
}
```

`build.gradle.kts`:
```kotlin
dependencies {
    implementation("com.github.user:ConsentUI:1.0.0")
}
```

## Usage

### iOS - UIKit

```swift
import ConsentUI

class ViewController: UIViewController {

    func showConsent() {
        // 항상 동의 팝업 표시
        ConsentManager.shared.requestConsent(from: self) { result in
            switch result {
            case .accepted(let attStatus):
                print("Accepted, ATT: \(String(describing: attStatus))")
            case .declined:
                print("Declined")
            case .notRequired:
                print("Not in EEA")
            }
        }
    }

    func showConsentIfNeeded() {
        // EEA 지역인 경우에만 동의 팝업 표시
        ConsentManager.shared.requestConsentIfNeeded(from: self) { result in
            // handle result
        }
    }
}
```

### iOS - SwiftUI

```swift
import SwiftUI
import ConsentUI

struct ContentView: View {
    @StateObject private var consentState = ConsentState()

    var body: some View {
        Button("Request Consent") {
            consentState.show()
        }
        .consentAlert(isPresented: $consentState.isPresented) { result in
            // handle result
        }
    }
}
```

### Android - Activity

```kotlin
import com.consentui.ConsentManager
import com.consentui.ConsentResult

class MainActivity : AppCompatActivity() {

    fun showConsent() {
        // 항상 동의 다이얼로그 표시
        ConsentManager.requestConsent(this) { result ->
            when (result) {
                is ConsentResult.Accepted -> println("Accepted")
                is ConsentResult.Declined -> println("Declined")
                is ConsentResult.NotRequired -> println("Not in EEA")
            }
        }
    }

    fun showConsentIfNeeded() {
        // EEA 지역인 경우에만 동의 다이얼로그 표시
        ConsentManager.requestConsentIfNeeded(this) { result ->
            // handle result
        }
    }
}
```

### Android - Jetpack Compose

```kotlin
import com.consentui.ConsentDialog
import com.consentui.ConsentResult
import com.consentui.rememberConsentState

@Composable
fun ConsentScreen() {
    val consentState = rememberConsentState()

    Button(onClick = { consentState.show() }) {
        Text("Request Consent")
    }

    ConsentDialog(state = consentState) { result ->
        when (result) {
            is ConsentResult.Accepted -> { /* handle */ }
            is ConsentResult.Declined -> { /* handle */ }
            is ConsentResult.NotRequired -> { /* handle */ }
        }
    }
}
```

## API Reference

### iOS

#### ConsentManager

| Method | Description |
|--------|-------------|
| `requestConsent(from:completion:)` | 동의 팝업 표시 (항상) |
| `requestConsentIfNeeded(from:completion:)` | EEA 지역인 경우에만 동의 팝업 표시 |
| `isConsentRequired()` | EEA 지역 여부 확인 |
| `currentATTStatus()` | 현재 ATT 상태 반환 |

#### ConsentResult

| Case | Description |
|------|-------------|
| `.accepted(attStatus:)` | 동의함 (ATT 상태 포함) |
| `.declined` | 동의 거부 |
| `.notRequired` | EEA 지역 아님 |

#### SwiftUI

| API | Description |
|-----|-------------|
| `ConsentState` | 동의 상태 관리 ObservableObject |
| `consentAlert(isPresented:onResult:)` | View modifier |

### Android

#### ConsentManager

| Method | Description |
|--------|-------------|
| `requestConsent(activity, callback)` | 동의 다이얼로그 표시 (항상) |
| `requestConsent(fragment, callback)` | Fragment에서 동의 다이얼로그 표시 |
| `requestConsentIfNeeded(activity, callback)` | EEA 지역인 경우에만 표시 |
| `isConsentRequired()` | EEA 지역 여부 확인 |

#### ConsentResult

| Type | Description |
|------|-------------|
| `ConsentResult.Accepted` | 동의함 |
| `ConsentResult.Declined` | 동의 거부 |
| `ConsentResult.NotRequired` | EEA 지역 아님 |

#### Compose

| API | Description |
|-----|-------------|
| `rememberConsentState()` | ConsentState 생성 |
| `ConsentDialog(state, onResult)` | 동의 다이얼로그 Composable |

## EEA Countries

동의가 필요한 지역 (31개국):

**EU (27):** AT, BE, BG, HR, CY, CZ, DK, EE, FI, FR, DE, GR, HU, IE, IT, LV, LT, LU, MT, NL, PL, PT, RO, SK, SI, ES, SE

**EFTA (3):** IS, LI, NO

**UK (1):** GB

## iOS ATT Integration

iOS 14+에서 동의 후 자동으로 ATT (App Tracking Transparency) 권한을 요청합니다.

`Info.plist`에 추가 필요:
```xml
<key>NSUserTrackingUsageDescription</key>
<string>We use this identifier to personalize ads and measure their effectiveness.</string>
```

## Customization

### 텍스트 커스터마이징

마스터 텍스트 파일 수정 후 빌드 스크립트 실행:

```bash
python3 scripts/generate_resources.py
```

`resources/consent_strings.json`:
```json
{
  "en": {
    "title": "Help Improve Your Experience",
    "message": "We'd like to use your device identifier...",
    "allow": "Allow",
    "decline": "Not Now"
  }
}
```

## License

MIT License
