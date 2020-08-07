param (
    [bool]$byName = $false
)

function Stop-Componet {
    param (
        [bool]$byName = $false
    )

    if ($byName) {
        Write-Warning "Stop porcess by name may corupt other process in your computer."
        $config = Get-Content .\config.json | ConvertFrom-Json
        Stop-Process -Name aria2c 
        if ($config.ariang -eq "npm") {
            Stop-Process -Name node
        }
    }
    else {
        if (Test-Path .\aria2.pid) {
            Write-Host "Stop aria"
            [Int32]$id = Get-Content .\aria2.pid
            Stop-Process -Id $id
            Remove-Item .\aria2.pid
        }
        
        if (Test-Path .\node.pid) {
            Write-Host "Stop node http server"
            [Int32]$id = Get-Content .\node.pid
            Stop-Process -Id $id
            Remove-Item .\node.pid
        }
    }
    
}

Stop-Componet $byName