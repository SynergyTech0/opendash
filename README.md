<div align="center">

# OpenDash

**An open-source car head-unit UI that treats the driver like a person, not a spec sheet.**

Clean, big-touch, two taps deep — and yes, it finally has a *delete button*.

</div>

---

## Why

Modern car stereos have incredible hardware — USB, thumb-drive playback, dozens of speakers, studio-grade sound — bolted to software UX that looks like it "compiled, so ship it." Buried menus, tiny targets, five taps to skip a song, and somehow *no way to delete a track*.

OpenDash is the opposite: a touch-first head-unit interface designed like someone actually has to use it while driving. High contrast, one accent color, big hit areas, every screen reachable in two taps, and every destructive action reversible.

## What's here

A complete, dependency-free front-end prototype (`index.html`) with:

- **Now Playing** — album art, large transport controls, scrubbable progress, volume, source switching (USB / Bluetooth / Radio), and a prominent **Delete** button.
- **Media** — the USB library as a flat, scannable list; tap to play, one tap to delete, live "now playing" equalizer.
- **Climate** — dual-zone temperature, 6-speed fan, A/C · Auto · Recirculate · front/rear defrost, and 3-stage seat heaters.
- **Phone** — Bluetooth call surface (placeholder).
- **Settings** — Night/Day instrument themes, brightness, °F/°C.
- Live clock, simulated playback, and a deliberately single "instrument at night" visual world (amber-on-charcoal) with an in-app Day mode.

No frameworks, no build step, no telemetry, no account. One HTML file.

## Run it

It's a static page — open it or serve it:

```bash
# just open
open index.html            # macOS
xdg-open index.html        # Linux

# or serve (nice for a Pi kiosk)
python3 -m http.server 8080
# then browse to http://localhost:8080
```

### On a real head unit

OpenDash is meant to embed anywhere a browser runs:

- **Raspberry Pi** double-DIN builds — Chromium in kiosk mode (`chromium-browser --kiosk http://localhost:8080`).
- **Android** head units — a WebView / PWA wrapper.
- Any Linux dash with a modern browser.

Target the screen's native resolution; the layout is landscape-first and collapses to a single column on narrow/portrait displays.

## Design principles

1. **Two taps, max.** Anything you need while moving is one or two touches away.
2. **One accent.** Amber instrument lighting carries state; semantic colors (good/warning/critical) are separate.
3. **Big targets, high contrast.** Legible at a glance, at speed, in daylight.
4. **Reversible by default.** Nothing destructive without an undo path — starting with the delete button.
5. **Yours.** No account, no cloud, no data leaving the car.

## Roadmap

- [ ] Real audio backend (USB/MTP indexing, gapless playback)
- [ ] Undo/restore for deletes (trash with a timeout)
- [ ] CAN-bus bridge for real climate + vehicle data
- [ ] Reverse-camera and CarPlay/Android Auto handoff
- [ ] Voice ("skip", "delete this", "72 degrees")
- [ ] Theming API + community skins
- [ ] PWA manifest + offline install

## Contributing

PRs welcome — see [CONTRIBUTING.md](CONTRIBUTING.md). Good first issues: real media indexing, the undo/trash flow, and a proper PWA manifest.

## License

[MIT](LICENSE) © 2026 Shane Sipe. Do what you like — just don't design a UI an engineer would.
