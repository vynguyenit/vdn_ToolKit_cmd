param([string]$Function, [string]$ToolkitDir, [string]$Option)

function Invoke-SystemTweaks {
    $result = "=== BAT DAU TOI UU HE THONG ==="
    switch ($Option) {
        "1" { 
            Write-Host "[1] Don rac he thong..."
            $temp = $env:TEMP
            $exclude = (Get-Item $ToolkitDir).Name
            Get-ChildItem -Path $temp -Directory -Exclude $exclude | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            Get-ChildItem -Path $temp -File | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } | Remove-Item -Force -ErrorAction SilentlyContinue
            Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "  Da don rac."
        }
        "2" {
            Write-Host "[2] Toi uu mang..."
            ipconfig /flushdns | Out-Null
            netsh int ip reset | Out-Null
            netsh winsock reset | Out-Null
            Write-Host "  Da reset Winsock/IP."
        }
        "3" {
            Write-Host "[3] Toi uu hieu suat..."
            powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
            reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f | Out-Null
            Write-Host "  Da thiet lap High Performance, giam tre menu."
        }
        "4" {
            Write-Host "[4] Tat dich vu khong can thiet..."
            $services = @("DiagTrack", "SysMain", "WSearch")
            foreach ($svc in $services) {
                & sc.exe stop $svc 2>$null | Out-Null
                & sc.exe config $svc start= disabled 2>$null | Out-Null
                Write-Host "  Da tat $svc."
            }
        }
        "5" {
            Write-Host "[5] Xoa cache Windows Update..."
            net stop wuauserv | Out-Null
            net stop bits | Out-Null
            Remove-Item -Path "C:\Windows\SoftwareDistribution\*" -Recurse -Force -ErrorAction SilentlyContinue
            net start wuauserv | Out-Null
            net start bits | Out-Null
            Write-Host "  Da xoa cache."
        }
        "6" {
            Write-Host "[6] Toi uu o dia..."
            $disk = (Get-Partition -DriveLetter C).DiskNumber
            $media = (Get-PhysicalDisk -DeviceNumber $disk).MediaType
            if ($media -eq "SSD") {
                Optimize-Volume -DriveLetter C -ReTrim | Out-Null
                Write-Host "  SSD: da kich hoat TRIM."
            } else {
                fsutil behavior set disablelastaccess 1 | Out-Null
                fsutil behavior set disable8dot3 1 | Out-Null
                Write-Host "  HDD: da toi uu NTFS (khong defrag)."
            }
        }
        "7" {
            Write-Host "[7] Tat Hibernate..."
            powercfg -h off | Out-Null
            Write-Host "  Da tat Hibernate."
        }
        "8" {
            Write-Host "Thuc hien TAT CA cac tuy chon toi uu..."
            Invoke-SystemTweaks -ToolkitDir $ToolkitDir -Option "1"
            Invoke-SystemTweaks -ToolkitDir $ToolkitDir -Option "2"
            Invoke-SystemTweaks -ToolkitDir $ToolkitDir -Option "3"
            Invoke-SystemTweaks -ToolkitDir $ToolkitDir -Option "4"
            Invoke-SystemTweaks -ToolkitDir $ToolkitDir -Option "5"
            Invoke-SystemTweaks -ToolkitDir $ToolkitDir -Option "6"
            Invoke-SystemTweaks -ToolkitDir $ToolkitDir -Option "7"
            Write-Host "`n=== HOAN THANH TOI UU ==="
        }
        default { Write-Host "Lua chon khong hop le." }
    }
}

function Remove-AllPrinters {
    $printers = Get-Printer | Where-Object { $_.Name -notlike "*Microsoft Print to PDF*" -and $_.Name -notlike "*Microsoft XPS*" -and $_.Name -notlike "*Fax*" }
    if ($printers.Count -eq 0) {
        Write-Host "Khong co may in nao de xoa."
        return
    }
    foreach ($p in $printers) {
        Remove-Printer -Name $p.Name -Confirm:$false -ErrorAction SilentlyContinue
        Write-Host "Da xoa: $($p.Name)"
    }
    Write-Host "`nXoa thanh cong $(($printers).Count) may in."
}

function Generate-HTMLReport {
    $reportPath = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "vdn_Report_$(Get-Date -Format 'yyyyMMdd_HHmmss').html"
    $report = @"
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>vdn_ToolKit Report</title>
<style>body{font-family:Segoe UI;background:#2d2d30;color:#d0d0d0;padding:20px}h1{color:#4ec9b0}</style>
</head>
<body>
<h1>Bao cao he thong - vdn_ToolKit</h1>
<h2>Thong tin may</h2>
<pre>$(Get-SystemInfo 2>&1 | Out-String)</pre>
<h2>Ban quyen Windows</h2>
<pre>$(Get-WindowsLicenseInfo 2>&1 | Out-String)</pre>
<h2>Ban quyen Office</h2>
<pre>$(Get-OfficeLicenseInfo 2>&1 | Out-String)</pre>
</body></html>
"@
    $report | Out-File -FilePath $reportPath -Encoding UTF8
    Write-Host "Bao cao da luu tai: $reportPath"
    Start-Process $reportPath
}

# Import cac ham tu system_info.ps1
. (Join-Path $ToolkitDir "system_info.ps1")

if ($Function) { & $Function }