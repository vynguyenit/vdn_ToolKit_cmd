param([string]$Function, [string]$ConfigPath, [string]$Selections)

function Show-SoftwareList {
    $appList = @()
    if (Test-Path $ConfigPath) {
        $json = Get-Content $ConfigPath | ConvertFrom-Json
        $appList = $json.apps
    } else {
        $appList = @(
            @{name="7-Zip"; id="7zip.7zip"; url=""},
            @{name="Google Chrome"; id="Google.Chrome"; url=""},
            @{name="Microsoft Edge"; id="Microsoft.Edge"; url=""},
            @{name="LibreOffice"; id="LibreOffice.LibreOffice"; url=""},
            @{name="OnlyOffice"; id="ONLYOFFICE.ONLYOFFICE"; url=""},
            @{name=".NET Runtime 4.8"; id="Microsoft.DotNet.Runtime.4_8"; url=""},
            @{name=".NET Runtime 6"; id="Microsoft.DotNet.Runtime.6"; url=""},
            @{name=".NET Runtime 8"; id="Microsoft.DotNet.Runtime.8"; url=""},
            @{name="Notepad++"; id="Notepad++.Notepad++"; url=""},
            @{name="Telegram"; id="Telegram.TelegramDesktop"; url=""},
            @{name="Zalo"; id="Zalo.Zalo"; url=""},
            @{name="KillerPDF"; id=""; url="https://download.killerpdf.com/KillerPDFSetup.exe"}
        )
    }
    $i = 1
    foreach ($app in $appList) {
        Write-Host "[$i] $($app.name)"
        $i++
    }
}

function Install-Selected {
    $appList = @()
    if (Test-Path $ConfigPath) {
        $json = Get-Content $ConfigPath | ConvertFrom-Json
        $appList = $json.apps
    } else {
        Write-Host "Khong tim thay file cau hinh."
        return
    }
    $selectedIndexes = $Selections -split " "
    Write-Host "`n=== BAT DAU CAI DAT ==="
    foreach ($idx in $selectedIndexes) {
        $num = [int]$idx
        if ($num -ge 1 -and $num -le $appList.Count) {
            $app = $appList[$num-1]
            $name = $app.name
            $id = $app.id
            $url = $app.url

            if ($id -and $id -ne "") {
                Write-Host "Dang cai $name (winget: $id)..."
                $proc = Start-Process -FilePath "winget" -ArgumentList "install $id --silent --accept-package-agreements --accept-source-agreements" -Wait -PassThru -NoNewWindow
                if ($proc.ExitCode -eq 0) {
                    Write-Host "  [+] $name cai thanh cong."
                } else {
                    Write-Host "  [-] $name cai that bai (ma $($proc.ExitCode))."
                }
            } elseif ($url -and $url -ne "") {
                Write-Host "Dang tai $name tu $url ..."
                try {
                    $installer = Join-Path $env:TEMP "$( [System.IO.Path]::GetFileName($url) )"
                    Invoke-WebRequest -Uri $url -OutFile $installer -ErrorAction Stop
                    Write-Host "  Tai thanh cong. Dang cai dat..."
                    $proc = Start-Process -FilePath $installer -ArgumentList "/quiet /norestart" -Wait -PassThru -NoNewWindow
                    if ($proc.ExitCode -eq 0) {
                        Write-Host "  [+] $name cai thanh cong."
                    } else {
                        Write-Host "  [-] $name cai that bai (ma $($proc.ExitCode))."
                    }
                    Remove-Item -Path $installer -Force -ErrorAction SilentlyContinue
                } catch {
                    Write-Host "  [-] Loi tai hoac cai: $_"
                }
            } else {
                Write-Host "  [-] Khong co ID winget va URL cho $name. Bo qua."
            }
        }
    }
}

if ($Function) { & $Function }