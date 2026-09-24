# SmartShrimp App

Ứng dụng Flutter dành cho chủ trang trại và kỹ thuật viên SmartShrimp.

## Chạy nhanh trên Windows

Từ thư mục gốc `SmartShrimp`, chạy đúng một lệnh:

```powershell
.\smartshrimp_app\run.cmd
```

Launcher sẽ tự động:

- kiểm tra Flutter và thiết bị chạy;
- cài dependency Flutter bằng `flutter pub get`;
- dùng API local tại `http://localhost:3000/api/v1`;
- khởi động backend ở `../smartshrimp_be` nếu cổng API chưa chạy;
- chạy app trên Windows (hoặc thiết bị Android đang kết nối nếu được chọn rõ).

Khi thoát app bằng `q`, backend do launcher tạo cũng được dừng. Backend đã chạy
từ trước sẽ được giữ nguyên.

## Tùy chọn thường dùng

```powershell
# Chọn đích chạy
.\smartshrimp_app\run.cmd -Device windows
.\smartshrimp_app\run.cmd -Device chrome
.\smartshrimp_app\run.cmd -Device android

# Dùng backend khác hoặc không cho launcher tự bật backend
.\smartshrimp_app\run.cmd -ApiBaseUrl "https://api.example.com/api/v1"
.\smartshrimp_app\run.cmd -NoBackend

# Chỉ cài dependency và kiểm tra môi trường
.\smartshrimp_app\run.cmd -SetupOnly
```

Nếu chạy trên Android Emulator, launcher tự dùng `10.0.2.2` để truy cập máy
host. Với điện thoại Android thật, truyền IP LAN của máy tính:

```powershell
.\smartshrimp_app\run.cmd -Device android `
  -ApiBaseUrl "http://192.168.1.10:3000/api/v1"
```

Android cần JDK 17 trở lên và một emulator/thiết bị đã kết nối. Có thể kiểm tra
bằng `flutter doctor -v` và `flutter devices`.

## Cấu hình Cloudinary (không bắt buộc để khởi động app)

Sao chép `config/local.example.json` thành `config/local.json`, sau đó điền
upload preset nếu cần chức năng đổi ảnh đại diện. `config/local.json` đã được
git ignore để tránh commit cấu hình riêng của máy.

App vẫn có thể chạy trực tiếp bằng Flutter trên Windows:

```powershell
cd smartshrimp_app
flutter run -d windows
```
