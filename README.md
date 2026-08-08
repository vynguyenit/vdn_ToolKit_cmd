# vdn_ToolKit

> **Bộ công cụ dòng lệnh toàn diện dành cho Windows – Kiểm tra bản quyền, kích hoạt, cài đặt phần mềm và tối ưu hệ thống
---

## 📖 Mô tả (Description)

**vdn_ToolKit** là một công cụ quản trị hệ thống được thiết kế dành cho các kỹ thuật viên, quản trị viên và người dùng nâng cao, cung cấp các chức năng thiết yếu để kiểm soát và tối ưu hóa máy tính Windows. Được xây dựng dựa trên giao diện menu dòng lệnh đơn giản, trực quan, công cụ cho phép bạn:

- **Kiểm tra thông tin phần cứng và hệ điều hành** (CPU, RAM, ổ đĩa, phiên bản Windows).
- **Xem trạng thái bản quyền Windows và Office** (chi tiết từng phiên bản, key cuối, tình trạng kích hoạt).
- **Kích hoạt Windows và Office** bằng key KMS mặc định (hoặc tùy chỉnh).
- **Xóa bản quyền Windows và Office** một cách triệt để khi cần.
- **Cài đặt hàng loạt các phần mềm phổ biến** thông qua `winget` hoặc tải trực tiếp (silent install).
- **Tối ưu hệ thống** với các tùy chọn: dọn rác, tối ưu mạng, tắt dịch vụ, tối ưu ổ đĩa (SSD TRIM/HDD NTFS), tắt Hibernate.
- **Quản lý máy in** (xóa sạch hoặc mở Print Management).
- **Xuất báo cáo HTML** để lưu trữ hoặc chia sẻ trạng thái hệ thống.

Tất cả các chức năng đều được tích hợp trong một file duy nhất, tự động tải các module cần thiết từ GitHub, chạy với quyền Administrator và tự động dọn dẹp sau khi hoàn tất.

---

## 🚀 Tính năng nổi bật

| Nhóm chức năng | Chi tiết |
|----------------|----------|
| **Thông tin hệ thống** | Hiển thị tên máy, domain, OS, CPU, RAM, dung lượng ổ C:. |
| **Bản quyền Windows** | Kiểm tra Edition, trạng thái kích hoạt, loại license, key cuối. |
| **Bản quyền Office** | Tóm tắt chi tiết từng phiên bản Office (2010, 2013, 2016, 2019, 365) với trạng thái kích hoạt và key cuối. |
| **Kích hoạt Windows/Office** | Sử dụng key KMS mẫu cho Windows 10/11 Pro và Office 2021 Pro Plus (có thể tùy chỉnh). |
| **Xóa bản quyền** | Gỡ sạch key Windows và Office khỏi hệ thống (có xác nhận trước khi thực hiện). |
| **Cài đặt phần mềm** | Hỗ trợ winget cho các phần mềm phổ biến (7-Zip, Chrome, Edge, LibreOffice, .NET Runtime, Notepad++, Telegram, Zalo, ...). Nếu không có winget, sẽ tải và cài silent từ URL (ví dụ KillerPDF). |
| **Tối ưu hệ thống** | - Dọn rác (Temp, Prefetch, Recent)<br>- Tối ưu mạng (flush DNS, reset Winsock/IP)<br>- Tối ưu hiệu suất (High Performance, giảm trễ menu)<br>- Tắt dịch vụ không cần thiết (SysMain, DiagTrack, WSearch)<br>- Xóa cache Windows Update<br>- Tối ưu ổ đĩa SSD/HDD (TRIM hoặc NTFS)<br>- Tắt Hibernate |
| **Quản lý máy in** | - Xóa sạch tất cả máy in (giữ driver)<br>- Mở Print Management để cài đặt thủ công |
| **Xuất báo cáo HTML** | Tự động lưu báo cáo tóm tắt toàn bộ thông tin hệ thống, bản quyền và trạng thái vào thư mục Documents. |

---

## 📥 Hướng dẫn cài đặt và sử dụng

### Yêu cầu
- Hệ điều hành Windows 10/11 (phiên bản 1809 trở lên).
- Quyền **Administrator** (công cụ sẽ tự động yêu cầu nâng quyền nếu chưa có).
- Kết nối Internet để tải các module từ GitHub (lần đầu chạy) và cài đặt phần mềm qua winget.

### Cách chạy
**Cách 1 (nhanh nhất – khuyến nghị):**  
Mở **PowerShell** với quyền Administrator và chạy lệnh:
```powershell
irm https://raw.githubusercontent.com/vynguyenit/vdn_ToolKit/main/vdn_ToolKit.cmd | iex

**Cách 2:
Tải file vdn_ToolKit.cmd về máy, lưu vào thư mục bất kỳ, sau đó chạy với quyền Administrator.

Cách 3:
Clone repository và chạy trực tiếp:
git clone https://github.com/vynguyenit/vdn_ToolKit.git
cd vdn_ToolKit
vdn_ToolKit.cmd

Giao diện điều hướng
Khi chạy, bạn sẽ thấy menu chính như sau:

==================================================
         vdn ToolKit - He thong & Ban quyen
==================================================

[1] Thong tin he thong
[2] Ban quyen Windows
[3] Ban quyen Office
[4] Kich hoat Windows (KMS)
[5] Kich hoat Office (KMS)
[6] Xoa ban quyen Windows (Nguy hiem)
[7] Xoa ban quyen Office (Nguy hiem)

[8] Cai dat phan mem (winget)
[9] Toi uu he thong (Optimizer)

[A] Quan ly may in
[E] Xuat bao cao HTML
[H] Huong dan su dung
[0] Thoat

---
Chon chuc nang [1,2,3...A,E,H,0]:

Chọn số hoặc ký tự tương ứng để thực hiện chức năng.

⚙️ Cấu hình và tùy chỉnh
Thay đổi Key KMS: Mở file modules/system_info.ps1, tìm các biến $key trong hàm Activate-Windows và Activate-Office để thay key mặc định.

Thêm/bớt phần mềm cài đặt: Chỉnh sửa file config/software.json. Cấu trúc:

{
  "apps": [
    {"name": "Tên phần mềm", "id": "winget-id", "url": ""},
    {"name": "Phần mềm khác", "id": "", "url": "https://example.com/setup.exe"}
  ]
}

id: ID trên winget (để trống nếu không dùng winget).

url: Đường dẫn tải về và cài silent (nếu không có winget).

Thay đổi tùy chọn tối ưu: Trong menu, khi chọn mục [9] Toi uu he thong, bạn có thể chọn từng tác vụ riêng lẻ hoặc thực hiện tất cả cùng lúc.

📂 Cấu trúc repository
vdn_ToolKit/
├── vdn_ToolKit.cmd                     # File chính (batch + PowerShell hybrid)
├── modules/
│   ├── system_info.ps1                 # Thông tin máy, bản quyền, kích hoạt
│   ├── software_install.ps1            # Cài đặt phần mềm qua winget/URL
│   └── system_tweaks.ps1               # Tối ưu hệ thống, máy in, báo cáo HTML
├── config/
│   └── software.json                   # Danh sách phần mềm (dễ chỉnh sửa)
└── docs/
    ├── README.md                       # File này
    └── CHANGELOG.md                    # Lịch sử phiên bản
	
❓ Những câu hỏi thường gặp
1. Tôi có cần kết nối Internet để chạy công cụ?

Lần đầu chạy: cần Internet để tải các module từ GitHub về máy.

Đối với các chức năng không cần tải thêm (thông tin máy, bản quyền, xóa bản quyền): có thể chạy offline sau khi đã tải module.

Cài đặt phần mềm qua winget: cần Internet.

2. Công cụ này có an toàn không?

Công cụ được viết hoàn toàn bằng script, không chứa mã độc hại. Tuy nhiên, các thao tác như xóa bản quyền, xóa máy in có ảnh hưởng đến hệ thống, vì vậy bạn nên đọc kỹ cảnh báo trước khi thực hiện.

3. Nếu winget không có sẵn trên máy tôi?

Bạn có thể cài đặt winget từ Microsoft Store hoặc tải từ GitHub. Hoặc bạn có thể sử dụng tùy chọn cài đặt qua URL (đã cấu hình sẵn cho một số phần mềm như KillerPDF).

4. Công cụ có hỗ trợ Windows 7/8 không?

Không chính thức, vì winget và một số lệnh yêu cầu Windows 10/11 trở lên. Bạn có thể chạy một số chức năng cơ bản trên Windows 7/8 nếu cài đặt PowerShell 5.1 trở lên.

🤝 Đóng góp và phát triển
Mọi đóng góp đều được hoan nghênh! Bạn có thể:

Báo lỗi hoặc đề xuất tính năng qua Issues.

Fork repository và tạo Pull Request với các cải tiến.

Quy trình đóng góp:

Fork dự án.

Tạo nhánh mới (git checkout -b feature/your-feature).

Commit thay đổi (git commit -m 'Add some feature').

Push lên nhánh (git push origin feature/your-feature).

Tạo Pull Request.

📄 Giấy phép
Dự án được phân phối theo giấy phép MIT License.

👨‍💻 Tác giả
Vy Nguyen – GitHub

🙏 Lời cảm ơn
Cảm ơn cộng đồng nguồn mở, đặc biệt là dự án Microsoft Activation Scripts (MAS) đã truyền cảm hứng về giao diện và cách tiếp cận đơn giản, hiệu quả.

Chúc bạn sử dụng vdn_ToolKit hiệu quả! Nếu có bất kỳ thắc mắc nào, đừng ngần ngại tạo issue trên GitHub.

Bạn có thể copy toàn bộ nội dung này, dán vào một file mới và lưu với tên `README.md`. Sau đó tải về hoặc upload lên GitHub. Để tải file trực tiếp từ GitHub, bạn có thể sử dụng nút "Download" trên repo, hoặc tạo một file markdown và lưu lại.

Nếu bạn cần một file README đơn giản hơn, tôi có thể rút gọn lại. Còn bây giờ, đây là bản đầy đủ với cấu trúc markdown chuẩn.