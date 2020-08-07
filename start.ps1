param (
    [switch]$withAriaNg
)

function Start-Aria {
    $config = Get-Content .\config.json | ConvertFrom-Json
    $cmd = ""
    if ($config.aria2c -eq "path") {
        $cmd = "aria2c.exe"
    }
    elseif ($config.aria2c -eq "raw") {
        foreach ($item in (Get-ChildItem .)) {
            if ($item.Name -like "*aria2c*") {
                foreach ($file in (Get-ChildItem $item -Recurse)) {
                    if ($file.Name -eq "aria2c.exe") {
                        $cmd = $file.FullName
                    }
                }
            }
        }
    }
    if (!(Test-Path "aria2.session")) {
        Set-Content -Path "aria2.session" -Value ""
    }
    $ariaP = (Start-Process $cmd -ArgumentList "--conf-path aria.conf -l aria2.log" -WindowStyle Hidden -PassThru)
    # Write-Host $ariaP.Id
    Set-Content -Path "aria2.pid" -Value $ariaP.Id
}

function Start-AriaNg {
    $config = Get-Content .\config.json | ConvertFrom-Json
    if ($config.ariang -eq "npm") {
        Set-Location .\ariang
        $nodeP = (Start-Process node -ArgumentList "../node_modules/http-server/bin/http-server" -WindowStyle Hidden -PassThru)
        Set-Location ..
        # Write-Host $nodeP.Id
        Set-Content -Path "node.pid" -Value $nodeP.Id
        Start-Process "http://127.0.0.1:8080"
    }
    elseif ($config.ariang -eq "raw") {
        $target = ""
        foreach ($item in (Get-ChildItem ariang -Recurse)) {
            if ($item.Name -like "*index*") {
                $target = $item.FullName
                Start-Process $target
            }
        }
        if ($target -eq "") {
            Write-Warning "No AriaNg found, you might need to reinstall by .\reinstall.ps"
        }
        else {
            Start-Process $target
        }
    }
    
}

if ($withAriaNg) {
    .\snoop.ps1 -withAriaNg
}
else {
    .\snoop.ps1
}

Start-Aria

if ($withAriaNg) {
    Start-AriaNg
}

