# Potter API Flutter

A Flutter app that consumes the `fedeperin/potterapi` characters endpoint with
clean architecture and BLoC state management.

## API

- Base URL: `https://potterapi-fedeperin.vercel.app`
- Characters: `GET /en/characters`
- Character search: `GET /en/characters?search=<query>`

## Architecture

- `lib/core`: API constants, HTTP client, exceptions, failures
- `lib/features/characters/domain`: entity, repository contract, use cases
- `lib/features/characters/data`: remote data source, model, repository impl
- `lib/features/characters/presentation`: BLoC, page, widgets

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
