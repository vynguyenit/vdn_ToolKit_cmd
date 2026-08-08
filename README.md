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