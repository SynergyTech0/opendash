# OpenDash — Flutter build

OpenDash in **Flutter / Dart** — the stack Toyota ships in the 2026 RAV4's
infotainment system and that Automotive Grade Linux has adopted. One codebase
runs on an **Android head unit**, an **embedded-Linux Pi dash** (via
`flutter-elinux` / Toyota's `ivi-homescreen` embedder), and desktop/web for
development.

## Architecture

```
flutter/
├── pubspec.yaml            # no third-party packages — plain ChangeNotifier
└── lib/
    ├── main.dart           # landscape, immersive, runApp(OpenDashApp)
    ├── app.dart            # shell: status bar + content + nav rail + toast
    ├── models.dart         # DashModel (ChangeNotifier) + DashScope + 1 Hz timer
    ├── theme.dart          # DashColors tokens, night/day, text helpers
    ├── widgets.dart        # AlbumArt (RadialGradient), ViewHeading, richSpan
    └── screens/            # now_playing / media / climate / phone / settings
```

State lives in one `DashModel extends ChangeNotifier`; the UI rebuilds from it
via an `AnimatedBuilder` at the root and reads it through a `DashScope`
`InheritedNotifier`. The **delete button** calls `tracks.removeAt(i)` on the
real list; playback position advances on a `Timer.periodic`. Night/Day swaps the
whole `DashColors` set — no per-widget theming. Zero external dependencies, so it
builds anywhere Flutter targets, including flutter-elinux on a Pi.

## Build & run

This directory holds the app source (`lib/` + `pubspec.yaml`). Generate the
platform folders once, then run:

```bash
cd flutter
flutter create --platforms=android,linux,web .   # adds android/ linux/ web/ runners
flutter pub get
flutter run -d linux        # or: -d chrome, or an Android/AAOS device
```

For an embedded Pi dash, build with **flutter-elinux**:

```bash
flutter-elinux build elinux --target-backend-type=wayland
```

## Fonts

Falls back to the platform sans. To match the web preview exactly, add
`assets/fonts/ChakraPetch-*.ttf` and `Barlow-*.ttf`, declare them under
`flutter:` in `pubspec.yaml`, and set `kDisplayFont` / `kBodyFont` in
`lib/theme.dart`.

## Build-verification status

This module is **written and reviewed** (it mirrors the two verified stacks — Qt
and Android — property for property), but it was **not compiled or analyzed in
the session that generated it**: the machine had no Flutter SDK, and a from-
scratch Flutter bootstrap didn't complete under Git Bash on Windows. Run
`flutter pub get && flutter analyze` on your setup — it uses no third-party
packages, so a stock Flutter install is all it needs. Report anything the
analyzer flags and it'll be fixed.
