# Build the SUF-Chat Android APK on Windows

This repository contains a Flutter UI prototype for the MEMORY Party voice-room concept. Build the Android app locally; GitHub Actions is optional.

## Recommended: use the included PowerShell script

From the repository root, open PowerShell and run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\flutter_app\BUILD_APK_WINDOWS.ps1
```

The script checks for Flutter, repairs a missing/incomplete Android platform scaffold using the Flutter SDK installed on your computer, ensures Android Internet permission is present, downloads dependencies, runs analysis, builds a debug APK, and verifies the output file.

Expected output:

`flutter_app\build\app\outputs\flutter-apk\app-debug.apk`

## Manual build

```powershell
cd flutter_app
flutter doctor -v
flutter pub get
flutter analyze
flutter build apk --debug
```

## Important limitations

- A successful APK build proves that the app compiles; it does not prove every feature works.
- Current Home, Explore, Messages, Profile, Wallet, room, seat, gift, and game screens are primarily UI/demo interactions.
- Real voice audio, production authentication, persistent messaging, live rooms, secure wallet/gift transactions, and multiplayer games are not fully implemented or production-verified in this repository.
- The Socket.IO backend currently uses in-memory sample users and is not a production database or a voice-audio service.
- The current app does not have a configured public backend URL. Do not expect the client to connect to the backend from a physical phone using `localhost`.
- The debug APK is for testing. Do not publish it as a production release without completing feature, security, signing, privacy, and Play policy checks.

## GitHub Actions

Workflow: `.github/workflows/build-apk.yml`

If GitHub reports that Actions is disabled for the account, changing this workflow will not remove an account-level restriction. Build locally using the script above while requesting GitHub Support review.
