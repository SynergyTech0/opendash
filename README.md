<div align="center">

# OpenDash

**An open-source car head-unit UI that treats the driver like a person, not a spec sheet.**

Clean, big-touch, two taps deep — and yes, it finally has a *delete button*.
Built in the languages real car stereos actually run.

</div>

---

## Why more than one build

Modern car stereos have incredible hardware bolted to software UX that looks like
it "compiled, so ship it." OpenDash is the opposite: a touch-first head-unit
interface designed like someone has to use it while driving.

But a good design is only half the point — it has to be buildable in the stacks
real head units ship in. A single HTML file only represents Tesla's web UI and
aftermarket browser wrappers. So OpenDash ships the **same UI implemented in the
languages the industry actually uses**:

| Build | Language | Where this stack ships | Status |
|---|---|---|---|
| **[`qt/`](qt/)** | **C++ + QML** (Qt Quick) | OpenAuto/Crankshaft (Pi dashes), most QNX & Automotive-Grade-Linux OEM head units | ✅ QML renders + lints clean; C++ reviewed |
| **[`android/`](android/)** | **Kotlin + Jetpack Compose** | Android Automotive OS — Volvo, Polestar, GM, Ford, Honda, Renault | ✅ Builds a debug APK (`gradle assembleDebug`) |
| **[`flutter/`](flutter/)** | **Dart** (Flutter) | Toyota 2026 RAV4 IVI, BMW apps, Automotive Grade Linux; runs on a Pi via flutter-elinux | 📝 Written & reviewed; not compiled in-session (Flutter SDK didn't bootstrap on the build box) — run `flutter analyze` |
| **[`preview/`](preview/index.html)** | HTML/CSS/JS | Tesla's touchscreen UI; aftermarket web wrappers | ✅ Runs in any browser (the shared visual spec) |

Every build shares one design, one palette, one set of behaviours — the web
`preview/` is the reference, and the three native stacks implement it.

## Screenshots

From the Qt build, rendered by the real Qt Quick scene graph:

| Now Playing | Media | Climate | Day mode |
|---|---|---|---|
| ![](qt/screenshots/now-playing.png) | ![](qt/screenshots/media.png) | ![](qt/screenshots/climate.png) | ![](qt/screenshots/now-playing-day.png) |

## The design (shared by every build)

- **Now Playing** — album art, large transport, scrubbable progress, volume,
  source switching (USB / Bluetooth / Radio), and a prominent **Delete** button.
- **Media** — the USB library as a flat, scannable list; tap to play, one tap to
  delete, live "now playing" equalizer.
- **Climate** — dual-zone temperature, 6-speed fan, A/C · Auto · Recirculate ·
  front/rear defrost, and 3-stage seat heaters.
- **Phone** — Bluetooth call surface (placeholder).
- **Settings** — Night/Day instrument themes, brightness, °F/°C.
- Live clock, simulated playback, and a single "instrument at night" visual world
  (amber-on-charcoal) with an in-app Day mode.

## Design principles

1. **Two taps, max.** Anything you need while moving is one or two touches away.
2. **One accent.** Amber instrument lighting carries state; semantic colors are separate.
3. **Big targets, high contrast.** Legible at a glance, at speed, in daylight.
4. **Reversible by default.** Nothing destructive without an undo path — starting with the delete button.
5. **Yours.** No account, no cloud, no data leaving the car.

## Build & run

Each stack has its own README with build instructions:

- **Qt** — `cd qt && cmake -S . -B build && cmake --build build` ([details](qt/README.md))
- **Android** — open `android/` in Android Studio, or `./gradlew assembleDebug` ([details](android/README.md))
- **Flutter** — `cd flutter && flutter create --platforms=android,linux,web . && flutter run` ([details](flutter/README.md))
- **Web** — open `preview/index.html`, or `python3 -m http.server` in `preview/`

### On a real head unit

- **Raspberry Pi double-DIN** — the Qt build (like OpenAuto/Crankshaft) or the
  Flutter build via flutter-elinux, fullscreen on EGLFS / Wayland.
- **Android head units / AAOS** — the Android build, or the Flutter build.
- **Any Linux dash with a browser** — the web `preview/` in Chromium kiosk mode.

## Roadmap

- [ ] Real audio backend (USB/MTP indexing, gapless playback)
- [ ] Undo/restore for deletes (trash with a timeout)
- [ ] CAN-bus bridge for real climate + vehicle data
- [ ] Reverse-camera and CarPlay/Android Auto handoff
- [ ] Voice ("skip", "delete this", "72 degrees")
- [ ] Theming API + community skins

## Contributing

PRs welcome — see [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE) © 2026 Shane Sipe. Do what you like — just don't design a UI an engineer would.
