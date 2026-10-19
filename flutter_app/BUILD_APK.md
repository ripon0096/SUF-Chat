# Build the Android APK

From the repository root:

```bash
cd flutter_app
flutter pub get
flutter analyze
flutter build apk --debug
```

The debug APK is written to:

`build/app/outputs/flutter-apk/app-debug.apk`

For automated builds, use the GitHub Actions workflow at `.github/workflows/build-apk.yml`. When the workflow runs successfully, download the `SUF-Chat-debug-apk` artifact from the workflow run.
