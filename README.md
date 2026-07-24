# Potter API Flutter

A Flutter app that consumes the `fedeperin/potterapi` characters endpoint with
clean architecture and BLoC state management.

## API

- Base URL: `https://potterapi-fedeperin.vercel.app`
- Characters: `GET /en/characters`
- Character search: `GET /en/characters?search=<query>`

## Architecture

- `lib/core`: API, errors, networking, and Android FCM notifications
- `lib/features/characters/domain`: entity, repository contract, use cases
- `lib/features/characters/data`: remote data source, model, repository impl
- `lib/features/characters/presentation`: BLoC, page, widgets

## Firebase Cloud Messaging

- Firebase project: `potter-api-def1x`
- Android package: `com.def1x.potterapi`
- Android 13+ notification permission is requested at runtime
- Foreground messages are displayed with `flutter_local_notifications`
- Notification messages are displayed by Android while the app is in the
  background
- Background data-only messages are displayed by the background handler

Run the app on an Android device with Google Play services and watch the Flutter
console for:

```text
FCM Token: ...
FCM title: ...
FCM body: ...
```

## Run

```bash
flutter pub get
flutter run -d android
flutter run -d ios
```

Only Android and iOS platform folders are generated for this project.

## Verify

```bash
flutter analyze
flutter test
```
