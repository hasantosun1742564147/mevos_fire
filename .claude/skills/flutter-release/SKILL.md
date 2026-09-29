---
name: flutter-release
description: Use when the user asks to build, test, analyze, or prepare a release (APK/AAB/IPA) for this app, bump the app version, or work with codemagic.yaml / iOS CI. Covers the local flutter command flow and how it maps to the Codemagic iOS workflows.
---

# Build, test, and release flow

## Everyday local commands

```
flutter pub get                        # after pubspec.yaml/pubspec.lock changes
flutter analyze                        # static analysis (analysis_options.yaml + flutter_lints)
flutter test                           # all tests
flutter test test/widget_test.dart     # single test file
flutter gen-l10n                       # regenerate lib/l10n/app_localizations*.dart — see the l10n-sync skill
flutter run                            # run on a connected device/emulator
```

Given `main.dart` is ~19.8k lines in one file, `flutter analyze` is the cheapest way to catch
broken references (missing l10n keys, typos in class/field names) after an edit — run it before
declaring a change done.

## Release builds

```
flutter build apk --release            # Android APK
flutter build appbundle --release      # Android AAB (Play Store)
flutter build ios --release --no-codesign   # iOS build without signing (mirrors CI's ios-release)
flutter build ipa --release            # iOS signed IPA (needs valid signing config — mirrors ios-adhoc)
```

Version numbers live in `pubspec.yaml` (`version: X.Y.Z+build`) and are also checked against
`kAppVersion` in `main.dart` via the `fire_version.php` backend endpoint (see the
`api-auth-integration` agent) for in-app update prompts — if you bump the release version in
`pubspec.yaml`, check whether `kAppVersion` in `main.dart` needs a matching bump, since that
constant (not the pubspec version) is what the backend compares against.

Platform manifests to check when changing app identity/permissions:
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`

## Codemagic (iOS CI)

Defined in `codemagic.yaml`, triggered on push to `main`. Two workflows:

- **`ios-release`** — unsigned release build (`flutter build ios --release --no-codesign`) for
  validation only; runs `flutter test` with `ignore_failure: true` (test failures do not fail
  this workflow, so don't rely on it as a test gate) before building. Artifacts:
  `build/ios/iphoneos/Runner.app` and xcodebuild logs.
- **`ios-adhoc`** — signed ad hoc IPA build (`flutter build ipa --release`) for direct device
  installs, using `distribution_type: ad_hoc` and `bundle_identifier: com.mevos.fire`. Requires
  Apple Developer signing to be configured in the Codemagic dashboard (the `app_store_connect`
  integration block is commented out in the yaml — it's not wired up yet).

Both workflows run `flutter pub get` then `pod install` for every `Podfile` found, before
building. If you change iOS native dependencies (`ios/Podfile`, plugins), that's the step that
picks it up in CI — no local `pod install` step is needed unless testing on macOS locally.

When asked to "prepare a release," the concrete checklist is:
1. `flutter analyze` and `flutter test` clean locally (CI's `ignore_failure: true` on tests
   means CI won't catch a real regression here).
2. Bump `version:` in `pubspec.yaml` and, if present, `kAppVersion` in `main.dart`.
3. Run `flutter gen-l10n` if any `.arb` files changed and weren't regenerated yet.
4. Commit, push to a branch, and open/merge to `main` to trigger the Codemagic iOS workflows —
   pushing to `main` is what fires CI, so confirm with the user before pushing if the change
   hasn't been reviewed.
