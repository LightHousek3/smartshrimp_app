# SmartShrimp Mobile App

> Farm Operations Management and Technical Consulting System for Shrimp Farms

The SmartShrimp mobile app supports farm owners and technicians in day-to-day farm operations.

## Features

- **Farm owners** manage farms, ponds, production cycles, staff assignments, inventory, and harvests. They review and approve production and treatment protocols.
- **Technicians** record water quality, shrimp health, and material use. They complete assigned tasks, submit disease cases, and communicate with experts.

## Technology

**Flutter · Dart · Riverpod · GoRouter · Dio**

## Getting started

Use Flutter with Dart 3.11.5 or later, a running SmartShrimp Backend, and an Android device or emulator.

Copy [the example configuration](config/app.example.json) to `config/app.local.json` and fill in the required values. Set `API_BASE_URL` to the API address reachable from the device, including the `/api/v1` prefix.

```sh
flutter pub get
flutter run --dart-define-from-file=config/app.local.json
```

Run `flutter analyze` to check the app source.

## Project team

**Mentor** — Nguyễn Đình Vinh

**Members**

- Phạm Hải Đăng
- Nguyễn Thị Kim Soàn
- Phạm Quốc Tự
- Liêu Tấn Đạt
- Cô Thái Bảo
