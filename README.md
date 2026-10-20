# SUF-Chat / MEMORY Party — Flutter UI Prototype

This repository contains a Flutter Android UI prototype for a social voice-party app concept, including a dark violet theme, room cards, a 10-seat room layout, profile/wallet mock screens, gift selection, and game entry previews.

## Current status

**UI prototype — not a production-ready voice/chat/payment app.**

Implemented in the current Flutter UI:
- Home and Explore layouts with sample room cards
- Messages screen with sample conversations
- Profile screen with sample level and wallet balances
- Voice-room screen with a 10-seat visual layout and local UI controls
- Gift and game selection preview panels
- Dark violet / indigo visual theme

Not yet implemented or production-verified:
- Real-time voice audio
- Real user accounts/authentication
- Persistent direct messages
- Real live room state and user presence
- Secure wallet balances, purchases, gift settlement, or payments
- Multiplayer game engines
- Production backend hosting, authentication, authorization, and database persistence

The Node.js backend in `backend/` is a small demonstration server with in-memory sample data. It is not production-safe and does not transmit voice audio.

## Project layout

- `flutter_app/` — Flutter mobile UI
- `backend/` — sample Express + Socket.IO server
- `BUILD_APK.md` — local APK build instructions
- `flutter_app/BUILD_APK_WINDOWS.ps1` — Windows local build helper
- `ANTIGRAVITY_HANDOFF.md` — instructions for Gemini Anti-Gravity

## Build a debug APK on Windows

From the repository root, run PowerShell:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\flutter_app\BUILD_APK_WINDOWS.ps1
```

Expected APK:

`flutter_app\build\app\outputs\flutter-apk\app-debug.apk`

You need a working Flutter SDK, Java JDK, Android SDK, and Android SDK licenses accepted. The script can regenerate missing Android platform scaffold files using your installed Flutter SDK, then run dependency resolution, analysis, and a local debug build.

Manual commands:

```powershell
cd flutter_app
flutter doctor -v
flutter pub get
flutter analyze
flutter build apk --debug
```

## Backend demo (optional)

```powershell
cd backend
npm install
npm start
```

The demo server starts on port 3000 and uses sample in-memory data. It is not connected to a deployed production environment. The Flutter client needs a reachable backend URL before network features can work on a real phone.

## Before production release

Implement and test the real voice SDK, authentication, database, message delivery, backend authorization, wallet transaction integrity, abuse prevention, privacy disclosures, release signing, and Play Store compliance. Do not treat mock balances or UI-only buttons as real transactions.
