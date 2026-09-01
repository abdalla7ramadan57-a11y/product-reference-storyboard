param(
    [ValidateSet("Agents", "Claude", "Both")]
    [string]$Target = "Both"
)

$SkillName = "product-reference-storyboard"
$Targets = @()
if ($Target -in @("Agents", "Both")) { $Targets += (Join-Path $HOME ".agents\skills\$SkillName") }
if ($Target -in @("Claude", "Both")) { $Targets += (Join-Path $HOME ".claude\skills\$SkillName") }

foreach ($Path in $Targets) {
    if (Test-Path $Path) {
        Remove-Item -Recurse -Force $Path
        Write-Host "Removed $Path"
    } else {
        Write-Host "Not found: $Path"
    }
}
