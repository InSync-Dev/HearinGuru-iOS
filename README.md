# HearinGuru iOS

SwiftUI iOS app — hearing health toolkit. Mirrors the Android app feature-for-feature.

## Screens

| Screen | Description |
|--------|-------------|
| Tools | Carousel + tool tiles (entry point) |
| Hearing Test | 5-minute tone audiometry test |
| Sound Amplifier | Real-time mic → speaker amplification |
| Noise Meter | Live dB SPL measurement via microphone |
| Tinnitus Relief | White / pink / ocean / rain background sounds |
| Learn | Article library (8 articles, search + filter) |
| Article Detail | Full readable article content |
| Hearing Aids | Types, prices, brands, FAQs |
| Doctor | Call / WhatsApp CTA + callback form |
| Notifications | Notification list |
| Profile | Toggles, settings, app info |

## Requirements

- Xcode 15+
- iOS 16+ deployment target
- No third-party dependencies — pure SwiftUI + AVFoundation

## Xcode Project Setup

1. Open Xcode → **File → New → Project**
2. Choose **App** template, iOS
3. Set:
   - **Product Name**: `HearinGuru`
   - **Bundle ID**: `com.hearinguru.app` (or your own)
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Minimum Deployment**: iOS 16.0

4. Delete the generated `ContentView.swift`

5. **Add all source files**: drag the `HearinGuru/` folder contents into the Xcode project navigator. Make sure **"Copy items if needed"** is checked and **"Add to target: HearinGuru"** is selected.

6. **Replace Info.plist**: merge the keys from `HearinGuru/Info.plist` into your project's Info.plist (or replace it entirely). The critical keys are:
   - `NSMicrophoneUsageDescription`
   - `UIBackgroundModes: [audio]`

7. **Enable capabilities** in the target's Signing & Capabilities tab:
   - Add **"Background Modes"** → check **"Audio, AirPlay, and Picture in Picture"**

8. **Set accent colour**: in `Assets.xcassets`, set the `AccentColor` to `#1C70D9` (or your preferred blue) so the tab bar and system controls match the app theme.

9. **Build and run** on the simulator or a connected device.

## Architecture

```
HearinGuru/
├── App/
│   ├── HearinGuruApp.swift       — @main, injects environment objects
│   └── MainTabView.swift         — TabView with 4 tabs + toolbar
├── Theme/
│   └── AppTheme.swift            — Color constants, ScaleButtonStyle, helpers
├── Services/
│   ├── AudioService.swift        — Tinnitus background audio (AVAudioEngine, noise gen)
│   ├── AmplifierService.swift    — Real-time mic amplifier (AVAudioEngine)
│   └── NoiseMeterService.swift   — dB SPL meter (AVAudioEngine tap)
├── Models/
│   └── ArticleContent.swift      — Article data for all 8 Learn articles
└── Screens/
    ├── Tools/           ToolsView
    ├── HearingTest/     HearingTestView · TestActiveView · TestResultView
    ├── SoundAmplifier/  SoundAmplifierView
    ├── NoiseMeter/      NoiseMeterView
    ├── Tinnitus/        TinnitusView
    ├── Learn/           LearnView · ArticleDetailView
    ├── HearingAids/     HearingAidsView
    ├── Doctor/          DoctorView
    ├── Notifications/   NotificationsView
    └── Profile/         ProfileView
```

## Services — shared via @EnvironmentObject

All three services are created once in `HearinGuruApp` and injected as environment objects:

```swift
@StateObject private var audioService      = AudioService()       // tinnitus
@StateObject private var amplifierService  = AmplifierService()   // amplifier
@StateObject private var noiseMeterService = NoiseMeterService()  // noise meter
```

Screens that need them declare:
```swift
@EnvironmentObject private var service: AudioService
```

## Notes

- **Hearing test**: Generates pure tones via `AVAudioSourceNode`. Uses adaptive logic — if no response in 3 seconds, records as "not heard".
- **Tinnitus audio**: White noise is pure random samples; pink noise uses the Voss-McCartney algorithm; ocean waves and rainfall are amplitude-modulated pink noise. All generated in real time — no audio files needed.
- **Amplifier**: Connects `inputNode` → `AVAudioMixerNode` → `outputNode` with configurable gain. Use wired headphones to avoid feedback.
- **Noise meter**: Reads SPL via mic tap, applies `+94 dB` offset to convert from FS dBFS to approximate dB SPL.
