# SmartShrimp App

Flutter app dành cho Kỹ thuật viên và Chủ trang trại.

## Cấu hình môi trường

App có cấu hình mặc định phục vụ môi trường đồ án:

- API: `https://j6295vbc-3000.asse.devtunnels.ms/api/v1`
- Cloudinary cloud: `dmv1uhpq`
- Unsigned upload preset: `smartshrimp`
- Logo: Cloudinary URL trong `AppConfig.logoUrl`

Có thể ghi đè khi chạy hoặc build:

```bash
flutter run \
  --dart-define=API_BASE_URL=https://example.com/api/v1 \
  --dart-define=CLOUDINARY_CLOUD_NAME=your_cloud \
  --dart-define=CLOUDINARY_UPLOAD_PRESET=your_unsigned_preset
```

Không đưa Cloudinary API secret vào app. Ảnh đại diện được upload bằng unsigned
preset, sau đó URL HTTPS trả về được gửi tới `PATCH /profile`.

## Kiểm tra

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```
