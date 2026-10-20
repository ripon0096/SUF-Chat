# Gemini Anti-Gravity handoff — SUF-Chat

Repository: https://github.com/ripon0096/SUF-Chat
Flutter project directory: `flutter_app`

## Goal

Prepare the existing project and build a debug APK on this Windows computer. Do not depend on GitHub Actions. Do not replace the existing app UI with Flutter's sample counter app.

## Required steps

1. Inspect the repository and read `BUILD_APK.md` and `flutter_app/BUILD_APK_WINDOWS.ps1`.
2. Open the Flutter project at `flutter_app`, not the repository root as if it were a Flutter project.
3. Check `flutter --version`, `java -version`, and `flutter doctor -v`.
4. Run the helper from the repository root in PowerShell:
   ```powershell
   Set-ExecutionPolicy -Scope Process Bypass
   .\flutter_app\BUILD_APK_WINDOWS.ps1
   ```
5. If the script or build fails, inspect the first actual error, fix the project or local SDK configuration, and rerun the build. Do not suppress compile errors or claim success without verifying that the APK file exists.
6. Expected APK:
   `flutter_app\build\app\outputs\flutter-apk\app-debug.apk`
7. Preserve the current MEMORY Party UI and existing source code. Do not delete or rewrite the UI just to make the build pass.
8. Report what was checked, exact commands run, whether the build succeeded, the APK's exact path and file size, and any unresolved warnings.

## Important honesty requirement

This repository is currently a UI/demo prototype. A successful APK build does not implement or verify real voice audio, authentication, persistent messaging, production live rooms, secure wallet/gift transactions, or multiplayer games. Do not invent backend URLs, credentials, or completed functionality. The backend currently uses in-memory sample data; `localhost` on a physical phone is not the computer's backend.
