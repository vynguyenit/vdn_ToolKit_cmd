param([string]$Function)

function Get-SystemInfo {
    $cs = Get-CimInstance -ClassName Win32_ComputerSystem
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $cpu = $cs.Name
    $ram = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
    $disk = Get-PSDrive -Name C | Select-Object @{N="Size(GB)";E={[math]::Round($_.Used/1GB + $_.Free/1GB,2)}}, 
                                @{N="Free(GB)";E={[math]::Round($_.Free/1GB,2)}}
    Write-Host "Ten may: $($cs.Name)"
    Write-Host "Domain: $($cs.Domain)"
    Write-Host "He dieu hanh: $($os.Caption) (Build $($os.BuildNumber))"
    Write-Host "CPU: $cpu"
    Write-Host "RAM: $ram GB"
    Write-Host "O C: $($disk.'Size(GB)') GB (trong $($disk.'Free(GB)') GB)"
}

function Get-WindowsLicenseInfo {
    $output = & slmgr /dli 2>&1 | Out-String
    $lines = $output -split "`r`n"
    $status = "Khong xac dinh"
    $edition = ""
    $licenseType = ""
    $key = ""
    foreach ($line in $lines) {
        if ($line -match "Name:\s*(.+)") { $edition = $matches[1] }
        if ($line -match "Description:\s*(.+)") { $licenseType = $matches[1] }
        if ($line -match "License Status:\s*(.+)") { $status = $matches[1] }
        if ($line -match "Partial Product Key:\s*(.+)") { $key = $matches[1] }
    }
    Write-Host "Edition: $edition"
    Write-Host "Trang thai: $status"
    Write-Host "Loai license: $licenseType"
    Write-Host "Key cuoi: $key"
    Write-Host "`n--- Chi tiet ---"
    Write-Host $output
}

function Get-OfficeLicenseInfo {
    $officePaths = @(
        @{path="C:\Program Files\Microsoft Office\Office14\ospp.vbs"; version="Office 2010"},
        @{path="C:\Program Files (x86)\Microsoft Office\Office14\ospp.vbs"; version="Office 2010"},
        @{path="C:\Program Files\Microsoft Office\Office15\ospp.vbs"; version="Office 2013"},
        @{path="C:\Program Files (x86)\Microsoft Office\Office15\ospp.vbs"; version="Office 2013"},
        @{path="C:\Program Files\Microsoft Office\Office16\ospp.vbs"; version="Office 2016/2019"},
        @{path="C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs"; version="Office 2016/2019"},
        @{path="C:\Program Files\Microsoft Office\Office19\ospp.vbs"; version="Office 2019"},
        @{path="C:\Program Files (x86)\Microsoft Office\Office19\ospp.vbs"; version="Office 2019"}
    )
    $found = $false
    Write-Host "=== BAN QUYEN OFFICE ==="
    foreach ($item in $officePaths) {
        $path = $item.path
        $version = $item.version
        if (Test-Path $path) {
            $found = $true
            try {
                $output = & cscript $path /dstatus 2>&1 | Out-String
                $lines = $output -split "`r`n"
                $product = ""
                $status = ""
                $key = ""
                foreach ($line in $lines) {
                    if ($line -match "PRODUCT ID:\s*(.+)") { $product = $matches[1] }
                    if ($line -match "LICENSE STATUS:\s*(.+)") { $status = $matches[1] }
                    if ($line -match "Last 5 characters:\s*(.+)") { $key = $matches[1] }
                }
                Write-Host "`n--- $version ---"
                Write-Host "  Product: $product"
                Write-Host "  Trang thai: $status"
                Write-Host "  Key cuoi: $key"
            } catch {
                Write-Host "Loi khi doc $path : $_"
            }
        }
    }
    if (-not $found) {
        Write-Host "Khong tim thay Office MSI. Kiem tra Office 365..."
        $regPath = "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration"
        if (Test-Path $regPath) {
            $product = (Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue).ProductReleaseIds
            Write-Host "Office 365/Click-to-Run: $product"
        }
    }
}

function Activate-Windows {
    $key = "W269N-WFGWX-YVC9B-4J6C9-T83GX"
    Write-Host "Dat key: $key"
    $out1 = & slmgr /ipk $key 2>&1 | Out-String
    Write-Host $out1
    Write-Host "`nKich hoat voi KMS server..."
    $out2 = & slmgr /ato 2>&1 | Out-String
    Write-Host $out2
    if ($LASTEXITCODE -eq 0) { Write-Host "`nKich hoat thanh cong!" } 
    else { Write-Host "`nKich hoat that bai. Kiem tra ket noi mang." }
}

function Activate-Office {
    $key = "FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH"
    $officePaths = @(
        "C:\Program Files\Microsoft Office\Office14\ospp.vbs",
        "C:\Program Files (x86)\Microsoft Office\Office14\ospp.vbs",
        "C:\Program Files\Microsoft Office\Office15\ospp.vbs",
        "C:\Program Files (x86)\Microsoft Office\Office15\ospp.vbs",
        "C:\Program Files\Microsoft Office\Office16\ospp.vbs",
        "C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs",
        "C:\Program Files\Microsoft Office\Office19\ospp.vbs",
        "C:\Program Files (x86)\Microsoft Office\Office19\ospp.vbs"
    )
    $found = $false
    foreach ($path in $officePaths) {
        if (Test-Path $path) {
            $found = $true
            Write-Host "Phat hien Office tai $path"
            $out1 = & cscript $path /inpkey:$key 2>&1 | Out-String
            Write-Host $out1
            $out2 = & cscript $path /act 2>&1 | Out-String
            Write-Host $out2
        }
    }
    if (-not $found) {
        Write-Host "Khong tim thay Office. Vui long kiem tra thu cong."
    }
}

function Remove-WindowsLicense {
    $out1 = & slmgr /upk 2>&1 | Out-String
    Write-Host $out1
    $out2 = & slmgr /cpky 2>&1 | Out-String
    Write-Host $out2
    Write-Host "Da xoa ban quyen Windows."
}

function Remove-OfficeLicense {
    $officePaths = @(
        "C:\Program Files\Microsoft Office\Office14\ospp.vbs",
        "C:\Program Files (x86)\Microsoft Office\Office14\ospp.vbs",
        "C:\Program Files\Microsoft Office\Office15\ospp.vbs",
        "C:\Program Files (x86)\Microsoft Office\Office15\ospp.vbs",
        "C:\Program Files\Microsoft Office\Office16\ospp.vbs",
        "C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs",
        "C:\Program Files\Microsoft Office\Office19\ospp.vbs",
        "C:\Program Files (x86)\Microsoft Office\Office19\ospp.vbs"
    )
    foreach ($path in $officePaths) {
        if (Test-Path $path) {
            Write-Host "Dang xoa key tai $path"
            $output = & cscript $path /dstatus 2>&1 | Select-String "Last 5 characters"
            $keys = $output | ForEach-Object { if ($_ -match "Last 5 characters: (.+)") { $matches[1] } }
            foreach ($key in $keys) {
                if ($key) {
                    $out = & cscript $path /unpkey:$key 2>&1 | Out-String
                    Write-Host $out
                }
            }
        }
    }
    Write-Host "Da xoa cac key Office."
}

# Thuc thi ham duoc goi
if ($Function) { & $Function }