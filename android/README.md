# OpenDash — Android (Automotive OS) build

OpenDash as a native **Android Automotive OS** app in **Kotlin + Jetpack
Compose** — the stack Volvo, Polestar, GM, Ford, Honda and Renault ship in their
head units. Modern, declarative, ViewModel-driven.

## Architecture

```
android/
├── app/src/main/
│   ├── AndroidManifest.xml         # automotive uses-feature + launcher
│   ├── res/…                        # theme shell, adaptive launcher icon
│   └── java/cloud/synergytech/opendash/
│       ├── MainActivity.kt          # setContent { OpenDashTheme { OpenDashApp() } }
│       ├── model/DashViewModel.kt   # all state + behaviour; 1 Hz tick + clock
│       ├── ui/OpenDashApp.kt        # status bar + content router + nav rail + toast
│       ├── ui/theme/                # DashColors tokens, night/day via CompositionLocal
│       ├── ui/components/           # AlbumArt (radial brush), ViewHeading, richText
│       └── ui/screens/              # NowPlaying / Media / Climate / Phone / Settings
└── build.gradle.kts, libs.versions.toml, …
```

State lives in one `DashViewModel` (Compose snapshot state); the UI is a pure
function of it. The **delete button** calls `tracks.removeAt(i)` on an observable
`SnapshotStateList`, so the list recomposes; playback position advances on a
`viewModelScope` coroutine. Night/Day flips the whole palette through
`LocalDash` (a `CompositionLocal<DashColors>`), no per-widget theming.

## Build & run

Open the `android/` folder in Android Studio and run, **or** from the CLI:

```bash
cd android
./gradlew assembleDebug         # or installDebug with a device/emulator attached
```

Needs the Android SDK (compileSdk 35), JDK 17+, and an internet connection for
the first dependency sync. `minSdk = 29` (the Android Automotive OS floor).

### On a head unit / emulator

- **Android Automotive OS emulator** (Automotive system image in Android Studio)
  is the closest target. The `automotive` `uses-feature` is `required="false"`,
  so the app also installs on a normal phone/tablet for quick UI iteration.
- Real AAOS units install the same APK; flip the feature to `required="true"`
  for an automotive-only release.

## Fonts

Falls back to the platform sans. To match the web preview exactly, add
`res/font/chakra_petch.ttf` and `res/font/barlow.ttf` and point `DisplayFamily`
/ `BodyFamily` in `ui/theme/Type.kt` at them.

## Build-verification status

See the top-level README for the current compile status of this module.
