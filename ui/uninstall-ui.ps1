$desktop = [Environment]::GetFolderPath('Desktop')
$startMenu = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'
foreach ($p in @((Join-Path $desktop 'Product Reference Storyboard.lnk'), (Join-Path $startMenu 'Product Reference Storyboard.lnk'))) {
    if (Test-Path $p) { Remove-Item -Force $p }
}
Write-Host 'Companion UI shortcuts removed.'
