# Focus With Me

A minimal, premium-feeling focus timer for iOS. Dark-first UI, gentle ambient motion, lightweight “presence” energy, and optional ambient audio—without turning the app into a settings maze.

## What you get

- **Single-screen focus timer** (SwiftUI + MVVM)
- **Ambient background** tuned for calm motion (slow drift, low contrast)
- **Skippable onboarding** (3 pages max) shown only on first launch
- **Ambient audio (v1)**:
  - A **3-option strip** for **Rain / Café / Chatter** (always visible)
  - A **top-right cycle button** still cycles **Off → Rain → Café → Chatter → Off**
  - **Haptics + a tiny toast** confirm each change (minimal, no menus)
- **Completion overlay** for a clean “session complete” moment

## Requirements

- **Xcode** (recommended: latest stable you use for iOS development)
- **iOS 16+** deployment target (SwiftUI-first)

## Open the project

1. Clone the repo
2. Open `focus with me.xcodeproj`
3. Select an iOS Simulator (or a device) and **Run**

## Architecture

This project follows **MVVM**:

- **Views** (`Features/*`, `Components/*`) render state and forward user intent
- **ViewModels** (`Features/Timer/FocusTimerViewModel.swift`) own timer + ambient audio state
- **Utilities** (`Utilities/*`) are small pure helpers (time formatting)

## Onboarding (first launch)

Onboarding is gated with:

- `@AppStorage("hasCompletedOnboarding")`

To see onboarding again while developing:

- Delete/reinstall the app **or** reset the stored flag via Simulator **Device → Erase All Content and Settings** (heavy-handed but reliable)

## Ambient audio assets

Bundled loops live in:

- `focus with me/Resources/Ambient/`

Expected files:

- `rain.mp3`
- `cafe.mp3`
- `softchatter.mp3` (mapped to the “white noise / chatter” slot in code)

The loader prefers **MP3**, with safe fallbacks if you swap formats during development.

## Tests

Run tests from Terminal:

```bash
xcodebuild test \
  -project "focus with me.xcodeproj" \
  -scheme "focus with me" \
  -destination "platform=iOS Simulator,name=iPhone 17 Pro"
```

## Troubleshooting (Simulator)

### “Application failed preflight checks” / app won’t install

This is usually **stale simulator install state**, not app logic.

Quick recovery:

- **Product → Clean Build Folder**
- Delete the app from the simulator, then Run again
- If it persists: **Device → Erase All Content and Settings** for that simulator

### Xcode deployment target warnings

If you see warnings about `IPHONEOS_DEPLOYMENT_TARGET` being set higher than your installed simulator SDK, align the project’s deployment target with an SDK version you actually have installed.

## Repo layout (high signal)

- `focus with me/FocusWithMeApp.swift` — app entry + onboarding gate
- `focus with me/Features/Timer/` — timer screen + engine
- `focus with me/Features/Ambient/` — ambient background
- `focus with me/Components/` — reusable UI pieces
- `focus with me/Onboarding/` — onboarding flow
- `focus with me/Resources/Ambient/` — bundled audio loops

## License

Add a license if you plan to open-source broadly (MIT is common for indie apps). If you want, tell me which license you prefer and I’ll add it cleanly.
