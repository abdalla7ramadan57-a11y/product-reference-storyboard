$ErrorActionPreference = 'Stop'
$skillRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$uiScript = Join-Path $skillRoot 'ui\launch-ui.ps1'
$stateDir = Join-Path $HOME '.product-reference-storyboard'
New-Item -ItemType Directory -Force -Path $stateDir | Out-Null

$desktop = [Environment]::GetFolderPath('Desktop')
$startMenu = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'
$wsh = New-Object -ComObject WScript.Shell
foreach ($dir in @($desktop, $startMenu)) {
    $shortcutPath = Join-Path $dir 'Product Reference Storyboard.lnk'
    $shortcut = $wsh.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = 'powershell.exe'
    $shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$uiScript`""
    $shortcut.WorkingDirectory = $skillRoot
    $shortcut.Description = 'Choose video, product image, and output mode'
    $shortcut.Save()
}
Write-Host 'Companion UI installed (Desktop + Start Menu shortcuts).'
