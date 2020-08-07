function Test-Command {
    param (
        [String]$commandName
    )
    $old = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"
    $result = $false
    try {
        if (Get-Command $commandName) {
            $result = $true
        }
    }
    catch {
        Write-Host "$commandName does not exist"
        $result = $false
    }
    $ErrorActionPreference = $old
    return $result
}

function Test-Proxy {
    Write-Host "Downloading from GitHub release in mainland China is slow. Provide some proxy if you have."
    Write-Host "Input something like http://127.0.0.1:1080. If you don't have any proxy, just enter."
    $proxy = Read-Host
    if ($proxy -eq "") {
        $proxy = "None"
    }
    Write-Host "Using proxy: $proxy"
    return $proxy
}

function GetAriaFromUrl {
    $ret = $false
    $retry = 3

    do {
        try {
            $url = "https://api.github.com/repos/aria2/aria2/releases/latest"
            $json = (Invoke-WebRequest -Uri $url).Content | ConvertFrom-Json 
            foreach ($item in $json.assets) {
                if ($item.name -like "*win-64bit*") {
                    Write-Host "Downloading Arai2c from GitHub release. This porcess might be very slow. Wait with patient. :)"
                    $proxy = Test-Proxy
                    Write-Host "Downloading from " $item.browser_download_url
                    if ($proxy -ne "None") {
                        Invoke-WebRequest -Uri $item.browser_download_url -Proxy $proxy -OutFile "aria2c.zip"
                    }
                    else {
                        Invoke-WebRequest -Uri $item.browser_download_url -OutFile "aria2c.zip"
                    }
                    Expand-Archive "aria2c.zip" -Force
                    $ret = $true
                }
            }
        }
        catch {
            $ret = $false
            Write-Host "ERROR: $_"
            Write-Host "Downloading error. Retrying..."
        }
        $retry = $retry - 1
        Start-Sleep 3
    } while (!$ret -and ($retry -ge 0))

    return $ret
}

function GetAriaNgFromUrl {
    param(
        $config
    )

    Write-Host "Downloading AriaNg"

    $ret = $false
    $retry = 3

    $target = ""
    if ($config.ariang -eq "raw") {
        $target = "AriaNg-[0-9.]+-AllInOne.zip"
    }
    elseif ($config.ariang -eq "npm") {
        $target = "AriaNg-[0-9.]+.zip"
    }

    do {
        try {
            $url = "https://api.github.com/repos/mayswind/AriaNg/releases/latest"
            $json = (Invoke-WebRequest -Uri $url).Content | ConvertFrom-Json
            foreach ($item in $json.assets) {
                if ($item.name -match $target) {
                    Write-Host "Downloading ${item.name} from GitHub release. This porcess might be very slow. Wait with patient. :)"
                    $proxy = Test-Proxy
                    Write-Host "Downloading from " $item.browser_download_url
                    if ($proxy -ne "None") {
                        Invoke-WebRequest -Uri $item.browser_download_url -Proxy $proxy -OutFile "ariang.zip"
                    }
                    else {
                        Invoke-WebRequest -Uri $item.browser_download_url -OutFile "ariang.zip"
                    }
                    Expand-Archive "ariang.zip" -Force
                    $ret = $true
                }
            }
        }
        catch {
            $ret = $false
            Write-Host "ERROR: $_"
            Write-Host "Downloading error. Retrying..."
        }
        $retry = $retry - 1
        Start-Sleep 3
    } while (($retry -gt 0) -and !$ret)

    
    return $ret
}

function Get-Componet {
    $hasScoop = Test-Command scoop 
    $hasNpm = Test-Command npm 
    $config = Get-Content .\config.json | ConvertFrom-Json
    $success = $true

    # if (!(Test-Command aria2c)) {
    if (1) {
        # if ($hasScoop) {
        if (0) {
            scoop install aria2
            if (!$?) {
                $success = $false
            }
            else {
                $config.aria2c = "path"
            }
        }
        else {
            if (GetAriaFromUrl) {
                $config.aria2c = "raw"
            }
            else {
                $success = $false
            }
        }
    }
    else {
        $config.aria2c = "path"
    }

    # if ($hasNpm) {
    if (0) {
        Write-Host "Npm detected. Install http-server by npm"
        npm install http-server
        if (!$?) {
            $success = $false
        }
        $config.ariang = "npm"
    }
    else {
        $config.ariang = "raw"
    }
    $ngstatus = (GetAriaNgFromUrl($config))
    if (!$ngstatus) {
        $success = $false
    }

    if ($success) {
        $config | ConvertTo-Json | Set-Content .\config.json
    }

    return $success
}

function Test-Component {
    $config = Get-Content .\config.json | ConvertFrom-Json
    $prepared = ($config.aria2c -ne "none") -and ($config.ariang -ne "none")
    if (!$prepared) {
        $success = Get-Componet
        if ($success -eq $true) {
            Write-Host "All components are installed correctly"
        }
        else {
            Write-Host "Some components are not installed correctly!"
            Write-Host "Use .\reinstall.ps1 to solve"
            Exit-PSSession
        }
    }
}

Test-Component
