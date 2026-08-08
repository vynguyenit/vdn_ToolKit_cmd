@echo off
title vdn_ToolKit v3.0
color 0A
mode con: cols=85 lines=40
setlocal enabledelayedexpansion

:: Tự động nâng quyền Administrator
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Dang yeu cau quyen Administrator...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Tạo thư mục tạm
set "TOOLKIT_DIR=%USERPROFILE%\tempkit\vdn_ToolKit_%RANDOM%"
mkdir "%TOOLKIT_DIR%" 2>nul

:: Tải các module từ GitHub (thay bằng repo của bạn)
set "REPO_URL=https://raw.githubusercontent.com/vynguyenit/vdn_ToolKit/main"
powershell -Command "Invoke-WebRequest -Uri '%REPO_URL%/modules/system_info.ps1' -OutFile '%TOOLKIT_DIR%\system_info.ps1'" >nul 2>&1
powershell -Command "Invoke-WebRequest -Uri '%REPO_URL%/modules/software_install.ps1' -OutFile '%TOOLKIT_DIR%\software_install.ps1'" >nul 2>&1
powershell -Command "Invoke-WebRequest -Uri '%REPO_URL%/modules/system_tweaks.ps1' -OutFile '%TOOLKIT_DIR%\system_tweaks.ps1'" >nul 2>&1
powershell -Command "Invoke-WebRequest -Uri '%REPO_URL%/config/software.json' -OutFile '%TOOLKIT_DIR%\software.json'" >nul 2>&1

:menu
cls
echo ==================================================
echo          vdn ToolKit - He thong ^& Ban quyen
echo ==================================================
echo.
echo [1] Thong tin he thong
echo [2] Ban quyen Windows
echo [3] Ban quyen Office
echo [4] Kich hoat Windows (KMS)
echo [5] Kich hoat Office (KMS)
echo [6] Xoa ban quyen Windows (Nguy hiem)
echo [7] Xoa ban quyen Office (Nguy hiem)
echo.
echo [8] Cai dat phan mem (winget)
echo [9] Toi uu he thong (Optimizer)
echo.
echo [A] Quan ly may in
echo [E] Xuat bao cao HTML
echo [H] Huong dan su dung
echo [0] Thoat
echo.
echo ==================================================
set /p choice="Chon chuc nang [1,2,3...A,E,H,0]: "

if "%choice%"=="1" goto system_info
if "%choice%"=="2" goto license_win
if "%choice%"=="3" goto license_office
if "%choice%"=="4" goto activate_win
if "%choice%"=="5" goto activate_office
if "%choice%"=="6" goto remove_win
if "%choice%"=="7" goto remove_office
if "%choice%"=="8" goto install_software
if "%choice%"=="9" goto system_tweaks
if /i "%choice%"=="A" goto printer_menu
if /i "%choice%"=="E" goto export_report
if /i "%choice%"=="H" goto help
if "%choice%"=="0" goto cleanup
goto menu

:system_info
cls
echo ==================================================
echo           THONG TIN HE THONG
echo ==================================================
echo.
powershell -ExecutionPolicy Bypass -File "%TOOLKIT_DIR%\system_info.ps1" -Function "Get-SystemInfo"
echo.
pause
goto menu

:license_win
cls
echo ==================================================
echo           BAN QUYEN WINDOWS
echo ==================================================
echo.
powershell -ExecutionPolicy Bypass -File "%TOOLKIT_DIR%\system_info.ps1" -Function "Get-WindowsLicenseInfo"
echo.
pause
goto menu

:license_office
cls
echo ==================================================
echo           BAN QUYEN OFFICE
echo ==================================================
echo.
powershell -ExecutionPolicy Bypass -File "%TOOLKIT_DIR%\system_info.ps1" -Function "Get-OfficeLicenseInfo"
echo.
pause
goto menu

:activate_win
cls
echo ==================================================
echo           KICH HOAT WINDOWS (KMS)
echo ==================================================
echo.
echo Canh bao: Thao tac nay se thay doi ban quyen Windows.
set /p confirm="Ban co muon tiep tuc? (Y/N): "
if /i not "%confirm%"=="Y" goto menu
powershell -ExecutionPolicy Bypass -File "%TOOLKIT_DIR%\system_info.ps1" -Function "Activate-Windows"
echo.
pause
goto menu

:activate_office
cls
echo ==================================================
echo           KICH HOAT OFFICE (KMS)
echo ==================================================
echo.
echo Canh bao: Thao tac nay se thay doi ban quyen Office.
set /p confirm="Ban co muon tiep tuc? (Y/N): "
if /i not "%confirm%"=="Y" goto menu
powershell -ExecutionPolicy Bypass -File "%TOOLKIT_DIR%\system_info.ps1" -Function "Activate-Office"
echo.
pause
goto menu

:remove_win
cls
echo ==================================================
echo     XOA BAN QUYEN WINDOWS (NGUY HIEM)
echo ==================================================
echo.
echo CANH BAO: Hanh dong nay se xoa ban quyen Windows khoi may.
echo Ban se CAN KICH HOAT LAI neu muon su dung.
echo.
set /p confirm="Ban co chac chan? (Y/N): "
if /i not "%confirm%"=="Y" goto menu
powershell -ExecutionPolicy Bypass -File "%TOOLKIT_DIR%\system_info.ps1" -Function "Remove-WindowsLicense"
echo.
pause
goto menu

:remove_office
cls
echo ==================================================
echo      XOA BAN QUYEN OFFICE (NGUY HIEM)
echo ==================================================
echo.
echo CANH BAO: Hanh dong nay se xoa ban quyen Office.
set /p confirm="Ban co chac chan? (Y/N): "
if /i not "%confirm%"=="Y" goto menu
powershell -ExecutionPolicy Bypass -File "%TOOLKIT_DIR%\system_info.ps1" -Function "Remove-OfficeLicense"
echo.
pause
goto menu

:install_software
cls
echo ==================================================
echo           CAI DAT PHAN MEM (WINGET)
echo ==================================================
echo.
echo Dang tai danh sach phan mem...
powershell -ExecutionPolicy Bypass -File "%TOOLKIT_DIR%\software_install.ps1" -Function "Show-SoftwareList" -ConfigPath "%TOOLKIT_DIR%\software.json"
echo.
echo Nhap so thu tu phan mem can cai (cach nhau dau cach)
echo Vi du: 1 3 5
set /p selections="Chon: "
powershell -ExecutionPolicy Bypass -File "%TOOLKIT_DIR%\software_install.ps1" -Function "Install-Selected" -ConfigPath "%TOOLKIT_DIR%\software.json" -Selections "%selections%"
echo.
pause
goto menu

:system_tweaks
cls
echo ==================================================
echo        TOI UU HE THONG (OPTIMIZER)
echo ==================================================
echo.
echo Chon cac tuy chon toi uu:
echo.
echo [1] Don rac he thong (Temp, Prefetch, Recent)
echo [2] Toi uu mang (Flush DNS, Reset Winsock)
echo [3] Toi uu hieu suat (High Performance, Menu delay)
echo [4] Tat dich vu khong can thiet (SysMain, DiagTrack, WSearch)
echo [5] Xoa cache Windows Update
echo [6] Toi uu o dia (SSD TRIM / HDD NTFS)
echo [7] Tat Hibernate
echo [8] THUC HIEN TAT CA
echo [0] Quay lai
echo.
set /p tweak_choice="Chon [1-8 hoac 0]: "
if "%tweak_choice%"=="0" goto menu
powershell -ExecutionPolicy Bypass -File "%TOOLKIT_DIR%\system_tweaks.ps1" -Function "Invoke-SystemTweaks" -ToolkitDir "%TOOLKIT_DIR%" -Option "%tweak_choice%"
echo.
pause
goto menu

:printer_menu
cls
echo ==================================================
echo           QUAN LY MAY IN
echo ==================================================
echo.
echo [1] Xoa sach may in (giu driver)
echo [2] Mo Print Management (cai dat may in)
echo [0] Quay lai
echo.
set /p printer_choice="Chon [1,2 hoac 0]: "
if "%printer_choice%"=="1" goto remove_printers
if "%printer_choice%"=="2" goto open_print_mgmt
goto menu

:remove_printers
cls
echo ==================================================
echo           XOA SACH MAY IN
echo ==================================================
echo.
echo CANH BAO: Tat ca may in tren he thong se bi xoa.
set /p confirm="Ban co chac chan? (Y/N): "
if /i not "%confirm%"=="Y" goto menu
powershell -ExecutionPolicy Bypass -File "%TOOLKIT_DIR%\system_tweaks.ps1" -Function "Remove-AllPrinters"
echo.
pause
goto menu

:open_print_mgmt
start printmanagement.msc
goto menu

:export_report
cls
echo ==================================================
echo           XUAT BAO CAO HTML
echo ==================================================
echo.
powershell -ExecutionPolicy Bypass -File "%TOOLKIT_DIR%\system_tweaks.ps1" -Function "Generate-HTMLReport" -ToolkitDir "%TOOLKIT_DIR%"
echo.
pause
goto menu

:help
cls
echo ==================================================
echo           HUONG DAN SU DUNG
echo ==================================================
echo.
echo vdn_ToolKit - Bo cong cu quan tri he thong
echo.
echo CAC CHUC NANG CHINH:
echo.
echo 1. Thong tin he thong - Hien thi CPU, RAM, o dia, OS
echo 2. Ban quyen Windows - Kiem tra trang thai kich hoat
echo 3. Ban quyen Office - Kiem tra trang thai kich hoat
echo 4. Kich hoat Windows - Su dung key KMS (W269N-...)
echo 5. Kich hoat Office - Su dung key KMS (FXYTK-...)
echo 6. Xoa ban quyen Windows - Xoa key khoi he thong
echo 7. Xoa ban quyen Office - Xoa key khoi he thong
echo.
echo 8. Cai dat phan mem - Cai qua winget hoac tai truc tiep
echo 9. Toi uu he thong - Don rac, toi uu mang, hieu suat, SSD/HDD
echo.
echo A. Quan ly may in - Xoa may in hoac mo Print Management
echo E. Xuat bao cao HTML - Luu vao thu muc Documents
echo H. Hien thi huong dan nay
echo 0. Thoat
echo.
echo LUU Y:
echo - Can chay voi quyen Administrator
echo - Ket noi Internet can thiet cho mot so chuc nang
echo - Cac thao tac danh dau "Nguy hiem" can xac nhan truoc khi thuc hien
echo.
pause
goto menu

:cleanup
cls
echo Dang don dep...
rmdir /s /q "%TOOLKIT_DIR%" 2>nul
echo Tam biet!
timeout /t 1 >nul
exit