param(
    [switch]$withAriaNg = $false
)


.\uninstall.ps1

if ($withAriaNg) {
    .\snoop.ps1 -withAriaNg
}
else {
    .\snoop.ps1
}
