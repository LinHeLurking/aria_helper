$old = $ErrorActionPreference
$ErrorActionPreference = "SilentlyContinue"

Write-Host "Uninstalling all componets"

Remove-Item .\node_modules -Recurse -Force
Remove-Item .\package-lock.json -Force
Remove-Item .\*.zip
Remove-Item .\*.pid
Remove-Item .\aria2.session -Recurse -Force
Remove-Item .\aria2.log -Recurse -Force
Remove-Item .\aria2c -Recurse -Force
Remove-Item .\ariang -Recurse -Force

$config = Get-Content .\config.json | ConvertFrom-Json
$config.aria2c = "none"
$config.ariang = "none"
$config | ConvertTo-Json | Set-Content .\config.json

$ErrorActionPreference = $old

Write-Host "Removed"