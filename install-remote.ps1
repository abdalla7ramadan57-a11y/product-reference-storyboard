$ErrorActionPreference = "Stop"

$Repository = "abdalla7ramadan57-a11y/product-reference-storyboard"
$Version = "v4.0.0"
$AssetName = "product-reference-storyboard-skill-v4.0.0.zip"
$ExpectedSha256 = "DA800ACDA82CD1D22E0F062E39025E03C6DFCC1A0C1560D039D6A5CE09876724"
$DownloadUrl = "https://github.com/$Repository/releases/download/$Version/$AssetName"
$TemporaryDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ("product-reference-storyboard-" + [guid]::NewGuid().ToString("N"))
$ArchivePath = Join-Path $TemporaryDirectory $AssetName
$ExtractPath = Join-Path $TemporaryDirectory "extracted"

try {
    New-Item -ItemType Directory -Path $TemporaryDirectory | Out-Null
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ArchivePath -UseBasicParsing

    $ActualSha256 = (Get-FileHash -LiteralPath $ArchivePath -Algorithm SHA256).Hash
    if ($ActualSha256 -ne $ExpectedSha256) {
        throw "Downloaded package checksum mismatch. Expected $ExpectedSha256 but received $ActualSha256."
    }

    Expand-Archive -LiteralPath $ArchivePath -DestinationPath $ExtractPath
    $InstallerPath = Join-Path $ExtractPath "product-reference-storyboard\install.ps1"
    if (-not (Test-Path -LiteralPath $InstallerPath -PathType Leaf)) {
        throw "The release package does not contain product-reference-storyboard\install.ps1."
    }

    $PowerShellExecutable = (Get-Process -Id $PID).Path
    & $PowerShellExecutable -NoLogo -NoProfile -ExecutionPolicy Bypass -File $InstallerPath -Force
    if ($LASTEXITCODE -ne 0) {
        throw "The bundled installer exited with code $LASTEXITCODE."
    }
}
finally {
    if (Test-Path -LiteralPath $TemporaryDirectory) {
        Remove-Item -LiteralPath $TemporaryDirectory -Recurse -Force
    }
}
