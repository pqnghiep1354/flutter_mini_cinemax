# Tài liệu Kỹ thuật Dự án CineMax

Dưới đây là mô tả chi tiết về các tính năng, kiến trúc, và logic xử lý của ứng dụng Flutter CineMax.

---

## 1. Các Tính năng Chính (Features)

- **Xác thực (Authentication):**

  - Đăng nhập bằng Email/Password.
  - Đăng ký tài khoản mới.
  - Đăng nhập bằng Google.
  - Chế độ Khách (Guest Mode) cho phép trải nghiệm không cần tài khoản.
  - Quên mật khẩu và đổi mật khẩu.
- **Khám phá Phim & Series:**

  - Hiển thị danh sách phim theo xu hướng (Trending), phổ biến (Popular), đánh giá cao (Top Rated).
  - Phân loại phim theo thể loại (Genre).
  - Xem chi tiết Phim/Series: thông tin diễn viên (Cast), đánh giá (Reviews), video trailer.
- **Tìm kiếm (Search):**

  - Tìm kiếm phim và series theo từ khóa.
  - Gợi ý tìm kiếm và hiển thị kết quả theo thời gian thực.
- **Cá nhân hóa (My List):**

  - Lưu phim yêu thích vào danh sách (Sử dụng Firebase Firestore).
  - Quản lý hồ sơ người dùng (Edit Profile).
- **Thông báo & Cài đặt:**

  - Nhận thông báo qua Firebase Cloud Messaging (FCM).
  - Cài đặt giao diện (Theme: Dark/Light).
  - Cài đặt ngôn ngữ và bảo mật.

---

## 2. Các Biến và Cấu hình (Variables & Config)

Toàn bộ hằng số và cấu hình được quản lý trong thư mục `lib/config`:

- **`AppConstants`:** Lưu trữ Base URL của TMDB, đường dẫn ảnh (W500, Original), YouTube URL, các thông số Padding, Border Radius, và tên các Collection trên Firestore (`users`, `my_list`, `reviews`).
- **`AppColors` & `AppTheme`:** Quản lý bảng màu hệ thống và cấu hình `ThemeData` cho ứng dụng.
- **`EnvConfig`:** Quản lý các biến môi trường và API Keys.

---

## 3. Models (Thực thể dữ liệu)

Các model được định nghĩa để ánh xạ dữ liệu từ API hoặc Firestore:

- **`Movie` & `Series`:** Chứa thông tin cơ bản về phim/phim bộ (id, title, overview, rating, posterPath...).
- **`UserProfile`:** Lưu trữ thông tin người dùng (uid, name, email, photoUrl, gender, phone...).
- **`Cast` & `Person`:** Thông tin chi tiết về diễn viên.
- **`Review`:** Thông tin về các bài đánh giá (từ TMDB hoặc local Firestore).
- **`Genre`:** Các thể loại phim.
- **`Video`:** Chứa key của YouTube trailer.

---

## 4. Repositories (Lớp xử lý dữ liệu)

Đóng vai trò trung gian giữa Providers và Data Sources (API/Firestore):

- **`TmdbApiService`:** Lớp cơ sở sử dụng `Dio` để gọi API tới TMDB.
- **`MovieRepo` & `SeriesRepo`:** Lấy dữ liệu phim từ TMDB API (Trending, Popular, Details...).
- **`AuthRepo`:** Tương tác với Firebase Auth (Sign In, Sign Up, Sign Out, Google Sign In).
- **`UserRepo`:** Quản lý dữ liệu người dùng trên Firestore (User Profile, FCM Token).
- **`SearchRepo`:** Xử lý logic tìm kiếm phim.

---

## 5. Providers (Quản lý trạng thái - State Management)

Ứng dụng sử dụng `Provider` để quản lý trạng thái:

- **`AuthProvider`:** Quản lý trạng thái đăng nhập, thông tin người dùng hiện tại và luồng điều hướng dựa trên quyền.
- **`HomeProvider`:** Quản lý dữ liệu trang chủ (Trending, Now Playing...).
- **`MovieDetailProvider`:** Quản lý trạng thái chi tiết của một bộ phim (Cast, Trailers, Reviews).
- **`MyListProvider`:** Xử lý việc thêm/xóa phim khỏi danh sách yêu thích.
- **`ThemeProvider`:** Chuyển đổi giữa chế độ sáng và tối.
- **`SearchProvider`:** Quản lý trạng thái và kết quả tìm kiếm.

---

## 6. Screens (Giao diện người dùng)

Ứng dụng được chia thành nhiều module màn hình:

- **Core:** `SplashScreen`, `WelcomeScreen`, `MainNavScreen` (Bottom Navigation).
- **Auth:** `LoginScreen`, `RegisterScreen`, `ForgotPasswordScreen`.
- **Home:** `HomeScreen`, `SectionMoviesScreen` (Xem thêm).
- **Detail:** `MovieDetailScreen`, `SeriesDetailScreen`, `PersonDetailScreen`.
- **User:** `ProfileScreen`, `EditProfileScreen`, `SecurityScreen`, `NotificationsScreen`.

---

## 7. Luồng Dữ liệu (Data Flow)

Luồng đi của dữ liệu trong ứng dụng tuân theo quy tắc:
**UI -> Provider -> Repo -> Service -> Model -> UI**

1. **Gửi yêu cầu:** Người dùng thao tác trên UI (ví dụ: nhấn nút "Like").
2. **Xử lý logic:** UI gọi một phương thức trong `Provider`.
3. **Gọi dữ liệu:** `Provider` yêu cầu `Repo` thực hiện xử lý (ví dụ: gọi Firestore API).
4. **Ánh xạ dữ liệu:** `Repo` nhận dữ liệu thô, sử dụng `Model` để chuyển đổi và trả về đối tượng Dart cho `Provider`.
5. **Cập nhật UI:** `Provider` lưu trữ dữ liệu mới và gọi `notifyListeners()`, UI lắng nghe và render lại.

---

## 8. Logic xử lý Đặc trưng

- **Navigation Logic:** Sử dụng `GoRouter`. Có logic `redirect` trong `AppRouter` để kiểm tra trạng thái đăng nhập của `AuthProvider`. Nếu chưa đăng nhập, người dùng sẽ bị đẩy về màn hình `Welcome`.
- **Image Caching:** Sử dụng `CachedNetworkImage` để tối ưu hiệu suất tải ảnh từ TMDB.
- **Firebase Integration:** Kết hợp Firebase Auth để quản lý người dùng và Firestore để lưu trữ dữ liệu thực tế (My List, Reviews).
- **Theme Logic:** Lắng nghe cấu hình hệ thống hoặc lựa chọn của người dùng trong `ThemeProvider` để cập nhật toàn bộ App Theme.
