param(
    [ValidateSet("Agents", "Claude", "Both")]
    [string]$Target = "Both",
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$SkillName = "product-reference-storyboard"
$Source = Split-Path -Parent $MyInvocation.MyCommand.Path

function Install-SkillCopy([string]$BaseDir) {
    $Dest = Join-Path $BaseDir $SkillName
    New-Item -ItemType Directory -Force -Path $BaseDir | Out-Null

    if (Test-Path $Dest) {
        if (-not $Force) {
            throw "Skill already exists at $Dest. Re-run with -Force to replace it."
        }
        Remove-Item -Recurse -Force $Dest
    }

    New-Item -ItemType Directory -Force -Path $Dest | Out-Null
    Get-ChildItem -Force $Source | Where-Object {
        $_.Name -notin @("install.ps1", "uninstall.ps1", "README.md")
    } | Copy-Item -Destination $Dest -Recurse -Force

    Write-Host "Installed $SkillName -> $Dest"
}

if ($Target -in @("Agents", "Both")) {
    Install-SkillCopy (Join-Path $HOME ".agents\skills")
}
if ($Target -in @("Claude", "Both")) {
    Install-SkillCopy (Join-Path $HOME ".claude\skills")
}

$uiInstaller = Join-Path $Source "ui\install-ui.ps1"
if (Test-Path $uiInstaller) {
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $uiInstaller
}

Write-Host "Done. Restart/reload your compatible agent so it can rescan skills."
Write-Host "Companion UI: launch 'Product Reference Storyboard' from Desktop or Start Menu."
Write-Host "For ChatGPT web/desktop Skills, upload the packaged ZIP from the Skills UI; local PowerShell cannot install into the hosted ChatGPT account."
