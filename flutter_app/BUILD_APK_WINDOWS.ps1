# Windows local Flutter APK build helper for SUF-Chat.
# Run from any directory: .\flutter_app\BUILD_APK_WINDOWS.ps1
$ErrorActionPreference = 'Stop'

$appDir = $PSScriptRoot
Set-Location $appDir

function Stop-WithMessage([string]$message) {
    Write-Host ""
    Write-Host $message -ForegroundColor Red
    exit 1
}

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Stop-WithMessage "Flutter was not found in PATH. Install Flutter or add its bin folder to PATH, restart Anti-Gravity/PowerShell, then run this script again."
}

Write-Host "=== Flutter version ===" -ForegroundColor Cyan
flutter --version
if ($LASTEXITCODE -ne 0) { Stop-WithMessage "Flutter could not start. Check your Flutter SDK installation." }

Write-Host ""
Write-Host "=== Android toolchain check ===" -ForegroundColor Cyan
flutter doctor -v
if ($LASTEXITCODE -ne 0) {
    Write-Warning "flutter doctor reported an issue. Continuing to attempt the build; fix any Android SDK/JDK/license errors if the build stops."
}

$requiredFiles = @(
    "android\settings.gradle",
    "android\gradle\wrapper\gradle-wrapper.properties",
    "android\gradlew.bat",
    "android\app\src\main\AndroidManifest.xml"
)
$missingFiles = @($requiredFiles | Where-Object { -not (Test-Path (Join-Path $appDir $_)) })

if ($missingFiles.Count -gt 0) {
    Write-Host ""
    Write-Host "Android platform files are incomplete. Regenerating them with the installed Flutter SDK..." -ForegroundColor Yellow
    Write-Host ("Missing: " + ($missingFiles -join ", "))

    $androidDir = Join-Path $appDir "android"
    $backupDir = Join-Path $env:TEMP ("SUF-Chat-android-backup-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
    if (Test-Path $androidDir) {
        Move-Item -LiteralPath $androidDir -Destination $backupDir
        Write-Host "Previous incomplete Android folder backed up to: $backupDir"
    }

    flutter create --platforms=android --org com.memoryparty --project-name voice_chat_app .
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path (Join-Path $appDir "android\settings.gradle"))) {
        if (-not (Test-Path $androidDir) -and (Test-Path $backupDir)) {
            Move-Item -LiteralPath $backupDir -Destination $androidDir
        }
        Stop-WithMessage "Flutter could not regenerate the Android platform files. See the output above and send it to Anti-Gravity."
    }
}

$manifestPath = Join-Path $appDir "android\app\src\main\AndroidManifest.xml"
if (-not (Test-Path $manifestPath)) {
    Stop-WithMessage "AndroidManifest.xml is still missing after scaffold generation."
}
$manifest = Get-Content -LiteralPath $manifestPath -Raw
if ($manifest -notmatch 'android\.permission\.INTERNET') {
    $manifest = [regex]::Replace(
        $manifest,
        '(<manifest\b[^>]*>)',
        '$1' + [Environment]::NewLine + '    <uses-permission android:name="android.permission.INTERNET" />',
        1
    )
}
$manifest = [regex]::Replace($manifest, 'android:label="[^"]*"', 'android:label="MEMORY Party"', 1)
Set-Content -LiteralPath $manifestPath -Value $manifest -Encoding UTF8

Write-Host ""
Write-Host "=== Resolving Flutter packages ===" -ForegroundColor Cyan
flutter pub get
if ($LASTEXITCODE -ne 0) { Stop-WithMessage "flutter pub get failed. Check network access and the dependency error above." }

Write-Host ""
Write-Host "=== Static analysis (warnings are shown; build will still be attempted) ===" -ForegroundColor Cyan
flutter analyze
if ($LASTEXITCODE -ne 0) {
    Write-Warning "flutter analyze reported issues. The APK build will be attempted; compile errors must still be fixed."
}

Write-Host ""
Write-Host "=== Building debug APK locally ===" -ForegroundColor Cyan
flutter build apk --debug
if ($LASTEXITCODE -ne 0) { Stop-WithMessage "APK build failed. Copy the complete error output and give it to Anti-Gravity for fixing." }

$apkPath = Join-Path $appDir "build\app\outputs\flutter-apk\app-debug.apk"
if (-not (Test-Path $apkPath)) { Stop-WithMessage "Flutter reported success but the expected APK file was not found." }

Write-Host ""
Write-Host "BUILD SUCCESSFUL" -ForegroundColor Green
Write-Host ("APK: " + $apkPath) -ForegroundColor Green
Write-Host ("Size: " + [math]::Round((Get-Item $apkPath).Length / 1MB, 2) + " MB")
Write-Host "This is a debug/testing APK. UI-only/demo features are not thereby made production-functional."
