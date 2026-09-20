# Contributing to OpenDash

Thanks for helping build a car UI that doesn't suck.

## Ground rules

- **Two taps, max.** If a feature needs more than two touches to reach while driving, rethink it.
- **Touch-first.** Minimum comfortable hit target is ~48px. Design for a thumb on a bumpy road, not a mouse.
- **One accent.** Amber carries interactive/active state. Semantic colors (good/warning/critical) are separate and used sparingly.
- **Reversible.** Any destructive action needs an undo path.
- **No dependencies without a reason.** The core is one HTML file with zero build step — keep it that way unless a library earns its weight.

## Dev setup

No toolchain required.

```bash
git clone <your-fork>
cd opendash
python3 -m http.server 8080
# edit index.html, refresh
```

## Project layout

- `index.html` — the entire app: styles, markup, and logic in one file. State lives in a single `state` object; views are rendered from `render()` and re-wired on each change.

As real backends land (media indexing, CAN bus), we'll split modules out — until then, one file keeps hacking on it frictionless.

## Good first issues

- **Undo/trash flow** — deletes currently remove immediately; add a 5-second undo toast + a trash view.
- **Media indexing** — replace the mock track list with real USB/folder scanning.
- **PWA manifest** — installable, offline, full-screen on a Pi kiosk.
- **Accessibility** — keyboard/rotary-encoder navigation for cars with a control knob.

## Pull requests

- Keep PRs focused — one feature or fix.
- Test on a narrow viewport (portrait) as well as landscape.
- No telemetry, no analytics, no phone-home. Ever.

## Code of conduct

Be decent. We're here to make something people actually enjoy using.
